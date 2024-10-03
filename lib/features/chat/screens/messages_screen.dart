import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/chat/models/message_modal.dart';
import 'package:swype/features/chat/models/messages_data.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  final String userId;

  const MessagesScreen({super.key, required this.userId});

  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends ConsumerState<MessagesScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<MessageModel> _messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // _fetchChatMessages();
    initial();
  }

  initial() {
    _messages = MessagesData().msgDummyData;
    isLoading = false;
    setState(() {});
  }

  // Fetch chat messages from the API
/*  Future<void> _fetchChatMessages() async {
    try {
      final response =
          await ChatApi.getChatMessages(widget.userId); // Call to your API
      if (response.statusCode == 200) {
        setState(() {
          _messages = response.data;
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching chat: $error');
    }
  }
*/
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    // Send message to the API
    setState(() {
      _messages.add(MessageModel(
        text: _messageController.text.trim(),
        senderId: 'currentUserId', // Replace with your current user ID logic
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
    });
    // ChatApi.sendMessage(widget.userId, _messageController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                  'assets/images/dummy_profile_pic.png'), // Replace with dynamic image
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('גרייס',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text('Online',
                    style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (String value) {
              if (value == 'Block') {
                // Handle block
              } else if (value == 'DND') {
                // Handle Do Not Disturb
              } else if (value == 'Report') {
                // Handle report
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(value: 'Block', child: Text('Block')),
                const PopupMenuItem(
                    value: 'DND', child: Text('Do Not Disturb')),
                const PopupMenuItem(value: 'Report', child: Text('Report')),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isCurrentUser =
                            message.senderId == '0'; // Adjust this logic

                        return Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? Colors.redAccent
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              message.text,
                              style: TextStyle(
                                color:
                                    isCurrentUser ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // Message Input Box
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo),
                    onPressed: () {
                      // Handle photo upload
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.red),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
