import 'dart:io';
import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'package:dart_aes256/dart_aes256.dart';

Future<void> main(List<String> arguments) async {
  //your text
  print('Input:');
  String? clearText = stdin.readLineSync();
  //random 32 byte (256 bits) key (you can use your own)
  //https://www.kindacode.com/article/flutter-dart-ways-to-generate-random-strings/
  Random random = Random();
  String key = String.fromCharCodes(
    List.generate(32, (index) => random.nextInt(33) + 89),
  );
  print('Random 256 bit key: $key');

  //encrypter
  Encrypter encrypter = getEncrypter(key);
  //encrypt
  Encrypted encrypted = encrypt(encrypter, clearText!, key);
  print('Encrypted input (base64 bytes):${encrypted.base64}');
  //decrypt
  String decrypted = decrypt(encrypter, encrypted, key);
  print('Decrypted input: $decrypted');
}
