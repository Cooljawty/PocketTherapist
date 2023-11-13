import 'dart:convert';

import 'package:app/exceptions/exception.dart';
import 'package:app/provider/encryptor.dart' as encrypter;
import 'package:test/test.dart';
import 'dart:io';

void main() {
  test("Testing hex encode and decode", () {
    String message = "No ill never tell ;)";
    stdout.writeln(message);
    String hex =encrypter.hexEncode(message.codeUnits);
    stdout.writeln(hex);
    expect(message != hex, true);
    List<int> stringCodeUnits = encrypter.hexDecode(hex);
    String original = String.fromCharCodes(stringCodeUnits);
    stdout.writeln(original);
    expect(message == original, true);
  });

  test("Testing encryption and decryption", () async {
    String message = "No ill never tell ;)";
    String password = "password123@";
    // After setting the password we should be able to encrypt and decrypt
    await encrypter.setPassword(password);
    expect(encrypter.nonce, isNotNull);
    String cipher = encrypter.encrypt(message);
    expect(cipher != message, true);
    String decrypted = encrypter.decrypt(cipher);
    expect(decrypted == message, true);

    Map<String, dynamic> enc = encrypter.save();
    // Erase the encryption key
    encrypter.reset();
    // Encryption key is encrypted inside this, w/ PBKDF
    expect(() => encrypter.load(enc), returnsNormally);

    // This will overwrite the encrypter with something else, so
    // If it can still decrypt the original cipher text, then it is correct.
    bool valid = await encrypter.unlock(password);
    expect(valid, true);
    decrypted = encrypter.decrypt(cipher);
    expect(decrypted == message, true);

    var fake = Map<String, dynamic>.from(enc);
    fake['data'] = encrypter.hexEncode(utf8.encode("PotatoChips"));
    expect(() => encrypter.load(fake), throwsA(isA<SignatureMismatchException>()));

  });


}