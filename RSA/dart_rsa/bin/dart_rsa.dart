import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dart_rsa/dart_rsa.dart';
import 'package:basic_utils/basic_utils.dart';

//stolen from https://github.com/bcgit/pc-dart/blob/master/tutorials/rsa.md
//https://stackoverflow.com/questions/70552248/how-to-set-pkcs1-v1-5-padding-to-rsa-in-dart
Future<void> main() async {
  print('1. Generate and save public and private keys');
  print('2. Encrypt');
  print('3. Decrypt');
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
  }
}

//generate and save keys
void generateAndSaveKeysExample() {
  //key size (512 bit, 1024 bit, 2048 bit, 4096 bit)
  int keySize = 1024;
  print('Choose key size:');
  print('1. 512 bit');
  print('2. 1024 bit');
  print('3. 2048 bit');
  print('4. 4096 bit');
  String? strenghtOption = stdin.readLineSync();
  switch (strenghtOption) {
    case '1':
      keySize = 512;
      break;
    case '3':
      keySize = 2048;
      break;
    case '4':
      keySize = 4096;
      break;
    default:
      print('Switching to default 1024 bit key.');
      break;
  }
  print('');
  print('Where would you like to save generated keys?');
  String? keysPath = stdin.readLineSync();
  final keypair = generateKeypair(keySize);
  final publicKey = keypair.publicKey as RSAPublicKey;
  final privateKey = keypair.privateKey as RSAPrivateKey;
  //public key pem
  String publicKeyPem = CryptoUtils.encodeRSAPublicKeyToPem(publicKey);
  File('$keysPath/publicKey.pem').writeAsString(publicKeyPem);
  print('');
  print('Generated public key (PEM format using the PKCS#8 standard):');
  print(publicKeyPem);
  //private key PEM
  String privateKeyPem = CryptoUtils.encodeRSAPrivateKeyToPem(privateKey);
  File('$keysPath/privateKey.pem').writeAsStringSync(privateKeyPem);
  print('');
  print('Generated private key (PEM format using the PKCS#8 standard):');
  print(privateKeyPem);
}

//encrypt using custom public key
void encryptExample() {
  //input
  print('Input:');
  String? clearText = stdin.readLineSync();
  //import public key
  print('');
  print('Public key PEM file path (PKCS#8 standard):');
  String? keyPath = stdin.readLineSync();
  final publicKey =
      CryptoUtils.rsaPublicKeyFromPem(File(keyPath!).readAsStringSync());
  //encrypt
  Uint8List encrypted =
      rsaEncrypt(publicKey, utf8.encode(clearText!) as Uint8List);
  print('');
  print('Encrypted output (base64 bytes):');
  print(base64.encode(encrypted));
}

//dencrypt using custom private key
void decryptExample() {
  //input
  print('Encrypted input (base64 bytes):');
  String? cipherText = stdin.readLineSync();
  //import private key
  print('');
  print('Private key PEM file path (PKCS#8 standard):');
  String? keyPath = stdin.readLineSync();
  final privateKey = CryptoUtils.rsaPrivateKeyFromPem(
      File('${keyPath!}/privateKey.pem').readAsStringSync());
  //decrypt
  Uint8List decrypted = rsaDecrypt(privateKey, base64.decode(cipherText!));
  print('');
  print('Decrypted output:');
  print(utf8.decode(decrypted));
}
