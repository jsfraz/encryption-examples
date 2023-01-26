import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';

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
  print('Where would you like to save genearted keys?');
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
  final privateKey =
      CryptoUtils.rsaPrivateKeyFromPem(File(keyPath!).readAsStringSync());
  //decrypt
  Uint8List decrypted = rsaDecrypt(privateKey, base64.decode(cipherText!));
  print('');
  print('Decrypted output (base64 bytes):');
  print(utf8.decode(decrypted));
}

//generate key, encrypt, decrypt
void encryptDecryptExample() {
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
    case '2':
      keySize = 1024;
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
  //input
  print('');
  print('Input:');
  String? clearText = stdin.readLineSync();
  final pair = generateKeypair(keySize);
  final publicKey = pair.publicKey as RSAPublicKey;
  final privateKey = pair.privateKey as RSAPrivateKey;
  //encrypt
  Uint8List encrypted =
      rsaEncrypt(publicKey, utf8.encode(clearText!) as Uint8List);
  print('');
  print('Encrypted input (base64 bytes):');
  print(base64.encode(encrypted));
  //decrypt
  Uint8List decrypted = rsaDecrypt(privateKey, encrypted);
  print('');
  print('Decrypted output:');
  print(utf8.decode(decrypted));
}

//generates rsa keypair
AsymmetricKeyPair<PublicKey, PrivateKey> generateKeypair(int keySize) {
  //generator
  final keyGen = KeyGenerator('RSA');
  SecureRandom mySecureRandom = SecureRandom('Fortuna')
    ..seed(
        KeyParameter(Platform.instance.platformEntropySource().getBytes(32)));
  //initialization
  final rsaParams =
      RSAKeyGeneratorParameters(BigInt.parse('65537'), keySize, 64);
  final paramsWithRnd = ParametersWithRandom(rsaParams, mySecureRandom);
  keyGen.init(paramsWithRnd);
  //keypair
  return keyGen.generateKeyPair();
}

//encrypt
Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
  final encryptor = PKCS1Encoding(RSAEngine())
    ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic));

  return _processInBlocks(encryptor, dataToEncrypt);
}

//decrypt
Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
  final decryptor = PKCS1Encoding(RSAEngine())
    ..init(false, PrivateKeyParameter<RSAPrivateKey>(myPrivate));

  return _processInBlocks(decryptor, cipherText);
}

Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
  final numBlocks = input.length ~/ engine.inputBlockSize +
      ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

  final output = Uint8List(numBlocks * engine.outputBlockSize);

  var inputOffset = 0;
  var outputOffset = 0;
  while (inputOffset < input.length) {
    final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
        ? engine.inputBlockSize
        : input.length - inputOffset;

    outputOffset += engine.processBlock(
        input, inputOffset, chunkSize, output, outputOffset);

    inputOffset += chunkSize;
  }

  return (output.length == outputOffset)
      ? output
      : output.sublist(0, outputOffset);
}
