import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:app/exceptions/exception.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:app/provider/settings.dart' as settings;
import 'package:encrypt/encrypt.dart';

String _passwordHash = "";
String _keyCipher = "";
String _recoveryKeyCipher = "";
String _recoveryHash = "";

/// [_recovery] temporary storage for the recovery phrase
String? _recovery = "";

// Held in memory
Encrypter? _encrypter;

// Argon2 parameters
const int parallelPower = 4;
const int consumeMemory = 500000;
const int iterations = 9; // 2x recommended minimum
//------------------------------------------------------------------------------
const int pwHashLength = 32;

/// [setPassword] should only be called if setting a password.
/// password is the provided passphrase that the user shall remember
Future<void> setPassword(String password) async {
  if (password.isEmpty) {
    return;
  }
  // Generate the actual signing key
  Key signingKey = Key.fromSecureRandom(pwHashLength);

  // Used for file encryption
  _encrypter = Encrypter(AES(signingKey, mode: AESMode.gcm));
  await _generateKeyEncryptionKey(password, signingKey);
  await _generateRecoveryPhrase(signingKey);
  settings.setEncryptionStatus(true); // password is set, this is true.
}

/// [getRecoveryPhrase] only works once after calling [generateRecoveryPhrase].
String? getRecoveryPhrase() {
  String? temp = _recovery; // This varibel will be cleared once this ends so the phrase is secure.
  _recovery = null;
  return temp;
}

/// [resetCredentials] is the entry point for the reset pasword process
/// Accept user input
/// call this method with that input
/// If matches -> call [setPassword], which will overwrite the credentials
///   Then call [getRecoveryPhrase] which will return and erase the recovery phrase from memory
/// else -> reprompt till successful.
///
/// Either password or recovery phrase will work with this, but it expects
/// the recovery phrase first.
Future<bool> resetCredentials(String phrase) async {
  // Try to unlock assuming password
  // Then try to unlock assuming recovery phrase
  if (await verifyPassword(phrase)) {
    Argon2id hasher = Argon2id(parallelism: parallelPower, memory: consumeMemory, iterations: iterations, hashLength: pwHashLength);
    //Generate KEK for internal encryption of actual key
    SecretKey keyEncryptionKey = await hasher.deriveKeyFromPassword(password: phrase, nonce: IV.fromBase64(_passwordHash.split(':')[0]).bytes.toList());
    List<int> kekBytes = await keyEncryptionKey.extractBytes();

    // Used for Encrypting the secret key, temporary.
    Encrypter keyEncrypter = Encrypter(AES(Key(Uint8List.fromList(kekBytes)), mode: AESMode.gcm));
    // Split the package between the IV and the cipher K
    List<String> package = _keyCipher.split(':');
    IV secretIV = IV.fromBase64(package[0]);
    Encrypted eKey = Encrypted.fromBase64(package[1]);
    package.clear(); // Dont need package anymore

    // the encrypter internall decodes it into a string, so we just re-encode it to get the bytes
    Uint8List keyBytes = Uint8List.fromList(keyEncrypter.decryptBytes(eKey, iv: secretIV));
    Key signingKey = Key(keyBytes);
    //Decrypt database
    signingKey;
    // Wipe
    _passwordHash = "";
    _keyCipher = "";
    _recoveryKeyCipher = "";
    _recoveryHash = "";
    _recovery = "";
    _encrypter = null;
    settings.setConfigured(false);
    settings.setEncryptionStatus(false); // Prevents a soft lock out of the app
    // Externally should call setPassword to complete the reset process.
    await settings.save();
    return true;
  }
  if (await verifyRecoveryPhrase(phrase)) {
    Argon2id hasher = Argon2id(parallelism: parallelPower, memory: consumeMemory, iterations: iterations, hashLength: pwHashLength);
    //Generate KEK for internal encryption of actual key
    SecretKey keyEncryptionKey = await hasher.deriveKeyFromPassword(password: phrase, nonce:  IV.fromBase64(_recoveryHash.split(':')[0]).bytes.toList());
    List<int> kekBytes = await keyEncryptionKey.extractBytes();

    // Used for Encrypting the secret key, temporary.
    Encrypter keyEncrypter = Encrypter(AES(Key(Uint8List.fromList(kekBytes)), mode: AESMode.gcm));
    // Split the package between the IV and the cipher K
    List<String> package = _recoveryKeyCipher.split(':');
    IV secretIV = IV.fromBase64(package[0]);
    Encrypted eKey = Encrypted.fromBase64(package[1]);
    package.clear(); // Dont need package anymore

    // the encrypter internall decodes it into a string, so we just re-encode it to get the bytes
    Uint8List keyBytes = Uint8List.fromList(keyEncrypter.decryptBytes(eKey, iv: secretIV));

    Key signingKey = Key(keyBytes);
    signingKey;
    //Decrypt database

    // Wipe
    _passwordHash = "";
    _keyCipher = "";
    _recoveryKeyCipher = "";
    _recoveryHash = "";
    _recovery = "";
    _encrypter = null;
    settings.setConfigured(false);
    settings.setEncryptionStatus(false); // Prevents a soft lock out of the app
    // Externally should call setPassword to complete the reset process.
    await settings.save();
    return true;
  }
  return false; // Entered is neither password nor recovery phrase...
}

/// [verifyPassword] returns true iff the password parameter matches the stored hash.
Future<bool> verifyPassword(String password) async {
  Argon2id hasher = Argon2id(parallelism: parallelPower, memory: consumeMemory, iterations: iterations, hashLength: pwHashLength);
  //Generate KEK for internal encryption of actual key
  stdout.writeln("$_passwordHash");
  String pwIV = _passwordHash.split(':')[0];
  stdout.writeln("AFTER PWIV $pwIV");
  SecretKey keyEncryptionKey = await hasher.deriveKeyFromPassword(password: password, nonce: IV.fromBase64(pwIV).bytes.toList());
  String maybe = String.fromCharCodes( await keyEncryptionKey.extractBytes());
  String other = _passwordHash.split(':')[1];
  stdout.writeln("AFTER pwHASHED $other");
  return maybe == other;
}

/// [verifyRecoveryPhrase] returns true iff the recovery phrase matches the stored hash.
Future<bool> verifyRecoveryPhrase(String phrase) async {
  Argon2id hasher = Argon2id(parallelism: parallelPower, memory: consumeMemory, iterations: iterations, hashLength: pwHashLength);
  String recIV = _recoveryHash.split(':')[0];
  stdout.writeln("AFTER recIV $recIV");
  SecretKey keyEncryptionKey = await hasher.deriveKeyFromPassword(password: phrase, nonce: IV.fromBase64(recIV).bytes.toList());
  String maybe = String.fromCharCodes( await keyEncryptionKey.extractBytes());
  String other = _recoveryHash.split(':')[1];
  stdout.writeln("AFTER recHASHED $other");
  return maybe == other;
}

/// [unlock] is responsible for unlocking and initializing the application after password has been set
/// The recovery boolean indicates if we are unlocking with the recovery method, this should
/// lead to a password reset, but it is not required.
Future<bool> unlock(String passwordPhrase, [bool recovery = false])  async {
  bool valid = !recovery ? await verifyPassword(passwordPhrase) : await verifyRecoveryPhrase(passwordPhrase);
  if (valid){
    Argon2id hasher = Argon2id(parallelism: parallelPower, memory: consumeMemory, iterations: iterations, hashLength: pwHashLength);
    //Generate KEK for internal encryption of actual key
    SecretKey keyEncryptionKey = await hasher.deriveKeyFromPassword(password: passwordPhrase, nonce: IV.fromBase64((!recovery? _passwordHash : _recoveryHash).split(':')[0]).bytes.toList());
    // Used for Encrypting the secret key, temporary.
    Encrypter keyEncrypter = Encrypter(AES(Key(Uint8List.fromList(await keyEncryptionKey.extractBytes())), mode: AESMode.gcm));
    // Split the package between the IV and the cipher K
    List<String> package = (recovery ? _recoveryKeyCipher.split(':') : _keyCipher.split(':'));
    IV secretIV = IV.fromBase64(package[0]);
    Encrypted eKey = Encrypted.fromBase64(package[1]);
    package.clear(); // Dont need package anymore

    // the encrypter internall decodes it into a string, so we just re-encode it to get the bytes
    Uint8List keyBytes = Uint8List.fromList(keyEncrypter.decryptBytes(eKey, iv: secretIV));

    // Then we form the key from this and make the encryptor
    _encrypter = Encrypter(AES(Key(keyBytes), mode: AESMode.gcm));

    return true;
  }
  else {
    return false;
  }

}

// Utilities --------------------------------------
/// [generateKeyEncryptionKey] Generates an encryption key based on the password supplied and uses it to
/// Encrypt the provided signing Key.
/// the [nonce] [_passwordHash] and [_keyCipher] are all modified by this method
Future<void> _generateKeyEncryptionKey(String password, Key signingKey) async {
  // Encryption Setup
  IV pwIV = IV.fromSecureRandom(16); // 12 bytes = 8 * 12 = 96 bit
  Argon2id hasher = Argon2id(parallelism: parallelPower, memory: consumeMemory, iterations: iterations, hashLength: pwHashLength);

  //Generate KEK for internal encryption of actual key
  SecretKey keyEncryptionKey = await hasher.deriveKeyFromPassword(password: password, nonce: pwIV.bytes.toList());
  List<int> keyBytes = await keyEncryptionKey.extractBytes();
  _passwordHash ="${pwIV.base64}:${String.fromCharCodes(keyBytes)}";
  stdout.writeln("BEFORE PW $_passwordHash");
  // Used for Encrypting the secret key, temporary.
  Encrypter keyEncrypter = Encrypter(
      AES(Key(Uint8List.fromList(keyBytes)), mode: AESMode.gcm));

  // Generate random IV for key signing
  // Need 96 bit IV for clear GCM mode
  IV secretKeyIV = IV.fromSecureRandom(12); // 12 bytes = 8 * 12 = 96 bit
  Encrypted cryptoKey = keyEncrypter.encryptBytes(
      signingKey.bytes, iv: secretKeyIV);
  _keyCipher = "${secretKeyIV.base64}:${cryptoKey.base64}";
  stdout.writeln("BEFORE KEY $_keyCipher");
}

/// [generateRecoveryPhrase] Generates a recovery phrase and uses that to encrypt the provided signingKey
/// The [_recovery] [_recoveryHash] and [_recoveryKeyCipher] are all modified by this method
Future<void> _generateRecoveryPhrase(Key signingKey) async {
  IV recIV = IV.fromSecureRandom(16);
  _recovery = Key
      .fromSecureRandom(20)
      .base64; // Generate random passphrase of sufficient length (stored for user)
  Argon2id hasher = Argon2id(parallelism: parallelPower, memory: consumeMemory, iterations: iterations, hashLength: pwHashLength);

  //Generate KEK for internal encryption of actual key
  SecretKey keyEncryptionKey = await hasher.deriveKeyFromPassword(password: _recovery!, nonce: recIV.bytes.toList());
  List<int> keyBytes = await keyEncryptionKey.extractBytes();
  _recoveryHash = "${recIV.base64}:${String.fromCharCodes(keyBytes)}";
  Encrypter keyEncrypter = Encrypter(
      AES(Key(Uint8List.fromList(keyBytes)), mode: AESMode.gcm));
  stdout.writeln("BEFORE rC $_recoveryHash");
  // Recovery key encryptor
  IV secretKeyIV = IV.fromSecureRandom(12);
  Encrypted cryptoKey = keyEncrypter.encryptBytes(
      signingKey.bytes, iv: secretKeyIV);
  _recoveryKeyCipher = "${secretKeyIV.base64}:${cryptoKey.base64}";
  stdout.writeln("BEFORE rKC $_recoveryKeyCipher");
}

String compressContents() =>
    hexEncode(utf8.encode(
        "$_passwordHash#$_keyCipher#$_recoveryKeyCipher#$_recoveryHash"));

UnmodifiableMapView<String, dynamic> save() =>
    UnmodifiableMapView({
      "data": compressContents(),
      "sig": String.fromCharCodes(sha512.convert(compressContents().codeUnits).bytes),
    });

void load(Map<String, dynamic> map) {
  String data = map['data'];
  List<String> actualData = utf8.decode(hexDecode(data)).split('#');

  String dataSig = String.fromCharCodes(sha512.convert(data.codeUnits).bytes);
  String receivedSig = map['sig'];
  data = "";
  map = {};
  if (dataSig != receivedSig) {
    dataSig = "";
    receivedSig = "";
    actualData.clear();
    throw SignatureMismatchException(
        "Signatures did not match, data integrity has been compromised!");
  }
  // Get the hash, salt is built into the hash
  _passwordHash = actualData[0];
  stdout.writeln("AFTER PW $_passwordHash");
  // Get the cipher
  _keyCipher = actualData[1];
  stdout.writeln("AFTER KC $_keyCipher");
  _recoveryKeyCipher = actualData[2];
  stdout.writeln("AFTER rKC $_recoveryKeyCipher");
  _recoveryHash = actualData[3];
  stdout.writeln("AFTER rC $_recoveryHash");

  actualData.clear();
}

void reset() {
  _encrypter = null;
  _passwordHash = "";
  _keyCipher = "";
}

/// Password can be empty, this is only used if the password is supplied
bool validatePassword(String password) =>
    (password.length >= 10 && // length must be 10+      AND
        password.contains(
            RegExp(r'[!@#$%^&*()]+')) && // contains special char   AND
        password.contains(RegExp(r'\d+'))); // contains at least 1 num

/// This is used within any field that needs to validate a password input.
String? defaultValidator(String? value) =>
    (value == null || value.isEmpty || validatePassword(value)) ?
    null :
    "Passwords must have the following:\n1. 10 or more characters\n2. At least one special character\n3.at least one number (!@#\$%^&*())";

// Encryption -------------------------------------
String encrypt(String plainText) {
  IV secretIV = IV.fromSecureRandom(12);
  final encrypted = _encrypter!.encrypt(plainText, iv: secretIV);
  return '${secretIV.base64}:${encrypted.base64}';
}
String decrypt(String cipherTextb64) {
  List<String> package = cipherTextb64.split(":");
  IV secretIV = IV.fromBase64(package[0]);
  Encrypted cipherText = Encrypted.fromBase64(package[1]);
  final decrypted = _encrypter!.decrypt(cipherText, iv: secretIV);
  return decrypted;
}

// Encodings ---------------------------------------
String hexEncode(List<int> bytes) {
  const hexDigits = '0123456789abcdef';
  var charCodes = Uint8List(bytes.length * 2);
  for (var i = 0, j = 0; i < bytes.length; i++) {
    var byte = bytes[i];
    charCodes[j++] = hexDigits.codeUnitAt((byte >> 4) & 0xF);
    charCodes[j++] = hexDigits.codeUnitAt(byte & 0xF);
  }
  return String.fromCharCodes(charCodes);
}
List<int> hexDecode(String hexString) {
  var bytes = <int>[];
  for (var i = 0; i < hexString.length; i += 2) {
    var byte = int.parse(hexString.substring(i, i + 2), radix: 16);
    bytes.add(byte);
  }
  return bytes;
}