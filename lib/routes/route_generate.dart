import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart'; // Import the package
import 'package:swype/features/authentication/register/screens/registration_selector.dart';
import 'package:swype/features/authentication/register/screens/user_preferences.dart';
import 'package:swype/features/settings/screens/change_password_screen.dart';
import 'package:swype/features/settings/screens/delete_account_screen.dart';
import 'package:swype/features/settings/screens/events/event_list_screen.dart';
import 'package:swype/features/settings/screens/faq_screen.dart';
import 'package:swype/features/settings/screens/language/language_selection_screen.dart';
import 'package:swype/features/settings/screens/profile_edit_screen.dart';
import 'package:swype/features/settings/screens/q&a/question_answer_screen.dart';
import 'package:swype/features/settings/screens/two_factor_authentication_screen.dart';
import 'package:swype/features/settings/screens/update_user_preferences.dart';
import 'package:swype/features/subscription/screens/subscription_screen.dart';
import 'app_routes.dart'; // Ensure correct path
import 'package:swype/features/authentication/login/screens/login/login_screen.dart';
import 'package:swype/features/authentication/login/screens/onboarding/onboarding_screen.dart';
import 'package:swype/features/authentication/register/screens/register_screen.dart';
import 'package:swype/features/authentication/login/screens/splash/splash_screen.dart';
import 'package:swype/features/chat/screens/chat_screen.dart';
import 'package:swype/features/home/screens/discover_screen.dart';
import 'package:swype/features/matches/screens/matches_screen.dart';
import 'package:swype/features/nearby/screens/nearby_screen.dart';
import 'package:swype/features/settings/screens/settings_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  Widget page;

  switch (settings.name) {
    case AppRoutes.splash:
      page = const SplashScreen();
      break;
    case AppRoutes.onboarding:
      page = const OnboardingScreen();
      break;
    case AppRoutes.login:
      page = LoginScreen();
      break;
    case AppRoutes.registerSelector:
      page = const RegistrationSelector();
      break;
    case AppRoutes.register:
      page = const RegistrationScreen();
      break;
    case AppRoutes.userPreferences:
      page = const UserPreferences();
      break;
    case AppRoutes.home:
      page = const DiscoverScreen();
      break;
    case AppRoutes.nearby:
      page = const NearByScreen();
      break;
    case AppRoutes.matches:
      page = const MatchesScreen();
      break;
    case AppRoutes.chat:
      page = const ChatScreen();
      break;
    case AppRoutes.settings:
      page = const SettingsScreen();
      break;
    case AppRoutes.changePassword:
      page = const ChangePasswordScreen();
      break;
    case AppRoutes.editProfile:
      page = const ProfileEditScreen();
      break;
    case AppRoutes.deleteAccount:
      page = const DeleteAccountScreen();
      break;
    case AppRoutes.twoFactor:
      page = const TwoFactorAuthenticationScreen();
      break;
    case AppRoutes.updateUserPreferences:
      page = const UpdateUserPreferences();
      break;
    case AppRoutes.faq:
      page = const FaqScreen();
      break;
    case AppRoutes.subscription:
      page = const SubscriptionPlanScreen();
      break;
    case AppRoutes.events:
      page = const EventListScreen();
      break;
    case AppRoutes.changeLanguage:
      page = const LanguageSelectionScreen(
        isFirstTime: false,
      );
      break;
    case AppRoutes.questionAnswer:
      page = const QuestionAnswerScreen();
      break;
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }

  return PageAnimationTransition(
    page: page,
    pageAnimationType:
        FadeAnimationTransition(), // Change animation type as needed
  );
}
