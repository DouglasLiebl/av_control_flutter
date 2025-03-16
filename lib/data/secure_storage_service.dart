import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage storage;

  SecureStorageService({required this.storage});

  Future<void> setItem(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> getItem(String key) async {
    return await storage.read(key: key);
  }

  Future<void> deleteItem(String key) async {
    await storage.delete(key: key);
  }
}