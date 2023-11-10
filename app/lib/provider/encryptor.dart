import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:app/exceptions/exception.dart';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart';
import 'package:hashlib/hashlib.dart';

String _passwordHash = "";
String _keyCipher = "";

// Held in memory
Encrypter? encrypter;
// Password Salt
List<int> nonce = [];

// Argon2 parameters
const int parallelPower = 4;
const int consumeMemory = 500000;
const int iterations = 8; // 2x recommended minimum
//------------------------------------------------------------------------------
const int pwHashLength = 32;

/// If this is the first time opening the app, or encrypting is now enabled.
/// Gen key => Encrypt KEy w/ password using PBKDF2 => Hash using Argon => Save Hash, save encrypted key.
/// keep key in memory, toss password
///
/// Else, ask pass, or skip, no encryption,
///   check hash, if correct, decrypt key, toss password, hold key mem.
/// 
/// This method should only be called if resetting a password.
Future<void> setPassword(String password) async {
  if (password.isEmpty) {
    return;
  }

  // Encryption Setup
  Random rand = Random.secure();
  nonce = List<int>.generate(16, (index) => rand.nextInt(256));

  // This is the key gen function
  Argon2id keyGen = Argon2id(
    parallelism: parallelPower,
    memory: consumeMemory,
    iterations: iterations,
    hashLength: pwHashLength,
  );

  //Generate KEK for internal encryption of actual key
  SecretKey keyEncryptionKey = await keyGen.deriveKeyFromPassword(
    password: password,
    nonce: nonce
  );
  // hash the
  List<int>? kekBytes = await keyEncryptionKey.extractBytes(); // Get bytes from secret key
  Argon2 argon = Argon2(salt: nonce, hashLength: pwHashLength, iterations: iterations, parallelism: parallelPower, memorySizeKB: consumeMemory);
  _passwordHash = argon.encode(kekBytes);

  // Used for Encrypting the secret key, temporary.
  Encrypter keyEncrypter = Encrypter(AES( Key(Uint8List.fromList(kekBytes)), mode: AESMode.gcm));
  kekBytes = null;// Clear the kek's bytes, no longer needed

  // Generate the actual signing key
  Key signingKey = Key.fromSecureRandom(pwHashLength);
  // Used for file encryption
  encrypter = Encrypter(AES(signingKey, mode: AESMode.gcm));

  // Generate random IV for key signing
  // Need 96 bit IV for clear GCM mode
  IV secretKeyIV = IV.fromSecureRandom(12); // 12 bytes = 8 * 12 = 96 bit
  // Encrypt the key with its IV
  Encrypted cryptoKey = keyEncrypter.encryptBytes(signingKey.bytes, iv: secretKeyIV);
  // Store the cipher
  _keyCipher = "${secretKeyIV.base64}:${cryptoKey.base64}";
}


/// Password can be empty, this is only used if the password is supplied
bool validatePasswordField(String password) => (password.length >= 10 &&    // length must be 10+      AND
      password.contains(RegExp(r'[!@#$%^&*()]+')) &&  // contains special char   AND
      password.contains(RegExp(r'\d+')));           // contains at least 1 num

/// This is used within any field that needs to validate a password input.
String? defaultValidator(String? value) =>
    (value == null || value.isEmpty || validatePasswordField(value)) ?
    null :
    "Passwords must have the following:\n1. 10 or more characters\n2. At least one special character\n3.at least one number (!@#\$%^&*())";


/// This function is responsible for unlocking and initializing the application after password has been set
/// [setPassword] should not be used unless part of a reset.
Future<bool> unlock(String password) async {
  Argon2id keyGen = Argon2id(
    parallelism: parallelPower,
    memory: consumeMemory,
    iterations: iterations,
    hashLength: pwHashLength,
  );
  //Generate KEK for internal encryption of actual key
  SecretKey keyEncryptionKey = await keyGen.deriveKeyFromPassword(
      password: password,
      nonce: nonce
  );

  // Get the raw butes from the kek
  List<int>? kekBytes = await keyEncryptionKey.extractBytes(); // Get bytes from secret key
  Argon2 argon = Argon2(salt: nonce, hashLength: pwHashLength, iterations: iterations, parallelism: parallelPower, memorySizeKB: consumeMemory);
  String maybe = argon.encode(kekBytes);
  bool valid = maybe == _passwordHash;

  if (valid){
    // Used for Encrypting the secret key, temporary.
    Encrypter keyEncrypter = Encrypter(AES(Key(Uint8List.fromList(kekBytes)), mode: AESMode.gcm));
    kekBytes = null; // Clear the kek's bytes, no longer needed

    // Split the package between the IV and the cipher Key
    List<String> package = _keyCipher.split(':');
    IV secretIV = IV.fromBase64(package[0]);
    Encrypted eKey = Encrypted.fromBase64(package[1]);
    package.clear(); // Dont need package anymore

    // the encrypter internall decodes it into a string, so we just re-encode it to get the bytes
    Uint8List keyBytes = Uint8List.fromList(keyEncrypter.decryptBytes(eKey, iv: secretIV));

    // Then we form the key from this and make the encryptor
    encrypter = Encrypter(AES(Key(keyBytes), mode: AESMode.gcm));
    
    return true;
  } else {
    return false;
  }

}

// Utilities --------------------------------------
String compressContents() => hexEncode(utf8.encode("${String.fromCharCodes(nonce)}#$_passwordHash#$_keyCipher"));

UnmodifiableMapView<String, dynamic> save() =>
    UnmodifiableMapView({
      "data": compressContents(),
      "sig": sha512sum(compressContents()),
    });

void load(Map<String, dynamic> map) {
  String data = map['data'];
  List<String> actualData = utf8.decode(hexDecode(data)).split('#');

  String dataSig = sha512sum(data);
  String receivedSig = map['sig'];
  data = "";
  map = {};
  if (dataSig != receivedSig) {
     dataSig = "";
     receivedSig = "";
     actualData.clear();
     throw SignatureMismatchException("Signatures did not match, data integrity has been compromised!");
  }
  //Get the salt
  nonce = actualData[0].codeUnits;
  // Get the hash
  _passwordHash = actualData[1];
  // Get the cipher
  _keyCipher = actualData[2];
  actualData.clear();
}

void reset(){
  encrypter = null;
  _passwordHash = "";
  _keyCipher = "";
}


// Encryption -------------------------------------
String encrypt(String plainText) {
  IV secretIV = IV.fromSecureRandom(12);
  final encrypted = encrypter!.encrypt(plainText, iv: secretIV);
  return '${secretIV.base64}:${encrypted.base64}';
}
String decrypt(String cipherTextb64) {
  List<String> package = cipherTextb64.split(":");
  IV secretIV = IV.fromBase64(package[0]);
  Encrypted cipherText = Encrypted.fromBase64(package[1]);
  final decrypted = encrypter!.decrypt(cipherText, iv: secretIV);
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
