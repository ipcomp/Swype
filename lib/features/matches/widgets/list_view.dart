import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/features/matches/models/matches_modal.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/loader_screen.dart';

Widget buildListView(
    List<MatchModalItem> data,
    void Function(String liked, int userId, MatchModalItem match) onTap,
    bool isLoading) {
  return Stack(
    children: [
      ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final user = data[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: CColors.accent,
                  width: 1,
                ),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: Stack(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFF27121),
                          Color(0xFFE94057),
                          Color(0xFF8A2387),
                        ],
                        stops: [0.1, 0.6, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  color: Colors.white,
                                  child: Image.network(
                                    user.profilePictureUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ))),
                  ),
                  const Positioned(
                    top: 10,
                    right: 0,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: Color(0xFF13DC1A),
                    ),
                  ),
                ],
              ),
              title: Text(
                user.username,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: CColors.secondary,
                ),
              ),
              subtitle: Text(
                user.swipedAt.toIso8601String(),
                style: TextStyle(
                  color: CColors.borderColor,
                  fontSize: 10,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (user.isMatch)
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 32,
                        width: 32,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(136, 136, 136, 0.377),
                              blurRadius: 25.0,
                              spreadRadius: 0,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/chat.svg',
                          height: 14,
                          colorFilter: ColorFilter.mode(
                              CColors.primary, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  if (user.isMatch == false)
                    GestureDetector(
                      onTap: () {
                        onTap('dislike', user.userId, user);
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(136, 136, 136, 0.2),
                              blurRadius: 25.0,
                              spreadRadius: 0,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/cancel.svg',
                          height: 15,
                        ),
                      ),
                    ),
                  if (user.isMatch == false) const SizedBox(width: 15),
                  if (user.isMatch == false)
                    GestureDetector(
                      onTap: () {
                        onTap('like', user.userId, user);
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(136, 136, 136, 0.2),
                              blurRadius: 25.0,
                              spreadRadius: 0,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/favorite.svg',
                          colorFilter: ColorFilter.mode(
                            CColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      if (isLoading)
        const LoaderScreen(
          gifPath: "assets/gif/loader.gif",
        ),
    ],
  );
}
