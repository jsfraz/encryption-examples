import java.util.Base64;
import java.util.Random;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import java.security.MessageDigest;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.spec.IvParameterSpec;
import java.nio.charset.StandardCharsets;
import java.security.NoSuchAlgorithmException;

public class App {
    // stolen from
    // https://howtodoinjava.com/java/java-security/aes-256-encryption-decryption/
    public static void main(String[] args) throws Exception {
        System.out.println("1. Generate random 256 bit key");
        System.out.println("2. Encrypt");
        System.out.println("3. Decrypt");
        String option = System.console().readLine();
        switch (option) {
            case "1":
                generateKeyExample();
                break;
            case "2":
                encryptExample();
                break;
            case "3":
                decryptExample();
                break;
        }
    }

    // create key
    public static void generateKeyExample() {
        byte[] key = generateRandomKey();
        System.out.println();
        System.out.println("Random 256 bit key (base64 bytes):");
        System.out.println(Base64.getEncoder().encodeToString(key));
    }

    // encrypt
    public static void encryptExample() {
        // your text
        System.out.println();
        System.out.println("Input:");
        String clearText = System.console().readLine();
        // key
        System.out.println();
        System.out.println("256 bit key (base64 bytes):");
        String base64Key = System.console().readLine();
        byte[] key = Base64.getDecoder().decode(base64Key);
        // encrypt
        byte[] encrypted = encrypt(clearText, key);
        System.out.println();
        System.out.println("Encrypted input (base64 bytes):");
        System.out.println(Base64.getEncoder().encodeToString(encrypted));
    }

    // decrypt
    public static void decryptExample() {
        // encrypted input
        System.out.println();
        System.out.println("Encrypted input (base64 bytes):");
        String input = System.console().readLine();
        // key
        System.out.println();
        System.out.println("256 bit key (base64 bytes):");
        String base64Key = System.console().readLine();
        byte[] key = Base64.getDecoder().decode(base64Key);
        // decrypt
        String decrypted = decrypt(Base64.getDecoder().decode(input), key);
        System.out.println();
        System.out.println("Decrypted input:");
        System.out.println(decrypted);
    }

    // random 256 bit key
    public static byte[] generateRandomKey() {
        byte[] key = new byte[32];
        Random random = new Random();
        random.nextBytes(key);
        return key;
    }

    // encrypt (md5 hash of key as IV)
    public static byte[] encrypt(String plainText, byte[] key) {
        try {
            byte[] iv = createMD5(key);
            IvParameterSpec ivspec = new IvParameterSpec(iv);
            SecretKey tmp = new SecretKeySpec(key, "AES");
            SecretKeySpec secretKey = new SecretKeySpec(tmp.getEncoded(), "AES");
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, secretKey, ivspec);
            return cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));
        } catch (Exception e) {
            System.out.println("Error while encrypting: " + e.toString());
        }
        return null;
    }

    // encrypt (md5 hash of key as IV)
    public static String decrypt(byte[] encrypted, byte[] key) {
        try {
            byte[] iv = createMD5(key);
            IvParameterSpec ivspec = new IvParameterSpec(iv);
            SecretKey tmp = new SecretKeySpec(key, "AES");
            SecretKeySpec secretKey = new SecretKeySpec(tmp.getEncoded(), "AES");
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
            cipher.init(Cipher.DECRYPT_MODE, secretKey, ivspec);
            return new String(cipher.doFinal(encrypted));
        } catch (Exception e) {
            System.out.println("Error while decrypting: " + e.toString());
        }
        return null;
    }

    // md5 hash from input
    public static byte[] createMD5(byte[] input) {
        MessageDigest md;
        try {
            md = MessageDigest.getInstance("MD5");
            md.update(input);
            return md.digest();
        } catch (NoSuchAlgorithmException e) {
            System.out.println(e.toString());
            return null;
        }
    }
}
