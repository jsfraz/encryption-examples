# [RSA](https://en.wikipedia.org/wiki/RSA_(cryptosystem))
- generate 512, 1024, 2048, 4096 bit key and save it with PEM format using the PKCS#8 padding
- encrypt using RSA public key
- decrypt using RSA private key
## Example output
### Generate and save keys
```
Choose key size:
1. 512 bit
2. 1024 bit
3. 2048 bit
4. 4096 bit
2

Where would you like to save generated keys?
/home/user

Generated public key (PEM format using the PKCS#8 standard):
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCP6RC9hL6XZJToQB9nx1xV7IMY
SSF4G7mHTKwPvvrrxVE5L+CgRKq/HhkmlIla3AjJwlACTLJqfXs/fcN9b6N8s7RQ
PQ0aRYNbvhdSWLAt85SVmFYDyVtI61FebDHypkK11sm74X/fdCOAlmEyBLTQhPT0
VwZB7ck5XSPT3uK/HQIDAQAB
-----END PUBLIC KEY-----

Generated private key (PEM format using the PKCS#8 standard):
-----BEGIN PRIVATE KEY-----
MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAI/pEL2EvpdklOhA
H2fHXFXsgxhJIXgbuYdMrA+++uvFUTkv4KBEqr8eGSaUiVrcCMnCUAJMsmp9ez99
w31vo3yztFA9DRpFg1u+F1JYsC3zlJWYVgPJW0jrUV5sMfKmQrXWybvhf990I4CW
YTIEtNCE9PRXBkHtyTldI9Pe4r8dAgMBAAECgYAhnUL3waXzHt9ZUIEFcJ+0wkXs
ykgzEebIH7ShCO77W1+ZiAFj7iYj9hfR1yguPO8gkW622sth7GV5cxrSld0Ny1Ox
jGEWQzpr/hOtSdJy6HTLjsl5HI4G05N9/ZI18GYJTFpgDHUyIQeFXQ7mse9CdAbZ
DjrRAxgtAySF+NPj0QJBAPWdpH5yAvEPjjhK51a99YcVxONm6mGbugy/6R0szKmz
5lw360muq76QrUoRTxDjed61YyojhMiy8tK9Sa+hAX8CQQCV/qRAVZykgxFG7KvN
TkDNw1BHaaYub24y4bQroVoem1ullltZUXWyEUe/1QILMpg3c5eDHPLT/iAWplZR
4FVjAkEAgle9QqkIbJr/s1n0uLCoSp6/1Jn6CgCVVEzHzgbHOcvRlODMCVcbp06p
16Ol3OWK+Cg0Ttl4jvWALVvsbbq4ywJAXPqBdMPdGvmITy/Me7LDZwlojSwHcIdw
hyf0GIunootpbybaL27Yh25AzMBMyQYu50jHJeZe/FxuJbwsjAqEwwJAXwbbvqhg
hYmVPASEKmbo8uzs3oty+lNnQqyFpWspiYRKLaapYW8di3z9Vry8Ib4wGW4WDPvW
FUGZx+ZwrcQ4bg==
-----END PRIVATE KEY-----
```
### Encrypt
```
Input:
Hello, World!

Public key PEM file path (PKCS#8 standard):
/home/user/publicKey.pem

Encrypted output (base64 bytes):
e2fSnxzQWLgN8aIS+RW48EHxUioPxYj5exL7cBhlGCreez7wk821kUkwDuZ0fXLBfhgf3QWQhpz6lhz892iHgAcgVA1lJ+3YSRrNBghseAj9H2KzsHFXAcvco7Vpz63rh6v9l7efR12T4iej4UiLenvEkXuBAj7lgkggovJXqgY=
```
### Decrypt
```
Encrypted input (base64 bytes):
e2fSnxzQWLgN8aIS+RW48EHxUioPxYj5exL7cBhlGCreez7wk821kUkwDuZ0fXLBfhgf3QWQhpz6lhz892iHgAcgVA1lJ+3YSRrNBghseAj9H2KzsHFXAcvco7Vpz63rh6v9l7efR12T4iej4UiLenvEkXuBAj7lgkggovJXqgY=

Private key PEM file path (PKCS#8 standard):
/home/user/privateKey.pem

Decrypted output:
Hello, World!
```