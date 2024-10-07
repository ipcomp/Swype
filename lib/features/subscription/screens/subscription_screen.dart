import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/commons/widgets/back_button_transparent_bg.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart'; // Assuming this holds color constants

class SubscriptionPlanScreen extends ConsumerStatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  ConsumerState<SubscriptionPlanScreen> createState() =>
      _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState
    extends ConsumerState<SubscriptionPlanScreen> {
  int selectedPlanIndex = 1; // Default selected plan (Popular)

  @override
  Widget build(BuildContext context) {
    final translations = CHelperFunctions().getTranslations(ref);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Platform.isIOS
          ? subscriptionPlanBody(translations)
          : SafeArea(
              child: subscriptionPlanBody(translations),
            ),
    );
  }

  Widget subscriptionPlanBody(translations) {
    final textDirection = Directionality.of(context);
    final isRtl = textDirection == TextDirection.rtl;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Image with shadow effect, outside of Padding
          Stack(
            children: [
              // Image with shadow effect
              Image.asset(
                'assets/images/subscription_dummy_image.png', // Replace with your image asset
                width: double.maxFinite,
                height: Platform.isAndroid ? 270 : 327,
                fit: BoxFit.cover,
              ),
              // Back Button
              Positioned(
                  right: isRtl ? null : 15,
                  left: isRtl ? 0 : null,
                  top: Platform.isAndroid ? 15 : 55,
                  child: customBackButtonTransparentBg(context, padding: 17)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // const SizedBox(height: 20),
                Text(
                  translations["Subscription Plan"] ?? "Subscription Plan",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: CColors.secondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                const Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod ut labore et tempor incididunt ut labore et dolore magna ut labore et ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(0, 0, 0, 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),
                // Subscription Plans List
                buildPlanOption(
                    0,
                    translations["Standard"] ?? "Standard",
                    "\$05.99",
                    "\$25.00",
                    translations["1 Year subscription"] ??
                        "1 Year subscription",
                    'standard_icon.png',
                    isRtl: isRtl),
                const SizedBox(height: 12),
                buildPlanOption(
                    1,
                    translations["Popular"] ?? "Popular",
                    "\$12.99",
                    "\$26.00",
                    translations["6 Months subscription"] ??
                        "6 Months subscription",
                    'popular_icon.png',
                    isPopular: true,
                    isRtl: isRtl),
                const SizedBox(height: 12),
                buildPlanOption(
                    2,
                    translations["Special Offer"] ?? "Special Offer",
                    "\$18.99",
                    "\$26.00",
                    translations["1 Year subscription"] ??
                        "1 Year subscription",
                    'special_offer_icon.png',
                    isRtl: isRtl),
                const SizedBox(height: 29),
                // Subscribe Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child:
                        Text(translations["Subscribe Now"] ?? "Subscribe Now"),
                  ),
                ),
                const SizedBox(height: 22),
                // Subscription Information
                const Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
                  "sed do eiusmod ut labore et dolore magna.",
                  style: TextStyle(
                      fontSize: 12, color: Color.fromRGBO(0, 0, 0, 70)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build the subscription option widget
  Widget buildPlanOption(int index, String title, String price,
      String originalPrice, String duration, String icon,
      {bool isPopular = false, required bool isRtl}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlanIndex = index;
        });
      },
      child: AnimatedScale(
        scale: selectedPlanIndex == index ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(2),
          height: 64,
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(
              color: selectedPlanIndex == index
                  ? CColors.primary
                  : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(253, 242, 243, 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: isRtl ? 0 : 17, right: isRtl ? 17 : 0),
                  // padding: const EdgeInsets.only(left: 17.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: CColors.secondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(0, 0, 0, 0.7),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                      right: isRtl ? 0 : 13.0, left: isRtl ? 13 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: CColors.secondary,
                        ),
                      ),
                      Text(
                        originalPrice,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color.fromRGBO(0, 0, 0, 0.7),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 4, height: 64, color: Colors.white),
                Container(
                  height: 60,
                  width: 53,
                  // margin: selectedPlanIndex == index ? EdgeInsets.all(3) : null,
                  padding: const EdgeInsets.only(top: 17, bottom: 17),
                  decoration: ShapeDecoration.fromBoxDecoration(BoxDecoration(
                      borderRadius: isRtl
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12))
                          : const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                      color:
                          selectedPlanIndex == index ? CColors.primary : null)),

                  child: Image.asset(
                    'assets/images/$icon',
                    color: selectedPlanIndex == index
                        ? Colors.white
                        : CColors.primary,
                    width: 25,
                    height: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
