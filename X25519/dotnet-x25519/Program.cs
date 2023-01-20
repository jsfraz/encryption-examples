using X25519;

internal class Program
{
    private static void Main(string[] args)
    {
        //package used: https://github.com/HirbodBehnam/X25519-CSharp

        //new keypair
        X25519KeyPair keyPair = X25519KeyAgreement.GenerateKeyPair();
        //32 byte (256 bits) public key
        Console.WriteLine("256 bit public key (base64 bytes): " + Convert.ToBase64String(keyPair.PublicKey));
        //input 32 byte (256 bits) remote public key
        Console.WriteLine("Input remote public key (base64 bytes):");
        string? remoteKey = Console.ReadLine();
        //32 byte (256 bits) shared secret
        byte[] sharedKeyBytes = X25519KeyAgreement.Agreement(keyPair.PrivateKey, Convert.FromBase64String(remoteKey!));
        Console.WriteLine("256 bit shared secret (base64 bytes): " + Convert.ToBase64String(sharedKeyBytes));
    }
}