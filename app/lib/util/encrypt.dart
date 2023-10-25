import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Encryptor {
  static Encryptor? self;
  late final Key signingKey;
  late final Encrypter? encrypter;

  //For AES Encryption/Decryption
  Encryptor(String password) {
    /// If this is the first time opening the app, or encrypting is now enabled.
    /// Gen key => Encrypt KEy w/ password using PBKDF2 => Hash using Argon => Save Hash, save encrypted key.
    /// keep key in memory, toss password
    ///
    /// Else, ask pass, or skip, no encryption,
    ///   check hash, if correct, decrypt key, toss password, hold key mem.
    signingKey = Key.fromSecureRandom(256);
    encrypter = Encrypter(AES(signingKey, mode: AESMode.ecb));
    self = this;
  }

  static String encryptAES(String plainText) {
    if (self == null) throw StateError(
        "Encryptor was not properly initialized");
    final encrypted = self!.encrypter!.encrypt(plainText);
    return encrypted.base64;
  }

  static String decryptAES(String cipherTextb64) {
    if (self == null) throw StateError(
        "Encryptor was not properly initialized");
    Encrypted cipherText = Encrypted.fromBase64(cipherTextb64);
    final decrypted = self!.encrypter!.decrypt(cipherText);
    return decrypted;
  }

  static String hash(String password) {
    if (self == null) throw StateError(
        "Encryptor was not properly initialized");
  }
}