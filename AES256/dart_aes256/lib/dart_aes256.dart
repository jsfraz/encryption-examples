import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

//encrypting/decrypting stolen from https://github.com/leocavalcante/encrypt/blob/5.x/example/aes.dart

//create random key
List<int> generateRandomKey() {
  //random 32 byte (256 bits) key (you can use your own)
  Random rnd = Random();
  return List<int>.generate(32, (i) => rnd.nextInt(256));
}

//encrypter
Encrypter getEncrypter(List<int> key) {
  return Encrypter(AES(Key.fromBase64(base64.encode(key)),
      mode: AESMode.cbc, padding: 'PKCS7'));
}

//encrypt (md5 hash of key as IV)
Encrypted encrypt(Encrypter encrypter, String clearText, List<int> key) {
  return encrypter.encrypt(clearText,
      iv: IV.fromBase64(base64.encode(generateMd5(key))));
}

//decrypt (md5 hash of key as IV)
String decrypt(Encrypter encrypter, Encrypted encrypted, List<int> key) {
  return encrypter.decrypt(encrypted,
      iv: IV.fromBase64(base64.encode(generateMd5(key))));
}

//md5 hash from input
List<int> generateMd5(List<int> input) {
  return md5.convert(input).bytes;
}
