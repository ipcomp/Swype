import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/commons/widgets/back_button_transparent_bg.dart';
import 'package:swype/commons/widgets/custom_bottom_bar.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/settings/controllers/logout_service.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends ConsumerState<SettingsScreen> {
  LogoutService logoutService = LogoutService();
  bool isLoading = false;
  bool isUserLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void logoutUser() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    final response = await logoutService.logoutUser(ref, context);

    if (mounted) {
      if (response) {
        CHelperFunctions.showToaster(context, 'Logout Success');
      } else {
        CHelperFunctions.showToaster(context, 'Logout failed');
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  String capitalize(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final translations = CHelperFunctions().getTranslations(ref);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, d) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      },
      child: user == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              backgroundColor: const Color(0xFFFDECEE),
              appBar: AppBar(
                toolbarHeight: 75,
                titleSpacing: 27,
                backgroundColor: const Color(0xFFFDECEE),
                title: Text(
                  translations['General Settings'] ?? 'General Settings',
                  style: TextStyle(
                    color: CColors.secondary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
                centerTitle: false,
                automaticallyImplyLeading: false,
                actions: [
                  customBackButtonTransparentBg(context, onPress: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  })
                ],
              ),
              body: SingleChildScrollView(
                child: SizedBox(
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFDECEE),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      height: 55,
                                      width: 55,
                                      child: Image.network(
                                        user['profile_picture_url'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        capitalize(user['username']),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          height: 1.5,
                                          color: CColors.secondary,
                                        ),
                                      ),
                                      Text(
                                        user['email'] ?? '',
                                        style: TextStyle(
                                          color: CColors.secondary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/edit-profile',
                                  );
                                },
                                child: SvgPicture.asset(
                                  'assets/svg/edit_icon.svg',
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: buildSettingsList(translations),
                      )
                    ],
                  ),
                ),
              ),
              bottomNavigationBar:
                  customBottomBar(context, AppRoutes.settings, ref),
            ),
    );
  }

  // Widget for displaying Settings Options
  Widget buildSettingsList(translations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Account Settings
        const SizedBox(height: 10),
        Text(
          translations['Account Settings'] ?? "Account Settings",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(21, 33, 31, .7),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 15),

        buildSettingOption(
          translations['Subscriptions'] ?? "Subscriptions",
          'assets/svg/pricing.svg',
          "/subscription",
        ),
        buildSettingOption(
          translations['Change Password'] ?? "Change Password",
          'assets/svg/change_password_icon.svg',
          "/change-password",
        ),
        buildSettingOption(
          translations['Enable 2 Factor Authentication (2FA)'] ??
              "Enable 2 Factor Authentication (2FA)",
          'assets/svg/two_factor_icon.svg',
          "/enable-2fa",
        ),
        buildSettingOption(
          translations['Update User Preferences'] ?? "Update User Preferences",
          'assets/svg/filter.svg',
          "/update-preferences",
        ),
        buildSettingOption(
          translations['Update Preferred Language'] ??
              "Update Preferred Language",
          'assets/svg/flag.svg',
          "/change-language",
        ),
        buildSettingOption(
          translations['Face ID'] ?? "Face ID",
          'assets/svg/face_id_icon.svg',
          "/face-id",
        ),

        const SizedBox(height: 20),

        // Community Settings
        Text(
          translations['Community Settings'] ?? "Community Settings",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color.fromRGBO(21, 33, 31, .7),
            height: 1.5,
          ),
        ),

        const SizedBox(height: 15),
        buildSettingOption(
          translations['Friends & Social'] ?? "Friends & Social",
          'assets/svg/groups.svg',
          "/friends-social",
        ),
        buildSettingOption(
          translations['Following List'] ?? "Following List",
          'assets/svg/dotted_bar.svg',
          "/following-list",
        ),
        buildSettingOption(
          translations['Events'] ?? "Events",
          'assets/svg/events.svg',
          "/events",
        ),

        const SizedBox(height: 20),

        // Others
        Text(
          translations['Others'] ?? "Others",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color.fromRGBO(21, 33, 31, .7),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 15),
        buildSettingOption(
          translations['FAQ'] ?? "FAQ",
          'assets/svg/faq.svg',
          "/faq",
        ),
        buildSettingOption(
          translations['Help Center'] ?? "Help Center",
          'assets/svg/help_center_icon.svg',
          "/help-center",
        ),
        buildSettingOption(
          translations['Question/Answer'] ?? "Question/Answer",
          'assets/svg/q&a.svg',
          "/q&a",
        ),
        const SizedBox(height: 20),

        // Others
        Text(
          translations['Delete Account'] ?? "Delete Account",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(21, 33, 31, .7),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 15),
        buildSettingOption(
          translations['Delete Account'] ?? "Delete Account",
          'assets/svg/delete_icon.svg',
          "/delete-account",
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: logoutUser,
            child: isLoading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 24.0,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3.0,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Logging out...",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )
                : Text(translations['Logout'] ?? "Logout"),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  // Reusable widget to create setting options
  Widget buildSettingOption(String title, String icon, String route) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 3,
        vertical: 0,
      ),
      leading: SvgPicture.asset(
        height: 24,
        width: 24,
        icon,
        colorFilter: ColorFilter.mode(
          CColors.primary,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: CColors.secondary,
          height: 1.5,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Color.fromRGBO(21, 33, 31, .4),
        weight: 20,
        size: 18,
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
