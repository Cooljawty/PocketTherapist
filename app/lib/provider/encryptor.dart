import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:argon2/argon2.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart';
import 'package:system_info2/system_info2.dart';

Uint8List _passwordHash = Uint8List(512);
String _keyCipher = "";

// Held in memory
Encrypter? encrypter;
// Password Salt
List<int> nonce = [];

const int parallelPower = 4;
const int consumeMemory = 500000;
const int iterations = 8; // 2x recommended minimum
const int hashLength = 512; // length of generated hash

/// If this is the first time opening the app, or encrypting is now enabled.
/// Gen key => Encrypt KEy w/ password using PBKDF2 => Hash using Argon => Save Hash, save encrypted key.
/// keep key in memory, toss password
///
/// Else, ask pass, or skip, no encryption,
///   check hash, if correct, decrypt key, toss password, hold key mem.
/// 
/// This method should only be called if resetting a password.
void setPassword(String password) async {
  if (password.isEmpty) {
    return;
  }
 
  // Encryption Setup
  Random rand = Random.secure();
  nonce = List.generate(32, (index) => rand.nextInt(256));
  
  // This is the key gen function
  Argon2id keyGen = Argon2id(
    parallelism: parallelPower,
    memory: consumeMemory,
    iterations: iterations,
    hashLength: hashLength,
  );
 
  // This is the hasher
  Argon2BytesGenerator hasher = Argon2BytesGenerator();
  hasher.init(Argon2Parameters(2, nonce.toUint8List(), memory: consumeMemory, iterations: iterations, lanes: parallelPower));


  //Generate KEK for internal encryption of actual key
  SecretKey keyEncryptionKey = await keyGen.deriveKeyFromPassword(
    password: password,
    nonce: nonce 
  );
  // Get the raw butes from the kek
  List<int>? kekBytes = await keyEncryptionKey.extractBytes(); // Get bytes from secret key

  // Hash them up
  hasher.generateBytes(kekBytes.toUint8List(), _passwordHash); // Hash secret key
  
  // Used for Encrypting the secret key, temporary.
  Encrypter keyEncrypter = Encrypter(AES(Key(kekBytes.toUint8List()), mode: AESMode.gcm)); 
  kekBytes.clear();// Clear the kek's bytes, no longer needed
  

  // Generate the actual signing key
  Key signingKey = Key.fromSecureRandom(512);

  // Used for file encryption
  encrypter = Encrypter(AES(signingKey, mode: AESMode.gcm));

  // Generate random IV for key signing
  IV secretKeyIV = IV.fromSecureRandom(96);
  // Encrypt the key with its IV
  Encrypted cryptoKey = keyEncrypter.encryptBytes(signingKey.bytes, iv: secretKeyIV);
  signingKey.bytes.clear(); // Remove it from memory

  // Store the cipher
  _keyCipher = secretKeyIV.base64 + "\$" + cryptoKey.base64;

  // clear the reset
  secretKeyIV.bytes.clear();
  cryptoKey.bytes.clear();
}


/// Password can be empty, this is only used if the password is supplied
bool validatePasswordField(String password) => (password.length >= 10 &&    // length must be 10+      AND
      password.contains(RegExp(r'[!@#$%^&*()]+')) &&  // contains special char   AND
      password.contains(RegExp(r'\d+')));           // contains at least 1 num

String? defaultValidator(String? value) =>
    (value == null || value.isEmpty || validatePasswordField(value)) ?
    null :
    "Passwords must have the following:\n1. 10 or more characters\n2. At least one special character\n3.at least one number (!@#\$%^&*())";

bool _verifyPassword(String password){
  Argon2BytesGenerator hasher = Argon2BytesGenerator();
  hasher.init(Argon2Parameters(2, nonce.toUint8List(), memory: consumeMemory, iterations: iterations, lanes: parallelPower));
  Uint8List maybe = Uint8List(512);
  hasher.generateBytesFromString(password, maybe);
  return _hexEncode(_passwordHash) == _hexEncode(maybe);
}

Future<bool> unlock(String password) async {
  if (_verifyPassword(password)){
   // This is the key gen function
   // This is the key gen function
    Argon2id keyGen = Argon2id(
      parallelism: parallelPower,
      memory: consumeMemory,
      iterations: iterations,
      hashLength: hashLength,
    );
    //Generate KEK for internal encryption of actual key
    SecretKey keyEncryptionKey = await keyGen.deriveKeyFromPassword(
      password: password,
      nonce: nonce 
    );
    // Get the raw butes from the kek
    List<int>? bytes = await keyEncryptionKey.extractBytes(); // Get bytes from secret key
    // Used for Encrypting the secret key, temporary.
    Encrypter keyEncrypter = Encrypter(AES(Key(bytes.toUint8List()), mode: AESMode.gcm)); 
    bytes.clear(); // Clear the kek's bytes, no longer needed
    
    // Split the package between the IV and the cipherKey
    List<String> package = _keyCipher.split('\$');
    IV secretIV = IV.fromBase64(package[0]);
    Encrypted eKey = Encrypted.fromBase64(package[1]);
    package.clear(); // Dont need package anymore

    // the encrypter internall decodes it into a string, so we just re-encode it to get the bytes
    Uint8List key = utf8.encode(keyEncrypter.decrypt(eKey, iv: secretIV)).toUint8List();
    // Then we form the key from this and make the encryptor
    encrypter = Encrypter(AES(Key(key), mode: AESMode.gcm));
    key.clear();
    
    return true;
  } else {
    return false;
  }

}


// Utilities --------------------------------------
String _compress() {
    final pass = _hexEncode(_passwordHash.toList());
    final salt = _hexEncode(nonce);
    return _hexEncode(utf8.encode("$salt:$pass:$_keyCipher"));
}

bool load(Map<String, dynamic> map) {
  String data = map['data'];
  Digest? receivedSig = Digest(_hexDecode(map['sig']));
  Digest? dataSig = sha512.convert(utf8.encode(data));
  bool verified = dataSig == receivedSig;
  List<String> actualData = utf8.decode(_hexDecode(data)).split(':');
  
  //Get the salt
  nonce = _hexDecode(actualData[0]);
  // Get the hash
  _passwordHash = _hexDecode(actualData[1]).toUint8List();
  // Get the cipher
  _keyCipher = actualData[2];
  /// eventually do something with IV and key, then toss the hashes from memory.

  data = "";
  map = {};
  receivedSig = null;
  dataSig = null;
  return verified;
}

void reset(){
  encrypter = null;
  _passwordHash.clear();
  _passwordHash = Uint8List(512);
  _keyCipher = "";
}

UnmodifiableMapView<String, dynamic> save() =>
  UnmodifiableMapView({
    "data": _compress(),
    "sig": sha512.convert(utf8.encode(_compress())).toString(),
  });


// Encryption -------------------------------------

String encrypt(String plainText) {
  IV secretIV = IV.fromSecureRandom(96);
  final encrypted = encrypter!.encrypt(plainText, iv: secretIV);
  return secretIV.base64 + '\$' + encrypted.base64;
}

String decrypt(String cipherTextb64) {
  List<String> package = cipherTextb64.split("\$");
  IV secretIV = IV.fromBase64(package[0]);
  Encrypted cipherText = Encrypted.fromBase64(package[1]);
  final decrypted = encrypter!.decrypt(cipherText, iv: secretIV);
  return decrypted;
}


// Encodings ---------------------------------------
String _hexEncode(List<int> bytes) {
  const hexDigits = '0123456789abcdef';
  var charCodes = Uint8List(bytes.length * 2);
  for (var i = 0, j = 0; i < bytes.length; i++) {
    var byte = bytes[i];
    charCodes[j++] = hexDigits.codeUnitAt((byte >> 4) & 0xF);
    charCodes[j++] = hexDigits.codeUnitAt(byte & 0xF);
  }
  return String.fromCharCodes(charCodes);
}
List<int> _hexDecode(String hexString) {
  var bytes = <int>[];
  for (var i = 0; i < hexString.length; i += 2) {
    var byte = int.parse(hexString.substring(i, i + 2), radix: 16);
    bytes.add(byte);
  }
  return bytes;
}
