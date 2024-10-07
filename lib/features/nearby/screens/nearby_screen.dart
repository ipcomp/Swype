import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swype/commons/widgets/custom_bottom_bar.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';

class NearByScreen extends ConsumerStatefulWidget {
  const NearByScreen({super.key});

  @override
  NearByScreenState createState() => NearByScreenState();
}

class NearByScreenState extends ConsumerState<NearByScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Initialize Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: false);

    // Initialize Audio Player for beep sound
    _audioPlayer = AudioPlayer();

    // Start a timer to play sonar beep every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      debugPrint("Playing beep sound");
      _playBeep();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer

    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playBeep() async {
    await _audioPlayer.play(AssetSource('sounds/sonar_beep.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, d) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(
                    'Near By You',
                    style: TextStyle(
                      color: CColors.secondary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                ),
                leadingWidth: 52,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                  },
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFFE8E6EA),
                      ),
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/back_left.svg',
                    ),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {},
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
                      child: SvgPicture.asset('assets/svg/filter.svg'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            // Wave animation background
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(_controller.value),
                  child: const SizedBox(
                    width: 300,
                    height: 300,
                  ),
                );
              },
            ),
            // Dotted circles with images
            CustomPaint(
              size: const Size(380, 380),
              painter: DottedCirclePainter(170, 110, 12),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Find Your",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: CColors.secondary,
                        fontFamily: 'SK-Modernist',
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Perfect ',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: CColors.secondary,
                              fontFamily: 'SK-Modernist',
                              height: 1.2,
                              letterSpacing: .5,
                            ),
                          ),
                          TextSpan(
                            text: 'Partner',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: CColors.primary,
                              fontFamily: 'SK-Modernist',
                              height: 1.2,
                              letterSpacing: .5,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    user!['profile_picture_url'],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: _playBeep,
                    child: const Text("Search Now"),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: customBottomBar(context, AppRoutes.nearby, ref),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;
  WavePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withOpacity(1 - progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 + progress * 8;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 4 + (size.width / 2 * progress);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Repaint every frame
  }
}

class DottedCirclePainter extends CustomPainter {
  final double radiusOuter;
  final double radiusInner;
  final int dashCount;

  DottedCirclePainter(this.radiusOuter, this.radiusInner, this.dashCount);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outerPaint = Paint()
      ..color = const Color.fromARGB(255, 207, 207, 207)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final Paint innerPaint = Paint()
      ..color = const Color.fromARGB(255, 207, 207, 207)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw outer dashed circle
    drawDashedCircle(canvas, size.center(Offset.zero), radiusOuter, outerPaint);

    // Draw inner dashed circle
    drawDashedCircle(canvas, size.center(Offset.zero), radiusInner, innerPaint);
  }

  void drawDashedCircle(
      Canvas canvas, Offset center, double radius, Paint paint) {
    double dashLength = 10.0; // Length of each dash
    double gapLength = 10.0; // Increase gap between dashes for more space
    double circumference = 2 * pi * radius;
    int dashCount = (circumference / (dashLength + gapLength)).floor();

    for (int i = 0; i < dashCount; i++) {
      double angle = 2 * pi * i / dashCount; // angle for each dash
      double x1 = center.dx + radius * cos(angle);
      double y1 = center.dy + radius * sin(angle);
      double x2 = center.dx +
          radius * cos(angle + (dashLength / circumference) * (2 * pi));
      double y2 = center.dy +
          radius * sin(angle + (dashLength / circumference) * (2 * pi));
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
