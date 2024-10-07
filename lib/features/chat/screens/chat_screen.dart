import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/commons/widgets/custom_bottom_bar.dart';
import 'package:swype/features/chat/models/matches_use_modal.dart';
import 'package:swype/features/chat/provider/match_user_provider.dart';
import 'package:swype/features/chat/screens/messages_screen.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final matchesUserProvider = ref.watch(matchUserProvider);
    final textDirection = Directionality.of(context);

    return Scaffold(
      appBar: appBar(textDirection),
      body: chatScreenBody(matchesUserProvider),
      bottomNavigationBar: customBottomBar(context, AppRoutes.chat, ref),
    );
  }

  Widget chatScreenBody(MatchesUserModal matchesUserProvider) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 27),
        searchField(),
        const SizedBox(height: 10),
        matchText(),
        const SizedBox(height: 10),
        matchStatus(matchesUserProvider),
        messageText(),
        const SizedBox(height: 10),
        messageListView(matchesUserProvider),
        const SizedBox(height: 10),
      ]),
    );
  }

  Widget searchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          prefixIcon: Container(
            width: 20,
            height: 20,
            padding:
                const EdgeInsets.only(left: 20, right: 11, top: 14, bottom: 13),
            child: SvgPicture.asset('assets/svg/search.svg'),
          ),
          hintText: 'Search',
          hintStyle: TextStyle(
            color: CColors.secondary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            // height: 1.4,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: CColors.primary),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: CColors.accent),
          ),
        ),
      ),
    );
  }

  Widget matchText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Match',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget matchStatus() {
  //   return SizedBox(
  //     height: 100,
  //     child: ListView(
  //       scrollDirection: Axis.horizontal,
  //       children: [
  //         const SizedBox(width: 20),
  //         buildMatchAvatarForStatus('You', 'assets/you.jpg', true, true),
  //         const SizedBox(width: 15),
  //         buildMatchAvatarForStatus('Emma', 'assets/emma.jpg', true, false),
  //         const SizedBox(width: 15),
  //         buildMatchAvatarForStatus('Ava', 'assets/ava.jpg', true, true),
  //         const SizedBox(width: 15),
  //         buildMatchAvatarForStatus(
  //             'Sophia', 'assets/sophia.jpg', false, false),
  //         const SizedBox(width: 15),
  //         buildMatchAvatarForStatus('Sophia', 'assets/sophia.jpg', false, true),
  //         const SizedBox(width: 15),
  //         buildMatchAvatarForStatus(
  //             'Sophia', 'assets/sophia.jpg', false, false),
  //         const SizedBox(width: 15),
  //         buildMatchAvatarForStatus(
  //             'Sophia', 'assets/sophia.jpg', false, false),
  //         const SizedBox(width: 20),
  //       ],
  //     ),
  //   );
  // }

  Widget matchStatus(MatchesUserModal matchesUserProvider) {
    // Ensure that matchesUserProvider.matches is not null
    if (matchesUserProvider.matches == null ||
        matchesUserProvider.matches!.isEmpty) {
      return const Center(
        child: Text('No Matches'),
      );
    }

    return Column(
      children: [
        // const SizedBox(height: 20),
        Row(
          children: matchesUserProvider.matches!.map((match) {
            // Safely access matchUser and provide default values
            final matchUser = match.matchUser;
            final username = matchUser?.username ?? 'NA';
            final profilePictureUrl = matchUser?.profilePictureUrl ?? 'NA';

            return Row(
              children: [
                const SizedBox(width: 15),
                buildMatchAvatarForStatus(
                    username, profilePictureUrl, true, true),
              ],
            );
          }).toList(), // Convert the Iterable to a List
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget messageText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Messages',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget messageListView() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Column(
  //       children: [
  //         _buildMessageTile('Emelie', 'You: Hey! What’s up, long time..',
  //             '23 min', true, true, false),
  //         const SizedBox(height: 6),
  //         _buildMessageTile('Abigail', 'Typing..', '27 min', true, true, true),
  //         const SizedBox(height: 6),
  //         _buildMessageTile(
  //             'Elizabeth', 'Ok, see you then.', '33 min', false, false, false),
  //         const SizedBox(height: 6),
  //         _buildMessageTile('Penelope', 'You: Hey! What’s up, long time..',
  //             '50 min', true, false, true),
  //         const SizedBox(height: 6),
  //         _buildMessageTile('Chloe', 'You: Hello how are you?', '55 min', false,
  //             false, false),
  //         const SizedBox(height: 6),
  //         _buildMessageTile('Grace', 'You: Great I will write later', '1 hour',
  //             true, false, false),
  //       ],
  //     ),
  //   );
  // }
  Widget messageListView(MatchesUserModal matchesUserProvider) {
    // Ensure that matchesUserProvider.matches is not null
    if (matchesUserProvider.matches == null ||
        matchesUserProvider.matches!.isEmpty) {
      return const Center(
        child: Text('No Messages'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: matchesUserProvider.matches!.map((match) {
          // Safely access matchUser and provide default values
          final matchUser = match.matchUser;
          final username = matchUser?.username ?? 'NA';
          final profilePictureUrl = matchUser?.profilePictureUrl ?? 'NA';

          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                    builder: (context) => const MessagesScreen(
                          userId: '3',
                        )),
              );
            },
            child: Padding(
              // padding: const EdgeInsets.only(bottom: 6),
              padding:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 6, top: 6),

              child: _buildMessageTile(
                username,
                'You: Hey! What’s up, long time..',
                profilePictureUrl,
                '23 min',
                true,
                true,
                false,
              ),
            ),
          );
        }).toList(), // Convert the Iterable to a List
      ),
    );
  }

  PreferredSizeWidget appBar(TextDirection textDirection) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          'Messages',
          style: TextStyle(
            color: CColors.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      titleSpacing: 0,
      actions: [
        Padding(
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
              'assets/svg/filter.svg',
            ),
          ),
        ),
      ],
    );
  }
/*
  Widget _buildMatchAvatar(String name, String imagePath, bool online) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage:
                  AssetImage('assets/images/dummy_profile_pic.png'),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.transparent,
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor: online
                      ? const Color.fromRGBO(19, 220, 26, 1)
                      : const Color.fromRGBO(225, 225, 225, 1),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          name,
          style: TextStyle(
              color: CColors.secondary,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
 */

  // Widget to build avatars with a gradient border when online
  Widget buildMatchAvatarForStatus(
      String name, String imagePath, bool hasStatus, bool isOnline) {
    return Column(
      children: [
        matchAvatar(imagePath, hasStatus, true, 66, 66),
        const SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(
              color: CColors.secondary,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget matchAvatar(String imagePath, bool hasStatus, bool isOnline,
      double width, double height) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: width, // Set the width
          height: height, // Set the height
          padding:
              hasStatus ? const EdgeInsets.all(2) : null, // For gradient border
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: hasStatus
                ? const LinearGradient(
                    colors: [
                      Color.fromRGBO(242, 113, 33, 1),
                      Color.fromRGBO(233, 64, 87, 1),
                      Color.fromRGBO(138, 35, 135, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null, // Show gradient only if there's a status
          ),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding:
                hasStatus ? const EdgeInsets.all(2) : null, // Inner padding
            child: CircleAvatar(
              radius: height / 2 - 1.5, // Adjust radius based on height
              backgroundImage: NetworkImage(
                imagePath,
              ), // Use the provided image path
            ),
          ),
        ),
        if (isOnline)
          Positioned(
            right: width == 66 ? (hasStatus ? 1 : 0) : (hasStatus ? 0 : -2),
            top: width == 66 ? 10 : 8,
            child: SizedBox(
              width: 11, // Set the width
              height: 11, // Set the height
              child: CircleAvatar(
                radius: 5.5, // Outer CircleAvatar radius
                backgroundColor: Colors.transparent,
                child: CircleAvatar(
                  radius: 4.5, // Inner circle should be slightly smaller
                  backgroundColor: isOnline
                      ? const Color.fromRGBO(19, 220, 26, 1) // Online color
                      : const Color.fromRGBO(225, 225, 225, 1), // Offline color
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMessageTile(String name, String message, String profileImgUrl,
      String time, bool isOnline, bool isUnread, bool hasStatus) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            matchAvatar(profileImgUrl, hasStatus, isOnline, 56, 56),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  listTileTitle(name, time),
                  listTileSubTitle(message, isUnread),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(
            color: Color.fromRGBO(232, 230, 234, 1), height: 1, indent: 70)
      ],
    );
  }

  Widget listTileTitle(name, time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          name,
          style: TextStyle(
              color: CColors.secondary,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w700),
        ),
        Text(time,
            style: TextStyle(
                color: CColors.borderColor,
                height: 1.5,
                fontWeight: FontWeight.w700,
                fontSize: 12)),
      ],
    );
  }

  Widget listTileSubTitle(String message, bool isUnread) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          message,
          style: TextStyle(
              color: isUnread ? CColors.primary : CColors.secondary,
              height: 1.5,
              fontWeight: isUnread ? FontWeight.w700 : FontWeight.w400,
              fontSize: 14),
        ),
        if (isUnread)
          CircleAvatar(
            radius: 10,
            backgroundColor: CColors.primary,
            child: const Text(
              '1',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  height: 1.5,
                  fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}
