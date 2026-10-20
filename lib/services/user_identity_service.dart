import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserIdentityService {
  static const String _senderKey = 'current_user';
  static const String _receiverKey = 'receiver_chat_id';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> getCurrentUser() async {
    return await _storage.read(key: _senderKey);
  }

  Future<String?> getReceiverId() async {
    final receiver = await _storage.read(key: _receiverKey);
    if (receiver != null) return receiver;

    return null;
  }

  Future<void> setIdentity(String user) async {
    if (user == 'me') {
      await _storage.write(key: _senderKey, value: 'me');
      await _storage.write(key: _receiverKey, value: '8110267464');
    } else if (user == 'girlfriend') {
      await _storage.write(key: _senderKey, value: 'girlfriend');
      await _storage.write(key: _receiverKey, value: '1840449883');
    } else {
      throw ArgumentError('Invalid user');
    }
  }

  Future<void> clearIdentity() async {
    await _storage.delete(key: _senderKey);
    await _storage.delete(key: _receiverKey);
  }
}
