import 'package:swype/features/chat/models/message_modal.dart';

class MessagesData {
  List<MessageModel> msgDummyData = [
    MessageModel(
        text:
            'Hi Jake, how are you? I saw on the app that we’ve crossed paths several times this week 😄',
        senderId: '3',
        timestamp: DateTime.now()),
    MessageModel(
        text: 'Haha truly! Nice to meet you Grace! ☕️ ',
        senderId: '0',
        timestamp: DateTime.now()),
    MessageModel(
        text: 'Sure, let’s do it! 😊',
        senderId: '3',
        timestamp: DateTime.now()),
    MessageModel(
        text: 'See you soon!', senderId: '0', timestamp: DateTime.now()),
    MessageModel(
        text: 'Bye Take Care!', senderId: '3', timestamp: DateTime.now()),
  ];
}
