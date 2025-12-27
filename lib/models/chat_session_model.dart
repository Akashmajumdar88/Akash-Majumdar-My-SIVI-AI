import 'message_model.dart';
import 'user_model.dart';

class ChatSession {
  final User user;
  final Message lastMessage;
  final DateTime lastUpdated;

  ChatSession({
    required this.user,
    required this.lastMessage,
    required this.lastUpdated,
  });
}
