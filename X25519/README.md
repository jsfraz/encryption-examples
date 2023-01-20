# [X25519](https://en.wikipedia.org/wiki/Curve25519)
- user executes two example programs (for example [.NET Core](dotnet-x25519) and [Dart](dart_x25519))
- each program generates 256 bit public key and outputs it as [Base64](https://en.wikipedia.org/wiki/Base64) encoded bytes
- user copies each public key to other program's input
- each program generates shared 256 bit secret key and outputs it as Base64 encoded bytes
- both shared secrets **MUST** match
## Example output
### .NET Core
```
256 bit public key (base64 bytes): hDFBjnUeOEE5tbXo0yPdyzdr+Bi+rGWGpjybjBJ7+B0=
Input remote public key (base64 bytes):
LhYwi1PlqFd+RfaDgypEgOCjh1U1fNpixfq79sEnqTc=
256 bit shared secret (base64 bytes): TdI29RCyJ0O2qOulwRY2h//5Ib9FrpfiGkdWXCU27A8=
```
### Dart
```
256 bit public key (base64 bytes): LhYwi1PlqFd+RfaDgypEgOCjh1U1fNpixfq79sEnqTc=
Input remote public key (base64 bytes):
hDFBjnUeOEE5tbXo0yPdyzdr+Bi+rGWGpjybjBJ7+B0=
256 bit shared secret (base64 bytes): TdI29RCyJ0O2qOulwRY2h//5Ib9FrpfiGkdWXCU27A8=
```