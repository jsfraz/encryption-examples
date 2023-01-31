import java.io.File;
import java.util.List;
import java.util.Base64;
import java.io.FileWriter;
import java.nio.file.Path;
import javax.crypto.Cipher;
import java.util.ArrayList;
import java.io.IOException;
import java.nio.file.Files;
import java.security.KeyPair;
import java.security.PublicKey;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.KeyPairGenerator;
import javax.crypto.BadPaddingException;
import java.security.InvalidKeyException;
import java.security.spec.EncodedKeySpec;
import java.nio.charset.StandardCharsets;
import javax.crypto.NoSuchPaddingException;
import java.security.spec.X509EncodedKeySpec;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.NoSuchAlgorithmException;
import javax.crypto.IllegalBlockSizeException;
import java.security.spec.InvalidKeySpecException;

// stolen from https://www.baeldung.com/java-rsa
// https://www.baeldung.com/java-read-pem-file-keys
public class App {
    public static void main(String[] args) throws Exception {
        System.out.println("1. Generate and save public and private keys");
        System.out.println("2. Encrypt");
        System.out.println("3. Decrypt");
        String option = System.console().readLine();
        System.out.println();
        switch (option) {
            case "1":
                generateAndSaveKeysExample();
                break;
            case "2":
                encryptExample();
                break;
            case "3":
                decryptExample();
                break;
        }
    }

    // generate and save keys
    public static void generateAndSaveKeysExample() throws NoSuchAlgorithmException, IOException {
        // key size (512 bit, 1024 bit, 2048 bit, 4096 bit)
        int keySize = 1024;
        System.out.println("Choose key size:");
        System.out.println("1. 512 bit");
        System.out.println("2. 1024 bit");
        System.out.println("3. 2048 bit");
        System.out.println("4. 4096 bit");
        String strenghtOption = System.console().readLine();
        switch (strenghtOption) {
            case "1":
                keySize = 512;
                break;
            case "3":
                keySize = 2048;
                break;
            case "4":
                keySize = 4096;
                break;
            default:
                System.out.println("Switching to default 1024 bit key.");
                break;
        }
        System.out.println("");
        System.out.println("Where would you like to save generated keys?");
        String keysPath = System.console().readLine();
        KeyPair keypair = generateKeypair(keySize);
        PublicKey publicKey = keypair.getPublic();
        PrivateKey privateKey = keypair.getPrivate();
        // public key pem
        String publicPem = keyToPem(publicKey.getEncoded(), KeyType.PUBLIC);
        FileWriter publicKeyWriter = new FileWriter(keysPath + "/publicKey.pem");
        publicKeyWriter.write(publicPem);
        publicKeyWriter.close();
        System.out.println("");
        System.out.println("Generated public key (PEM format using the PKCS#8 standard):");
        System.out.println(publicPem);
        // private key pem
        String privatePem = keyToPem(privateKey.getEncoded(), KeyType.PRIVATE);
        FileWriter privateKeyWriter = new FileWriter(keysPath + "/privateKey.pem");
        privateKeyWriter.write(privatePem);
        privateKeyWriter.close();
        System.out.println("");
        System.out.println("Generated private key (PEM format using the PKCS#8 standard):");
        System.out.println(privatePem);
    }

    // generates rsa keypair
    public static KeyPair generateKeypair(int keySize) throws NoSuchAlgorithmException {
        KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
        generator.initialize(keySize);
        return generator.generateKeyPair();
    }

    // key to pem format
    // https://stackoverflow.com/questions/20598126/how-to-generate-public-and-private-key-in-pem-format
    public static String keyToPem(byte[] key, KeyType type) {
        String text = Base64.getEncoder().encodeToString(key);
        List<String> strings = new ArrayList<String>();
        int index = 0;
        while (index < text.length()) {
            strings.add(text.substring(index, Math.min(index + 64, text.length())));
            index += 64;
        }
        String pem = "-----BEGIN " + type.name() + " KEY-----";
        for (int i = 0; i < strings.size(); i++) {
            pem += "\n" + strings.get(i);
        }
        pem += "\n-----END " + type.name() + " KEY-----";
        return pem;
    }

    // encrypt
    public static void encryptExample() throws IOException, NoSuchAlgorithmException, InvalidKeySpecException,
            NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException {
        // input
        System.out.println("Input:");
        String clearText = System.console().readLine();
        // import public key
        System.out.println();
        System.out.println("Public key PEM file path (PKCS#8 standard):");
        String keyPath = System.console().readLine();
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        EncodedKeySpec publicKeySpec = new X509EncodedKeySpec(readPem(keyPath, KeyType.PUBLIC));
        PublicKey publicKey = keyFactory.generatePublic(publicKeySpec);
        // encrypt
        Cipher encryptCipher = Cipher.getInstance("RSA");
        encryptCipher.init(Cipher.ENCRYPT_MODE, publicKey);
        byte[] encrypted = encryptCipher.doFinal(clearText.getBytes(StandardCharsets.UTF_8));
        System.out.println();
        System.out.println("Encrypted output (base64 bytes):");
        System.out.println(Base64.getEncoder().encodeToString(encrypted));
    }

    // dencrypt using custom private key
    public static void decryptExample() throws InvalidKeySpecException, InvalidKeyException, NoSuchAlgorithmException,
            NoSuchPaddingException, IOException, IllegalBlockSizeException, BadPaddingException {
        // input
        System.out.println("Encrypted input (base64 bytes):");
        String cipherText = System.console().readLine();
        // import private key
        System.out.println();
        System.out.println("Private key PEM file path (PKCS#8 standard):");
        String keyPath = System.console().readLine();
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PKCS8EncodedKeySpec privateKeySpec = new PKCS8EncodedKeySpec(readPem(keyPath, KeyType.PRIVATE));
        PrivateKey privateKey = keyFactory.generatePrivate(privateKeySpec);
        // decrypt
        Cipher decryptCipher = Cipher.getInstance("RSA");
        decryptCipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] decrypted = decryptCipher.doFinal(Base64.getDecoder().decode(cipherText));
        System.out.println();
        System.out.println("Decrypted output:");
        System.out.println(new String(decrypted, StandardCharsets.UTF_8));
    }

    // pem to bytes
    public static byte[] readPem(String path, KeyType type) throws IOException {
        String pem = Files.readString(Path.of(path));
        pem = pem.replace("-----BEGIN " + type.name() + " KEY-----", "");
        pem = pem.replace("\n-----END " + type.name() + " KEY-----", "");
        pem = pem.replace("\n", "");
        return Base64.getDecoder().decode(pem);
    }
}