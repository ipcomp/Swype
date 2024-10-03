import 'package:flutter/material.dart';

class LoaderScreen extends StatelessWidget {
  final String gifPath; // Path to the GIF asset

  const LoaderScreen({super.key, required this.gifPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.5),
      body: Stack(
        children: [
          // Center the GIF in the screen
          Center(
            child: SizedBox(
              width: 55,
              height: 55,
              child: Image.asset(gifPath),
            ),
          ),
          // Optionally, you can add a semi-transparent overlay
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.7), // A light overlay
            ),
          ),
        ],
      ),
    );
  }
}
