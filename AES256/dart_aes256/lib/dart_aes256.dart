import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

//encrypting/decrypting stolen from https://github.com/leocavalcante/encrypt/blob/5.x/example/aes.dart

//encrypter
Encrypter getEncrypter(String key) {
  return Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc, padding: 'PKCS7'));
}

//encrypt (md5 hash of key as IV)
Encrypted encrypt(Encrypter encrypter, String clearText, String key) {
  return encrypter.encrypt(clearText,
      iv: IV.fromBase64(base64.encode(generateMd5(key))));
}

//decrypt (md5 hash of key as IV)
String decrypt(Encrypter encrypter, Encrypted encrypted, String key) {
  return encrypter.decrypt(encrypted,
      iv: IV.fromBase64(base64.encode(generateMd5(key))));
}

//md5 hash from input
List<int> generateMd5(String input) {
  return md5.convert(utf8.encode(input)).bytes;
}
