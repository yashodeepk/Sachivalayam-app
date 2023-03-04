// import 'package:encrypt/encrypt.dart';

// import '../env/env.dart';

// class SecureData {
//   static SecureData? _instance;

//   static SecureData get instance => _instance == null ? _instance = SecureData._() : _instance!;

//   SecureData._();

//   String decryptAES({data}) {
//     final key = Key.fromUtf8(Env.secure);
//     final iv = IV.fromLength(16);
//     final encryptor = Encrypter(AES(key));
//     final first = encryptor.decrypt(Encrypted.fromBase64(data), iv: iv);
//     return encryptor.decrypt(Encrypted.fromBase64(first), iv: iv);
//   }

//   String encryptAES({data}) {
//     String message = '';
//     if (data.toString().isNotEmpty) {
//       Encrypted encrypted;
//       final key = Key.fromUtf8(Env.secure);
//       final iv = IV.fromLength(16);
//       final encryptor = Encrypter(AES(key));
//       final first = encryptor.encrypt(data, iv: iv);
//       encrypted = encryptor.encrypt(first.base64, iv: iv);
//       message = encrypted.base64;
//     }

//     return message;
//   }
// }
