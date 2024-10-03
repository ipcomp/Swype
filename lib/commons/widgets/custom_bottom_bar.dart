import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

Widget customBottomBar(context, currentRouteName, WidgetRef ref) {
  final translations = CHelperFunctions().getTranslations(ref);
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Container(
      width: double.infinity,
      height: 68,
      color: const Color(0xFFF3F3F3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildbottombutton(translations['Home'] ?? 'Home', AppRoutes.home,
              'assets/svg/home.svg', currentRouteName, 21, context),
          buildbottombutton(
              translations['Nearby'] ?? 'Nearby',
              AppRoutes.nearby,
              'assets/svg/location.svg',
              currentRouteName,
              23,
              context),
          buildbottombutton(
              translations['Matches'] ?? 'Matches',
              AppRoutes.matches,
              'assets/svg/favorite.svg',
              currentRouteName,
              20,
              context),
          buildbottombutton(translations['Chat'] ?? 'Chat', AppRoutes.chat,
              'assets/svg/chat.svg', currentRouteName, 21, context),
          buildbottombutton(
              translations['Profile'] ?? 'Profile',
              AppRoutes.settings,
              'assets/svg/user.svg',
              currentRouteName,
              21,
              context),
        ],
      ),
    ),
  );
}

Expanded buildbottombutton(String label, String route, String icon,
    String currentRouteName, double size, BuildContext context) {
  final textColor =
      route == currentRouteName ? CColors.primary : CColors.borderColor;
  final Color borderColor =
      currentRouteName == route ? CColors.primary : CColors.accent;
  return Expanded(
    child: GestureDetector(
      onTap: () {
        if (currentRouteName == route) {
          return;
        } else {
          // For any other route, navigate normally
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: borderColor,
              width: 1.5,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: size,
              colorFilter: ColorFilter.mode(
                textColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
