import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swype/commons/widgets/match_avatar_widget.dart';
import 'package:swype/features/chat/models/message_modal.dart';
import 'package:swype/features/chat/models/messages_data.dart';
import 'package:swype/utils/constants/colors.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  final String userId;

  const MessagesScreen({super.key, required this.userId});

  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends ConsumerState<MessagesScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<MessageModel> messages = [];
  bool isLoading = true;
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    // _fetchChatMessages();
    initial();
  }

  initial() {
    messages = MessagesData().msgDummyData;
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
  void sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    // Send message to the API
    setState(() {
      messages.add(MessageModel(
        text: _messageController.text.trim(),
        senderId: '0', // Replace with your current user ID logic
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
    });
    // ChatApi.sendMessage(widget.userId, _messageController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    // TextDirection textDirection = Directionality.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(isOnline),
      body: SafeArea(
        child: Column(
          children: [
            // Messages List
            messagesList(isLoading, messages),
            // Message Input Box
            messageInputBox(_messageController, sendMessage),
          ],
        ),
      ),
    );
  }
}

appBar(bool isOnline) {
  return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(children: [
        matchAvatar('', true, true, 56, 56,
            onlineDotTop: 0,
            onlineDotRight: 0,
            onlineDotHeight: 0,
            onlineDotWidth: 0),
        const SizedBox(width: 8),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [appBarLeft(), appBarRight(isOnline)])
      ]),
      actions: [CustomMenuWidget()]);
}

appBarLeft() {
  return Text('Grace',
      style: TextStyle(
          color: CColors.secondary,
          fontSize: 24,
          height: 1.5,
          fontWeight: FontWeight.w700));
}

appBarRight(bool isOnline) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        width: 6,
        height: 6,
        child: CircleAvatar(
          radius: 4.5,
          backgroundColor: isOnline
              ? const Color.fromRGBO(19, 220, 26, 1)
              : const Color.fromRGBO(225, 225, 225, 1),
        ),
      ),
      const SizedBox(width: 2),
      const Text('Online',
          style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 0.4),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.5)),
    ],
  );
}

Widget messagesList(bool isLoading, messages) {
  return Expanded(
    child: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isCurrentUser =
                    message.senderId == '0'; // Adjust this logic

                return messageWidget(context, message, isCurrentUser);
              },
            ),
          ),
  );
}

Widget messageWidget(context, message, isCurrentUser) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isCurrentUser) ...[
          // The avatar is placed here, outside the message box
          matchAvatar('', true, true, 42, 42,
              onlineDotTop: 3,
              onlineDotRight: 4,
              onlineDotHeight: 6,
              onlineDotWidth: 6),
          const SizedBox(width: 7)
        ],
        messageRight(context, message, isCurrentUser),
      ],
    ),
  );
}

messageRight(context, message, isCurrentUser) {
  return Column(
    crossAxisAlignment:
        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      // Message box with bottom spacing
      messageBox(context, message, isCurrentUser),
      // if (!isCurrentUser) const SizedBox(height: 22),
      const SizedBox(height: 4),
      readSection(true),
    ],
  );
}

messageBox(context, message, isCurrentUser) {
  return SizedBox(
    child: Container(
      // width: MediaQuery.of(context).size.width * 0.7,
      // width: double.minPositive,
      constraints: BoxConstraints(
        minWidth: double.minPositive,
        // maxWidth:
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      padding: const EdgeInsets.all(16),
      // margin: const EdgeInsets.only(
      //     bottom: 22), // Add margin here for spacing
      decoration: BoxDecoration(
        color: isCurrentUser
            ? const Color.fromRGBO(233, 64, 87, 0.07)
            : const Color.fromRGBO(243, 243, 243, 1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(0),
        ),
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: CColors.secondary,
          height: 1.5,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
    ),
  );
}

Widget readSection(bool isRead) {
  return Row(
    children: [
      readText(),
      const SizedBox(width: 4),
      markReadIcon(isRead), // Pass the read status to the icon
    ],
  );
}

Widget readText() {
  return Text(
    '15 mins',
    style: TextStyle(
      color: CColors.textOpacity,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
  );
}

Widget markReadIcon(bool isRead) {
  return Container();
}

Widget messageInputBox(messageController, sendMessage) {
  return Padding(
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
            controller: messageController,
            decoration: const InputDecoration(
              hintText: 'Type your message...',
              border: InputBorder.none,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send, color: Colors.red),
          onPressed: sendMessage,
        ),
      ],
    ),
  );
}

class CustomMenuWidget extends StatelessWidget {
  const CustomMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);

    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        // Show the popup menu
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;

        showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(
              textDirection == TextDirection.rtl ? 0 : 1000, 50, 10, 0),
          color: Colors.white,
          items: [
            PopupMenuItem(
              value: 'Block',
              child: Row(
                children: [
                  Icon(Icons.block,
                      color: Colors.red), // Replace with custom SVG if needed
                  const SizedBox(width: 10),
                  Text('Block'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'DND',
              child: Row(
                children: [
                  Icon(Icons
                      .remove_circle_outline), // Replace with custom SVG if needed
                  const SizedBox(width: 10),
                  Text('DND'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'Report',
              child: Row(
                children: [
                  Icon(Icons
                      .person_outline), // Replace with custom SVG if needed
                  const SizedBox(width: 10),
                  Text('Report'),
                ],
              ),
            ),
          ],
        ).then((String? value) {
          if (value != null) {
            if (value == 'Block') {
              // Handle block
              print('Block selected');
            } else if (value == 'DND') {
              // Handle Do Not Disturb
              print('Do Not Disturb selected');
            } else if (value == 'Report') {
              // Handle report
              print('Report selected');
            }
          }
        });
      },
      child: Padding(
        padding: textDirection == TextDirection.rtl
            ? const EdgeInsets.only(left: 20.0)
            : const EdgeInsets.only(right: 20.0),
        child: Container(
          height: 52,
          width: 52,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFFE8E6EA),
            ),
          ),
          child: SvgPicture.asset(
            'assets/svg/more-one.svg',
          ),
        ),
      ),
    );
  }
}
