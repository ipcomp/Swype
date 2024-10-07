import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget customBackButtonTransparentBg(BuildContext context,
    {VoidCallback? onPress, double padding = 20.0}) {
  final textDirection = Directionality.of(context);
  bool isRtl = textDirection == TextDirection.rtl;

  String leftIcon = 'assets/svg/back_left.svg';
  String rightIcon = 'assets/svg/back_right.svg';

  // Default to Navigator.of(context).pop() if onPress is null
  final voidCallback = onPress ?? () => Navigator.of(context).pop();

  return Padding(
    padding: textDirection == TextDirection.rtl
        ? EdgeInsets.only(left: padding)
        : EdgeInsets.only(right: padding),
    child: InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent, // Add this line
      onTap: voidCallback, // Use the callback here
      child: Container(
        height: 52,
        width: 52,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFE8E6EA),
          ),
        ),
        child: SvgPicture.asset(
          isRtl ? leftIcon : rightIcon,
        ),
      ),
    ),
  );
}
