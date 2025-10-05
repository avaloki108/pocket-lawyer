import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/stream/ctr.dart';
import 'package:pointycastle/digests/sha256.dart';

/// Encryption helper using AES-256
class EncryptionHelper {
  // static const String _algorithm = 'AES/CTR/NoPadding';

  /// Encrypts a plain text using AES-256
  static String encrypt(String plainText, String key) {
    final keyBytes = _deriveKey(key);
    final iv = _generateIV();

    final cipher = _createCipher(true, keyBytes, iv);
    final inputBytes = Uint8List.fromList(utf8.encode(plainText));
    final encrypted = cipher.process(inputBytes);

    // Combine IV + encrypted data
    final combined = Uint8List(iv.length + encrypted.length);
    combined.setRange(0, iv.length, iv);
    combined.setRange(iv.length, combined.length, encrypted);

    return base64Encode(combined);
  }

  /// Decrypts an encrypted text using AES-256
  static String decrypt(String encryptedText, String key) {
    final combined = base64Decode(encryptedText);
    final iv = combined.sublist(0, 16);
    final encrypted = combined.sublist(16);

    final keyBytes = _deriveKey(key);
    final cipher = _createCipher(false, keyBytes, iv);

    final decrypted = cipher.process(encrypted);
    return utf8.decode(decrypted);
  }

  static Uint8List _deriveKey(String password) {
    // Simple key derivation - in production, use PBKDF2
    final bytes = utf8.encode(password);
    final digest = SHA256Digest();
    final hash = digest.process(Uint8List.fromList(bytes));
    return hash;
  }

  static Uint8List _generateIV() {
    final random = Random.secure();
    return Uint8List.fromList(List.generate(16, (_) => random.nextInt(256)));
  }

  static CTRStreamCipher _createCipher(
    bool forEncryption,
    Uint8List key,
    Uint8List iv,
  ) {
    final cipher = CTRStreamCipher(AESEngine());
    cipher.init(forEncryption, ParametersWithIV(KeyParameter(key), iv));
    return cipher;
  }
}
