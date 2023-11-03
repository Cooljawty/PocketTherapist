import 'package:app/util/encrypt.dart';
import 'package:test/test.dart';

void main() {

  test("Testing encryption and decryption", () {
   String message = "No ill never tell ;)";
   Encryptor("SuperSecretPasssssword");
   String cipherText = Encryptor.encryptAES(message);
   expect(message != cipherText, true);
   String decryptedMessage = Encryptor.decryptAES(cipherText);
   expect(message, decryptedMessage);
  });


}