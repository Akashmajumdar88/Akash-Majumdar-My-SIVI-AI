import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import 'home_controller.dart';

class ChatController extends GetxController {
  final RxList<Message> messages = <Message>[].obs;
  final RxBool isLoading = false.obs;
  
  late User currentUser;
  final _uuid = const Uuid();
  final HomeController _homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is User) {
      currentUser = Get.arguments as User;
    }
  }

  void sendMessage(String content) {
    if (content.trim().isEmpty) return;

    final message = Message(
      id: _uuid.v4(),
      content: content.trim(),
      type: MessageType.sender,
      timestamp: DateTime.now(),
    );

    messages.insert(0, message);
    _homeController.updateChatSession(currentUser, message);
    fetchReply();
  }

  Future<void> fetchReply() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));
      final response = await http.get(Uri.parse('https://api.quotable.io/random'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['content'] ?? 'Hello!';
        
        final reply = Message(
          id: _uuid.v4(),
          content: content,
          type: MessageType.receiver,
          timestamp: DateTime.now(),
        );

        messages.insert(0, reply);
        _homeController.updateChatSession(currentUser, reply);
      } else {
        _addFallbackReply();
      }
    } catch (e) {
      _addFallbackReply();
    } finally {
      isLoading.value = false;
    }
  }
  
  void _addFallbackReply() {
    final reply = Message(
      id: _uuid.v4(),
      content: "I'm having trouble connecting right now, but I received your message!",
      type: MessageType.receiver,
      timestamp: DateTime.now(),
    );
    messages.insert(0, reply);
    _homeController.updateChatSession(currentUser, reply);
  }
}
