import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

class HashService {
  static const int iterations = 100000;
  static const int keyLength = 256 ~/ 8;

  static String generateHash(String password, Uint8List salt) {
    var hmac = Hmac(sha256, utf8.encode(password));
    var digest = hmac.convert(salt);
    return base64Encode(digest.bytes);
  }

  static bool validatePassword(String password, String hashAndSalt) {
    var hashAndSaltParts = hashAndSalt.split('\&');
    var hash = hashAndSaltParts[0];
    var salt = hashAndSaltParts[1];
    var saltBytes = base64Decode(salt);
    var generatedHash = generateHash(password, saltBytes);
    return hash == generatedHash;
  }
}