import 'dart:io';
import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:dart_aes256/dart_aes256.dart';

Future<void> main(List<String> arguments) async {
  print('1. Generate random 256 bit key');
  print('2. Encrypt');
  print('3. Decrypt');
  String? option = stdin.readLineSync();
  switch (option) {
    case '1':
      generateKeyExample();
      break;
    case '2':
      encryptExample();
      break;
    case '3':
      decryptExample();
      break;
  }
}

//create key
void generateKeyExample() {
  List<int> key = generateRandomKey();
  print('');
  print('Random 256 bit key (base64 bytes):');
  print(base64.encode(key));
}

//encrypt
void encryptExample() {
  //your text
  print('');
  print('Input:');
  String? clearText = stdin.readLineSync();
  //key
  print('');
  print('256 bit key (base64 bytes):');
  String? base64Key = stdin.readLineSync();
  List<int> key = base64Decode(base64Key!);
  //encrypt
  final encrypter = getEncrypter(key);
  Encrypted encrypted = encrypt(encrypter, clearText!, key);
  print('');
  print('Encrypted output (base64 bytes):');
  print(encrypted.base64);
}

//decrypt
void decryptExample() {
  //encrypted input
  print('');
  print('Encrypted input (base64 bytes):');
  String? input = stdin.readLineSync();
  //key
  print('');
  print('256 bit key (base64 bytes):');
  String? base64Key = stdin.readLineSync();
  List<int> key = base64Decode(base64Key!);
  //decrypt
  final encrypter = getEncrypter(key);
  String decrypted = decrypt(encrypter, Encrypted(base64.decode(input!)), key);
  print('');
  print('Decrypted output:');
  print(decrypted);
}
