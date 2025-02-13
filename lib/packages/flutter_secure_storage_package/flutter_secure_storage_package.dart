import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStoragePackage {
  FlutterSecureStoragePackage._();

  static Future<bool> storeToSecureStorage(String key, String valueInput) async {
    try {
      const secureStorage = FlutterSecureStorage();
      await secureStorage.write(key: key, value: valueInput);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<String?> fetchFromSecureStorage(String key) async {
    try {
      const secureStorage = FlutterSecureStorage();
      return await secureStorage.read(key: key);
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearSecureStorage(String key) async {
    try {
      const secureStorage = FlutterSecureStorage();
      await secureStorage.delete(key: key);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
