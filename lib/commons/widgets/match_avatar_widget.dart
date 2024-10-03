import 'package:flutter/material.dart';

Widget matchAvatar(String imagePath, bool hasStatus, bool isOnline,
    double width, double height,
    {required double onlineDotTop,
    required double onlineDotRight,
    required double onlineDotHeight,
    required double onlineDotWidth,
    bool doShowInsidePadding = true,
    double insidePadding = 2}) {
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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: doShowInsidePadding ? Colors.white : Colors.transparent,
          ),
          padding:
              hasStatus ? EdgeInsets.all(insidePadding) : null, // Inner padding
          child: CircleAvatar(
            radius: height / 2 - 1.5, // Adjust radius based on height
            backgroundImage: imagePath.isEmpty
                ? const AssetImage('assets/images/dummy_profile_pic.png')
                : NetworkImage(imagePath), // Use the provided image path
          ),
        ),
      ),
      Positioned(
        right: onlineDotRight,
        top: onlineDotTop,
        child: SizedBox(
          width: onlineDotWidth, // Set the width
          height: onlineDotHeight, // Set the height
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
