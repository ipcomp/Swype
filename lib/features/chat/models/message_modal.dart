class MessageModel {
  final String text;
  final String senderId;
  final DateTime timestamp;

  MessageModel({
    required this.text,
    required this.senderId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      text: map['text'],
      senderId: map['senderId'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
