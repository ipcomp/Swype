import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/utils/constants/colors.dart'; // Assuming this holds color constants

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    height: 270,
                    fit: BoxFit.cover,
                  ),
                  // Back Button
                  Positioned(
                    right: 15,
                    top: 15,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: CColors.primary,
                        ),
                      ),
                    ),
                  ),
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
                      "Subscription Plan",
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
                    buildPlanOption(0, "Standard", "\$05.99", "\$25.00",
                        "1 Year subscription", 'standard_icon.png'),
                    const SizedBox(height: 12),
                    buildPlanOption(1, "Popular", "\$12.99", "\$26.00",
                        "6 Months subscription", 'popular_icon.png',
                        isPopular: true),
                    const SizedBox(height: 12),
                    buildPlanOption(2, "Special Offer", "\$18.99", "\$26.00",
                        "1 Year subscription", 'special_offer_icon.png'),
                    const SizedBox(height: 29),
                    // Subscribe Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Subscribe Now"),
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
        ),
      ),
    );
  }

  // Helper method to build the subscription option widget
  Widget buildPlanOption(int index, String title, String price,
      String originalPrice, String duration, String icon,
      {bool isPopular = false}) {
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
              color: Color.fromRGBO(253, 242, 243, 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 17.0),
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
                  padding: const EdgeInsets.only(right: 20.0),
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
                      borderRadius: const BorderRadius.only(
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
