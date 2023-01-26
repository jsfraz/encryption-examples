using System.Security.Cryptography;

internal class Program
{
    private static void Main(string[] args)
    {
        Console.WriteLine("1. Generate random 256 bit key");
        Console.WriteLine("2. Encrypt");
        Console.WriteLine("3. Decrypt");
        string? option = Console.ReadLine();
        switch (option)
        {
            case "1":
                GenerateKeyExample();
                break;
            case "2":
                EncryptExample();
                break;
            case "3":
                DecryptExample();
                break;
        }
    }

    //create key
    public static void GenerateKeyExample()
    {
        byte[] key = GenerateRandomKey();
        Console.WriteLine();
        Console.WriteLine("Random 256 bit key (base64 bytes):");
        Console.WriteLine(Convert.ToBase64String(key));
    }

    //encrypt
    public static void EncryptExample()
    {
        //your text
        Console.WriteLine();
        Console.WriteLine("Input:");
        string? clearText = Console.ReadLine();
        //key
        Console.WriteLine();
        Console.WriteLine("256 bit key (base64 bytes):");
        String? base64Key = Console.ReadLine();
        byte[] key = Convert.FromBase64String(base64Key!);
        //encrypt
        byte[] encrypted = Encrypt(clearText!, key);
        Console.WriteLine();
        Console.WriteLine("Encrypted input (base64 bytes):");
        Console.WriteLine(Convert.ToBase64String(encrypted));
    }

    //decrypt
    public static void DecryptExample()
    {
        //encrypted input
        Console.WriteLine();
        Console.WriteLine("Encrypted input (base64 bytes):");
        string? input = Console.ReadLine();
        //key
        Console.WriteLine();
        Console.WriteLine("256 bit key (base64 bytes):");
        string? base64Key = Console.ReadLine();
        byte[] key = Convert.FromBase64String(base64Key!);
        //decrypt
        string decrypted = Decrypt(Convert.FromBase64String(input!), key);
        Console.WriteLine();
        Console.WriteLine("Decrypted input:");
        Console.WriteLine(decrypted);
    }

    //random 256 bits key
    public static byte[] GenerateRandomKey()
    {
        Random rnd = new Random();
        byte[] key = new byte[32];
        rnd.NextBytes(key);
        return key;
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

    //encrypt (md5 hash of key as IV)
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