package com.example;
import java.util.Base64;
import java.security.InvalidKeyException;
import com.google.crypto.tink.subtle.X25519;

public class App {
    public static void main(String[] args) throws InvalidKeyException {
        // new keypair
        byte[] privateKey = X25519.generatePrivateKey();
        byte[] publicKey = X25519.publicFromPrivate(privateKey);
        //32 byte (256 bits) public key
        System.out.println("256 bit public key (base64 bytes): " + Base64.getEncoder().encodeToString(publicKey));
        //input 32 byte (256 bits) remote public key
        System.out.println("Input remote public key (base64 bytes):");
        String remoteKey = System.console().readLine();
        //32 byte (256 bits) shared secret
        byte[] sharedSecret = X25519.computeSharedSecret(privateKey, Base64.getDecoder().decode(remoteKey));
        System.out.println("256 bit shared secret (base64 bytes): " + Base64.getEncoder().encodeToString(sharedSecret));
    }
}
