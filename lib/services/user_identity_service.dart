import 'package:shared_preferences/shared_preferences.dart';

class UserIdentityService {
  static const String _senderKey = 'current_user';
  static const String _receiverKey = 'receiver_chat_id';

  Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_senderKey);
  }

  Future<String?> getReceiverId() async {
    final prefs = await SharedPreferences.getInstance();

    final receiver = prefs.getString(_receiverKey);
    if (receiver != null) return receiver;

    final oldReceiver = prefs.getInt(_receiverKey);
    if (oldReceiver != null) {
      final value = oldReceiver.toString();
      await prefs.setString(_receiverKey, value);
      return value;
    }

    return null;
  }

  Future<void> setIdentity(String user) async {
    final prefs = await SharedPreferences.getInstance();

    if (user == 'me') {
      await prefs.setString(_senderKey, 'me');
      await prefs.setString(_receiverKey, '8110267464');
    } else if (user == 'girlfriend') {
      await prefs.setString(_senderKey, 'girlfriend');
      await prefs.setString(_receiverKey, '1840449883');
    } else {
      throw ArgumentError('Invalid user');
    }
  }

  Future<void> clearIdentity() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_senderKey);
    await prefs.remove(_receiverKey);
  }
}
