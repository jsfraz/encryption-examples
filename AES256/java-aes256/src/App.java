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
        // your text
        System.out.println("Input:");
        String clearText = System.console().readLine();
        // random 32 byte (256 bits) key (you can use your own)
        byte[] key = new byte[32];
        Random random = new Random();
        random.nextBytes(key);
        System.out.println("Random 256 bit key (base64 bytes): " + Base64.getEncoder()
                .encodeToString(key));
        // encrypt
        byte[] encrypted = encrypt(clearText, key);
        System.out.println("Encrypted input (base64 bytes): " + Base64.getEncoder()
                .encodeToString(encrypted));
        // decrypt
        String decrypted = decrypt(encrypted, key);
        System.out.println("Decrypted input: " + decrypted);
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
