enum MessageType { sender, receiver }

class Message {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
  });
}
