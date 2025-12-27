import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../models/chat_session_model.dart';
import '../models/message_model.dart';


class HomeController extends GetxController {

  final RxList<User> users = <User>[].obs;
  final RxList<ChatSession> chatSessions = <ChatSession>[].obs;
  final _uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();
  }

  /// Adds a new user with the given name to the Users list.
  /// The avatar is randomly assigned or just an initial.
  void addUser(String name) {
    if (name.trim().isEmpty) return;

    final newUser = User(
      id: _uuid.v4(),
      name: name.trim(),
      avatarUrl: '',
    );

    users.add(newUser);
    Get.snackbar(
      'User Added',
      '$name has been added to the list',
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: const Duration(milliseconds: 500),
      duration: const Duration(seconds: 2),
    );
  }

  /// Updates or creates a chat session when a message is sent/received.
  void updateChatSession(User user, Message lastMessage) {
    final index = chatSessions.indexWhere((session) => session.user.id == user.id);
    
    final newSession = ChatSession(
      user: user, 
      lastMessage: lastMessage, 
      lastUpdated: DateTime.now()
    );

    if (index != -1) {
      chatSessions.removeAt(index);
      chatSessions.insert(0, newSession);
    } else {
      chatSessions.insert(0, newSession);
    }
  }
}
