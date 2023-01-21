using System.Security.Cryptography;

internal class Program
{
    private static void Main(string[] args)
    {
        //your text
        Console.WriteLine("Input:");
        string? clearText = Console.ReadLine();
        //random 32 byte (256 bits) key (you can use your own)
        Random rnd = new Random();
        byte[] key = new byte[32];
        rnd.NextBytes(key);
        Console.WriteLine("Random 256 bit key (base64 bytes): " + Convert.ToBase64String(key));
        //encrypt
        byte[] encrypted = Encrypt(clearText!, key);
        Console.WriteLine("Encrypted input (base64 bytes): " + Convert.ToBase64String(encrypted));
        //decrypt
        string decrypted = Decrypt(encrypted, key);
        Console.WriteLine("Decrypted input: " + decrypted);
    }

    //encrypt (md5 hash of key as IV)
    public static byte[] Encrypt(string plainText, byte[] key)
    {
        using (Aes aesAlgorithm = Aes.Create())
        {
            /*
            Console.WriteLine($"Aes Cipher Mode : {aesAlgorithm.Mode}");
            Console.WriteLine($"Aes Padding Mode: {aesAlgorithm.Padding}");
            Console.WriteLine($"Aes Key Size : {aesAlgorithm.KeySize}");
            Console.WriteLine($"Aes Block Size : {aesAlgorithm.BlockSize}");
            */

            //set the parameters with out keyword
            aesAlgorithm.Key = key;
            aesAlgorithm.IV = CreateMD5(key);

            //create encryptor object
            ICryptoTransform encryptor = aesAlgorithm.CreateEncryptor();

            byte[] encryptedData;

            //encryption will be done in a memory stream through a CryptoStream object
            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor, CryptoStreamMode.Write))
                {
                    using (StreamWriter sw = new StreamWriter(cs))
                    {
                        sw.Write(plainText);
                    }
                    encryptedData = ms.ToArray();
                }
            }

            return encryptedData;
        }
    }

    //dencrypt (md5 hash of key as IV)
    public static string Decrypt(byte[] encrypted, byte[] key)
    {
        using (Aes aesAlgorithm = Aes.Create())
        {
            aesAlgorithm.Key = key;
            aesAlgorithm.IV = CreateMD5(key);

            /*
            Console.WriteLine($"Aes Cipher Mode : {aesAlgorithm.Mode}");
            Console.WriteLine($"Aes Padding Mode: {aesAlgorithm.Padding}");
            Console.WriteLine($"Aes Key Size : {aesAlgorithm.KeySize}");
            Console.WriteLine($"Aes Block Size : {aesAlgorithm.BlockSize}");
            */

            //create decryptor object
            ICryptoTransform decryptor = aesAlgorithm.CreateDecryptor();

            //decryption will be done in a memory stream through a CryptoStream object
            using (MemoryStream ms = new MemoryStream(encrypted))
            {
                using (CryptoStream cs = new CryptoStream(ms, decryptor, CryptoStreamMode.Read))
                {
                    using (StreamReader sr = new StreamReader(cs))
                    {
                        return sr.ReadToEnd();
                    }
                }
            }
        }
    }

    //md5 hash from input
    public static byte[] CreateMD5(byte[] input)
    {
        //https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.md5.hashdata?view=net-6.0
        return MD5.HashData(input);
    }
}