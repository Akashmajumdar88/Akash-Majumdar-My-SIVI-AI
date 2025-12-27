import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/chat_controller.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _textController = TextEditingController();
  late ChatController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ChatController>()) {
      Get.delete<ChatController>();
    }
    controller = Get.put(ChatController());
  }

  @override
  Widget build(BuildContext context) {
    final User currentUser = Get.arguments as User;
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue,
                      Colors.purple,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                    child: Text(currentUser.name.isNotEmpty ? currentUser.name[0].toUpperCase() : "?", style: const TextStyle(fontSize: 12, color: Colors.white)))),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentUser.name,style: GoogleFonts.montserrat(fontSize: 16,fontWeight: FontWeight.bold)),
                Text("Online",style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w400)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isSender = message.type == MessageType.sender;
                  return _buildMessageBubble(message, isSender, currentUser);
                },
              );
            }),
          ),
          if (controller.isLoading.value) 
            const Padding(padding: EdgeInsets.all(8.0), child: LinearProgressIndicator(minHeight: 2)),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isSender, User currentUser) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSender) ...[
             Container(
                 width: 40,
                 height: 40,
                 decoration: const BoxDecoration(
                   shape: BoxShape.circle,
                   gradient: LinearGradient(
                     colors: [
                       Colors.blue,
                       Colors.purple,
                     ],
                     begin: Alignment.topLeft,
                     end: Alignment.bottomRight,
                   ),
                 ),
                 child: Center(
                 child: Text(currentUser.name.isNotEmpty ? currentUser.name[0].toUpperCase() : "?",
                     style:  GoogleFonts.montserrat(fontSize: 14, color: Colors.white,fontWeight: FontWeight.w500)))),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSender ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: isSender ? const Radius.circular(16) : const Radius.circular(0),
                  topRight: isSender ? const Radius.circular(0) : const Radius.circular(16),
                  bottomLeft: const Radius.circular(16),
                  bottomRight: const Radius.circular(16),
                ),
              ),
              child: Text(
                message.content,
                style: TextStyle(fontSize: 16,color: isSender ? Colors.white : Colors.black),
              ),
            ),
          ),
          if (isSender) ...[
             const SizedBox(width: 8),
             Container(
                 width: 40,
                 height: 40,
                 decoration: const BoxDecoration(
                   shape: BoxShape.circle,
                   gradient: LinearGradient(
                     colors: [
                       Colors.purple,
                       Colors.pink,
                     ],
                     begin: Alignment.topLeft,
                     end: Alignment.bottomRight,
                   ),
                 ),
                 child: Center(child: Text("U",style:  GoogleFonts.montserrat(fontSize: 14, color: Colors.white,fontWeight: FontWeight.w500)))),
          ],
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (value) => _handleSend(),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              mini: true,
              onPressed: _handleSend,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.send, size: 20,color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSend() {
    if (_textController.text.trim().isNotEmpty) {
      controller.sendMessage(_textController.text);
      _textController.clear();
    }
  }
}
