import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

String _passwordHash = "";
String _ivCipherText= "";
String _keyCipherText= "";

void setPassword(String password) {
  //Do hash things

  _passwordHash = password;
}

/// Password can be empty, this is only used if the password is supplied
bool validatePasswordField(String password) => (password.length >= 10 &&                       // length must be 10+      AND
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
  _passwordHash = "";
  _ivCipherText = "";
  _keyCipherText = "";
}

UnmodifiableMapView<String, dynamic> save() =>
  UnmodifiableMapView({
    "data": _compress(),
    "sig": sha512.convert(utf8.encode(_compress())).toString(),
  });

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