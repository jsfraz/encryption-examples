import 'dart:io';
import 'dart:convert';
import 'package:cryptography/cryptography.dart';
//import 'package:dart_x25519/dart_x25519.dart' as dart_x25519;

Future<void> main(List<String> arguments) async {
  //https://pub.dev/documentation/cryptography/latest/cryptography/X25519-class.html

  //x25519 instance
  X25519 algorithm = Cryptography.instance.x25519();
  //new keypair
  SimpleKeyPair keyPair = await algorithm.newKeyPair();
  //32 byte (256 bits) public key
  SimplePublicKey publicKey = await keyPair.extractPublicKey();
  print('256 bit public key (base64 bytes): ${base64.encode(publicKey.bytes)}');
  //input 32 byte (256 bits) remote public key
  print('Input remote public key (base64 bytes):');
  String? remoteKey = stdin.readLineSync();
  SimplePublicKey remotePublicKey =
      SimplePublicKey(base64.decode(remoteKey!), type: KeyPairType.x25519);
  //32 byte (256 bits) shared secret
  SecretKey sharedSecretKey = await algorithm.sharedSecretKey(
    keyPair: keyPair,
    remotePublicKey: remotePublicKey,
  );
  List<int> sharedKeyBytes = await sharedSecretKey.extractBytes();
  print(
      '256 bit shared secret (base64 bytes): ${base64.encode(sharedKeyBytes)}');
}
