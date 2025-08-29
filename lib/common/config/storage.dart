import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final storage = FlutterSecureStorage();

// Menyimpan userId
  Future<void> saveUserId(String userId) async {
    await storage.write(key: 'userId', value: userId);
  }

// Mengambil userId
  Future<String?> getUserId() async {
    return await storage.read(key: 'userId');
  }

// Menghapus userId (misalnya saat logout)
  Future<void> deleteUserId() async {
    await storage.delete(key: 'userId');
  }
}
