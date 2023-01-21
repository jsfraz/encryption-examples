# [AES256](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
- CBC mode, PKCS7 padding
- user specifies input for encrypting
- random 256 bit key is generated and shown as [Base64](https://en.wikipedia.org/wiki/Base64) encoded bytes
- input is encrypted and shown as Base64 encoded bytes (128 bit [MD5 hash](https://en.wikipedia.org/wiki/MD5) of key is used as [IV](https://en.wikipedia.org/wiki/Initialization_vector))
- encrypted result is decrypted back and shown
## Example output
```
Input:
Hello, World!
Random 256 bit key (base64 bytes): pJMqT1hxJH9gX91uS5CX6dCA6vORN6klSnscc4A/KPs=
Encrypted input (base64 bytes): 6muFS6BKwNR2Cg1U20gyiQ==
Decrypted input: Hello, World!
```