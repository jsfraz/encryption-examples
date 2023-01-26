import 'dart:io';
import '../lib/dart_rsa.dart';

//stolen from https://github.com/bcgit/pc-dart/blob/master/tutorials/rsa.md
//https://stackoverflow.com/questions/70552248/how-to-set-pkcs1-v1-5-padding-to-rsa-in-dart
Future<void> main() async {
  print('1. Generate and save public and private keys');
  print('2. Encrypt using custom RSA public key');
  print('3. Decrypt using custom RSA private key');
  print('4. Generate keypair, encrypt and decrypt');
  String? option = stdin.readLineSync();
  print('');
  switch (option) {
    case '1':
      generateAndSaveKeysExample();
      break;
    case '2':
      encryptExample();
      break;
    case '3':
      decryptExample();
      break;
    case '4':
      encryptDecryptExample();
      break;
  }
}
