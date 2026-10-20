import 'package:http/http.dart' as http;
import 'package:bcall/services/user_identity_service.dart';

class TelegramService {
  static const String _botToken =
      '8927165458:AAHoubAvZsnauf6RsCVMkl75wYi7IFN_Mr4';

  static final UserIdentityService _identityService = UserIdentityService();

  static Future<void> sendMessage(String message) async {
    final receiverId = await _identityService.getReceiverId();

    if (receiverId == null) {
      throw Exception('Receiver ID မရှိပါ။ Identity ကို အရင်ရွေးပါ။');
    }

    final url = Uri.parse('https://api.telegram.org/bot$_botToken/sendMessage');

    final response = await http.post(
      url,
      body: {'chat_id': receiverId.toString(), 'text': message},
    );

    if (response.statusCode == 200) {
      print('Telegram သို့ စာပို့ပြီးပါပြီ ❤️');
    } else {
      throw Exception('စာပို့မအောင်မြင်ပါ: ${response.body}');
    }
  }
}
