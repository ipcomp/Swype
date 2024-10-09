import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:swype/features/authentication/providers/all_users_provider.dart';
import 'package:swype/features/authentication/providers/auth_provider.dart';
import 'package:swype/features/authentication/login/screens/onboarding/onboarding_screen.dart';
import 'package:swype/features/authentication/providers/register_provider.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/authentication/register/screens/otp_verification_screen.dart';
import 'package:swype/features/authentication/register/screens/profile_details_screen.dart';
import 'package:swype/features/authentication/register/screens/update_location.dart';
import 'package:swype/features/authentication/register/screens/user_preferences.dart';
import 'package:swype/features/chat/controllers/chat_controller.dart';
import 'package:swype/features/chat/provider/chat_conversations_provider.dart';
import 'package:swype/features/home/controllers/discover_controller.dart';
import 'package:swype/features/home/screens/discover_screen.dart';
import 'package:swype/features/settings/screens/language/language_selection_screen.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/preferences/preferences_provider.dart';

class SplashController {
  final WidgetRef ref;
  DioClient dioClient = DioClient();
  DiscoverController discoverController = DiscoverController();
  ChatController chatController = ChatController();
  final LocalAuthentication auth = LocalAuthentication();

  SplashController(this.ref);

  void navigationHandler(BuildContext context) async {
    ref.read(authProvider.notifier);
    ref.read(registerProvider.notifier);
    ref.read(preferencesProvider);
    await Future.delayed(const Duration(seconds: 4));

    final isAuthenticated = ref.read(authProvider).isAuthenticated;
    final prefs = ref.read(preferencesProvider);
    final userId = ref.read(authProvider).userId;
    print(userId);
    final userState = ref.read(registerProvider);
    final isRegistered = userState['isRegistered'];
    final isOtpVerified = userState['isOtpVerified'];
    final isDetailsFilled = userState['isDetailsFilled'];
    final isLocationUpdated = userState['isLocationUpdated'];
    final isPreferencesUpdated = userState['isPreferencesUpdated'];

    if (prefs.preferredLanguage == '') {
      Navigator.pushReplacement(
        context,
        PageAnimationTransition(
          page: const LanguageSelectionScreen(
            isFirstTime: true,
          ),
          pageAnimationType: FadeAnimationTransition(),
        ),
      );
    } else if (isRegistered && !isOtpVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(
            phoneNumber: userState['phone'],
          ),
        ),
      );
    } else if (isRegistered && isOtpVerified && !isDetailsFilled) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileDetailsScreen(),
        ),
      );
    } else if (isRegistered &&
        isOtpVerified &&
        isDetailsFilled &&
        !isLocationUpdated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateLocationScreen(),
        ),
      );
    } else if (isRegistered &&
        isOtpVerified &&
        isDetailsFilled &&
        isLocationUpdated &&
        !isPreferencesUpdated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserPreferences(),
        ),
      );
    } else if (isAuthenticated) {
      String? token = await getAuthToken();
      if (token != null) {
        ref.read(allUsersProvider.notifier).fetchUserList(token);
        final conversations = await chatController.fecthConversations();
        ref
            .read(chatConversationProvider.notifier)
            .loadConversations(conversations);
      } else {
        print("Getting token null");
      }
      final response = await dioClient.get(
        '${ApiRoutes.getUser}?user_id=$userId',
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status_code'] == 200) {
          if (prefs.localAuthEnabled) {
            final res = await _authenticate(context);
            if (res) {
              ref.read(userProvider.notifier).setUser(data['data']['user']);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DiscoverScreen(),
                ),
              );
            } else {
              SystemNavigator.pop();
            }
          } else {
            ref.read(userProvider.notifier).setUser(data['data']['user']);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DiscoverScreen(),
              ),
            );
          }
        } else {
          ref.read(preferencesProvider.notifier).setLocalAuth(false);
        }
      } else {
        CHelperFunctions.showToaster(context, response.statusMessage!);
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    }
  }

  Future<bool> _authenticate(BuildContext context) async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access your profile',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      if (isAuthenticated) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      CHelperFunctions.showToaster(context, "message");
      return false;
    }
  }

  Future<String?> getAuthToken() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();

    String? token = await storage.read(key: 'auth_token');

    return token;
  }
}
