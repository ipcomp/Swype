import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/localizations/language_provider.dart';
import 'package:swype/utils/preferences/preferences_provider.dart';

class CHelperFunctions {
  static OverlayEntry? _currentOverlayEntry;

  getTranslations(WidgetRef ref) {
    final currentLang = ref.watch(preferencesProvider).preferredLanguage;
    final translations = ref.watch(langProvider)?[currentLang];
    return translations;
  }

  static void showToaster(BuildContext context, String message) {
    // Close any existing toast
    _currentOverlayEntry?.remove();
    _currentOverlayEntry = null;

    final overlay = Overlay.of(context);
    _currentOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 - 40,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(_currentOverlayEntry!);

    // Automatically remove the toast after a duration (5 seconds)
    Future.delayed(const Duration(seconds: 5), () {
      if (_currentOverlayEntry?.mounted ?? false) {
        _currentOverlayEntry?.remove();
        _currentOverlayEntry = null; // Clear the reference
      }
    });
  }

  static void showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String customTimeAgo(String dateTimeStr) {
    // Parse the ISO 8601 string to DateTime
    final DateTime dateTime = DateTime.parse(dateTimeStr);
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 0) {
      // If the date is in the future
      return 'in the future';
    } else if (difference.inSeconds == 0) {
      return 'just now'; // Return 'just now' for zero seconds
    } else if (difference.inSeconds < 60) {
      return '${difference.inSeconds} second${difference.inSeconds > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      int years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
