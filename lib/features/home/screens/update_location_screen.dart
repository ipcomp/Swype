import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class UpdateLocationScreen extends ConsumerStatefulWidget {
  const UpdateLocationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateLocationScreenState();
}

class _UpdateLocationScreenState extends ConsumerState<UpdateLocationScreen> {
  @override
  Widget build(BuildContext context) {
    final translations = CHelperFunctions().getTranslations(ref);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 75,
        title: Text(
          translations['Change Location'] ?? 'Change Location',
          style: TextStyle(
            color: CColors.secondary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                elevation: WidgetStateProperty.all(0),
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                shadowColor: WidgetStateProperty.all(Colors.transparent),
              ),
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
                  'assets/svg/back_right.svg',
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text("Update Location"),
      ),
    );
  }
}
