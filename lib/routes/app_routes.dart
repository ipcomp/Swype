import 'package:flutter/material.dart';
import 'package:swype/features/authentication/login/screens/login/login_screen.dart';
import 'package:swype/features/authentication/login/screens/onboarding/onboarding_screen.dart';
import 'package:swype/features/authentication/register/screens/register_screen.dart';
import 'package:swype/features/authentication/login/screens/splash/splash_screen.dart';
import 'package:swype/features/chat/screens/chat_screen.dart';
import 'package:swype/features/home/screens/discover_screen.dart';
import 'package:swype/features/matches/screens/matches_screen.dart';
import 'package:swype/features/nearby/screens/nearby_screen.dart';
import 'package:swype/features/settings/screens/change_password_screen.dart';
import 'package:swype/features/settings/screens/delete_account_screen.dart';
import 'package:swype/features/settings/screens/settings_screen.dart';

class AppRoutes {
  static const String splash = "/";
  static const String onboarding = "/onboarding";
  static const String login = "/login";
  static const String register = "/register";
  static const String registerSelector = "/register-selector";
  static const String home = "/home";
  static const String nearby = "/nearby";
  static const String matches = "/matches";
  static const String chat = "/chat";
  static const String messages = "/messages";
  static const String settings = "/settings";
  static const String userPreferences = "/user-preferences";

  static const String editProfile = "/edit-profile";
  static const String subscription = "/subscription";
  static const String events = "/events";

  // Additional routes
  static const String changePassword = "/change-password";
  static const String deleteAccount = "/delete-account";
  static const String twoFactor = "/enable-2fa";
  static const String updateUserPreferences = "/update-preferences";
  static const String faq = "/faq";
  static const String changeLanguage = "/change-language";
  static const String questionAnswer = "/q&a";

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      onboarding: (context) => const OnboardingScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegistrationScreen(),
      home: (context) => const DiscoverScreen(),
      nearby: (context) => const NearByScreen(),
      matches: (context) => const MatchesScreen(),
      chat: (context) => const ChatScreen(),
      settings: (context) => const SettingsScreen(),
      changePassword: (context) => const ChangePasswordScreen(),
      deleteAccount: (context) => const DeleteAccountScreen(),
    };
  }
}
