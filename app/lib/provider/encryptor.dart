import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart';
import 'package:system_info2/system_info2.dart';

// Static Storage
List<int> _passwordHash = [];
List<int> _ivCipher= [];
List<int> _keyCipher= [];

// Live - Only in memory
SecretKey? keyEncryptionKey;

// Only held during creation
IV? signingIV;
// Only held during creation
Key? signingKey;
// Held in memory
Encrypter? encrypter;
// Only saved during creation
List<int>? nonce;

Argon2id? hasher;


/// If this is the first time opening the app, or encrypting is now enabled.
/// Gen key => Encrypt KEy w/ password using PBKDF2 => Hash using Argon => Save Hash, save encrypted key.
/// keep key in memory, toss password
///
/// Else, ask pass, or skip, no encryption,
///   check hash, if correct, decrypt key, toss password, hold key mem.
void setPassword(String password) async {
  // Encryption Setup
  {
    Random rand = Random.secure();
    nonce = List.generate(32, (index) => rand.nextInt(256));
    // PBKDF2 setup
    {
      // Salt
      // According to argon2 specs, #CPU cores x 2 (threads)
      int parallelPower = SysInfo.cores.length * 2;
      // Free memory in this application in bytes
      int freeMemory = SysInfo.getFreeVirtualMemory();
      // We will use no less than 500MB (500000 bytes) but no more than 1.5Gb (1_500_000 bytes)
      // Most mobile platforms use 4-5Gb in just running android. 
      // most mobile platform cap at 8GB of ram
      int consumeMemory = min(max(freeMemory, 500000), 1500000);
      int iterations = 8; // 2x recommended minimum
      int hashLength = 512; // length of generated hash
      hasher = Argon2id(
        parallelism: parallelPower,
        memory: consumeMemory,
        iterations: iterations,
        hashLength: hashLength,
      );
    }
    
    assert(hasher != null);

    //Do hash things
    keyEncryptionKey = await hasher!.deriveKeyFromPassword(
      password: password,
      nonce: nonce! 
    );
  }
  signingKey = Key.fromSecureRandom(512);
  encrypter = Encrypter(AES(signingKey!, mode: AESMode.gcm));
  _passwordHash = await keyEncryptionKey!.extractBytes();

  _keyCipher =  
  _ivCipher = 
}


/// Password can be empty, this is only used if the password is supplied
bool validatePasswordField(String password) => (password.length >= 10 &&    // length must be 10+      AND
      password.contains(RegExp(r'[!@#$%^&*()]+')) &&  // contains special char   AND
      password.contains(RegExp(r'\d+')));           // contains at least 1 num

String? defaultValidator(String? value) =>
    (value == null || value.isEmpty || validatePasswordField(value)) ?
    null :
    "Passwords must have the following:\n1. 10 or more characters\n2. At least one special character\n3.at least one number (!@#\$%^&*())";

bool verifyPassword(String password){
    // do hash things, then compare to hashing
    return password == _passwordHash;
}


// Utilities --------------------------------------
String _compress() =>
    _hexEncode(utf8.encode("$_passwordHash:$_ivCipherText:$_keyCipherText"));

bool load(Map<String, dynamic> map) {
  String data = map['data'];
  Digest? receivedSig = Digest(_hexDecode(map['sig']));
  Digest? dataSig = sha512.convert(utf8.encode(data));
  bool verified = dataSig == receivedSig;
  List<String> actualData = utf8.decode(_hexDecode(data)).split(':');
  _passwordHash = actualData[0];
  _ivCipherText = actualData[1];
  _keyCipherText = actualData[2];
  /// eventually do something with IV and key, then toss the hashes from memory.
  data = "";
  map = {};
  receivedSig = null;
  dataSig = null;
  return verified;
}

void reset(){
  encrypter = null;
  signingIV = null;
  signingKey = null;
  _passwordHash = "";
  _ivCipherText = "";
  _keyCipherText = "";
}

UnmodifiableMapView<String, dynamic> save() =>
  UnmodifiableMapView({
    "data": _compress(),
    "sig": sha512.convert(utf8.encode(_compress())).toString(),
  });

bool unlock(String password){
   


}

// Encryption -------------------------------------

String encryptAES(String plainText) {
  final encrypted = encrypter!.encrypt(plainText);
  return encrypted.base64;
}

String decryptAES(String cipherTextb64) {
  Encrypted cipherText = Encrypted.fromBase64(cipherTextb64);
  final decrypted = encrypter!.decrypt(cipherText);
  return decrypted;
}


// Hasing -----------------------------------------
String hash(String input) {

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
