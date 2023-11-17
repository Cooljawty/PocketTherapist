import 'dart:convert';

import 'package:app/exceptions/exception.dart';
import 'package:app/provider/encryptor.dart' as encrypter;
import 'package:flutter/cupertino.dart';
import 'package:test/test.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();


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
    encrypter.setPassword(password);
    String recoveryPhrase1 = encrypter.getRecoveryPhrase()!;
    stdout.writeln(recoveryPhrase1);

    // reset unlocks with all combinations
    expect(encrypter.unlock(password), true);
    expect(encrypter.unlock(recoveryPhrase1), false); // fails because not in recovery mode
    expect(encrypter.unlock(recoveryPhrase1, true), true);
    expect(encrypter.verifyPassword(password), true);
    expect(encrypter.verifyRecoveryPhrase(recoveryPhrase1), true);

    String cipher = encrypter.encrypt(message);
    expect(cipher != message, true);
    String decrypted = encrypter.decrypt(cipher);
    expect(decrypted == message, true);

    // Erase the encryption key
    bool diff = !encrypter.resetCredentials("${password}diff");
    expect(diff, true); // fail to erase cause wrong password
    diff = !encrypter.resetCredentials(password); // successful
    expect(diff, false);

    encrypter.setPassword(password); // reset w/ savme password
    String recoveryPhrase2 = encrypter.getRecoveryPhrase()!;
    expect(recoveryPhrase1 != recoveryPhrase2, true); // should be different recovery phrases
    diff = !encrypter.resetCredentials(recoveryPhrase2); // reset with the passphrase
    // If password isnt set then we will have no password.
    expect(diff, false);
    encrypter.setPassword(password); // reset the pasword
    cipher = encrypter.encrypt(message);

    Map<String, dynamic> enc = encrypter.save();

    // Encryption key is encrypted inside this, w/ PBKDF
    expect(() => encrypter.load(enc), returnsNormally); // load the encryption key

    // This will overwrite the encrypter with something else, so
    // If it can still decrypt the original cipher text, then it is correct.
    bool valid = encrypter.unlock(password);
    expect(valid, true);
    decrypted = encrypter.decrypt(cipher);
    expect(decrypted == message, true);

    var fake = Map<String, dynamic>.from(enc);
    fake['data'] = encrypter.hexEncode(utf8.encode("PotatoChips"));
    expect(() => encrypter.load(fake), throwsA(isA<SignatureMismatchException>()));

  });


}