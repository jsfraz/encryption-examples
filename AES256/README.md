# [AES256](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
- CBC mode, PKCS7 padding
- generate random 256 bit key
- encrypt
- decrypt
## Example output
### Generate random 256 bit key
```
Random 256 bit key (base64 bytes):
P1lj1K4TtVEf9hFEPF+ZTM0Lr4Xmcl/bxcQcRLPZtC0=
```
### Encrypt
```
Input:
Hello, World!

256 bit key (base64 bytes):
P1lj1K4TtVEf9hFEPF+ZTM0Lr4Xmcl/bxcQcRLPZtC0=

Encrypted output (base64 bytes):
uvwQskXwWucinzyeNQZclA==
```
### Decrypt
```
Encrypted input (base64 bytes):
uvwQskXwWucinzyeNQZclA==

256 bit key (base64 bytes):
P1lj1K4TtVEf9hFEPF+ZTM0Lr4Xmcl/bxcQcRLPZtC0=

Decrypted output:
Hello, World!
```