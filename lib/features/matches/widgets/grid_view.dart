import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/features/matches/models/matches_modal.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/loader_screen.dart';

Widget buildGridView(
    List<MatchModalItem> data,
    void Function(String liked, int userId, MatchModalItem match) onTap,
    bool isLoading) {
  final today = DateTime.now();
  Map<String, List<MatchModalItem>> matches = {
    'Today': [],
    'Yesterday': [],
    '1 days ago': [],
    '2 days ago': [],
    '3 days ago': [],
    '4 days ago': [],
    '5 days ago': [],
    '6 days ago': [],
    'Few days ago': [],
  };

  // Process each user in the data
  for (var user in data) {
    // final matchDate = DateTime.parse(user['matchDate']);
    final difference = today.difference(user.swipedAt).inDays;

    if (difference >= 0) {
      String key;

      if (difference < 7) {
        key = difference == 0
            ? 'Today'
            : difference == 1
                ? 'Yesterday'
                : '$difference days ago';
      } else {
        key = 'Few days ago'; // For 7 or more days ago
      }

      // Safely add the user to the matches map
      matches[key]?.add(user);
    }
  }

  // print("Loading: $isLoading");

  return Stack(children: [
    SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: matches.entries.map((entry) {
            if (entry.value.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: CColors.accent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          bottom: 17,
                          top: 15,
                        ),
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            color: CColors.textOpacity,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: CColors.accent,
                        ),
                      ),
                    ],
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: entry.value.length,
                    itemBuilder: (context, index) {
                      final user = entry.value[index];
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(user.profilePictureUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${user.username}, ${user.age}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 15.0, sigmaY: 15.0),
                                child: Container(
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: user.isMatch
                                      ? GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                'assets/svg/chat.svg',
                                                height: 24,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    onTap('dislike',
                                                        user.userId, user);
                                                  },
                                                  child: Center(
                                                    child: SvgPicture.asset(
                                                      'assets/svg/cancel.svg',
                                                      height: 24,
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                        Colors.white,
                                                        BlendMode.srcIn,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Handle 'like' action
                                                  onTap('like', user.userId,
                                                      user);
                                                },
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    'assets/svg/favorite.svg',
                                                    height: 20,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            } else {
              return const SizedBox
                  .shrink(); // If no users, return empty widget
            }
          }).toList(),
        ),
      ),
    ),
    if (isLoading)
      const LoaderScreen(
        gifPath: "assets/gif/loader.gif",
      ),
  ]);
}
