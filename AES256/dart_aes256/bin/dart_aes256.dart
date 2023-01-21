import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:dart_aes256/dart_aes256.dart';

Future<void> main(List<String> arguments) async {
  //your text
  print('Input:');
  String? clearText = stdin.readLineSync();
  //random 32 byte (256 bits) key (you can use your own)
  Random rnd = Random();
  List<int> key = List<int>.generate(32, (i) => rnd.nextInt(256));
  print('Random 256 bit key (base64 bytes): ${base64.encode(key)}');

  //encrypter
  Encrypter encrypter = getEncrypter(key);
  //encrypt
  Encrypted encrypted = encrypt(encrypter, clearText!, key);
  print('Encrypted input (base64 bytes): ${encrypted.base64}');
  //decrypt
  String decrypted = decrypt(encrypter, encrypted, key);
  print('Decrypted input: $decrypted');
}
