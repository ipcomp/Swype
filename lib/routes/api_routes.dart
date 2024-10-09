class ApiRoutes {
  static const String baseUrl = 'https://swype.co.il/api/v1';

  // Authentication Routes
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String verifyOTP = '$baseUrl/verify-phone-otp';
  static const String logout = '$baseUrl/logout';
  static const String refreshToken = '$baseUrl/refresh';
  static const String socialLogin = '$baseUrl/social-register-with-login';

  // Get User Profile
  static const String getUser = '$baseUrl/get-user-profile';
  static const String updateUser = '$baseUrl/user-profile-update';
  static const String uploadImages = '$baseUrl/upload-media';
  static const String allUserList = '$baseUrl/all-users-list';

  // Advance Search
  static const String advanceSearch = '$baseUrl/advanced-search';
  static const String appSettings = '$baseUrl/app-settings';

  // Update password
  static const String updatePassword = '$baseUrl/update-password';
  static const String updatePreferences = '$baseUrl/update-preferences';

  // Update Location
  static const String updateLoaction = '$baseUrl/update-location';

  // Matches
  static const String potentialMatches = '$baseUrl/get-potential-matches-user';
  static const String myMatches = '$baseUrl/get-matches-user';
  static const String swipe = '$baseUrl/swipe';

  // Chat
  static const String getConversations = '$baseUrl/get-conversations';
  static const String getMessages = '$baseUrl/get-all-messages';

  // Security
  static const String enableTwoFactor = '$baseUrl/enable-two-factor-auth';
  static const String verifyTwoFactor = '$baseUrl/verify-two-factor-auth';
  static const String disableTwoFactor = '$baseUrl/disable-two-factor-auth';

  // Delete Account
  static const String otpSendForDelete = '$baseUrl/send-otp-for-delete-account';
  static const String resendOtpForDelete = '$baseUrl/resend-phone-otp';
  static const String otpVerifyForDelete =
      '$baseUrl/verify-otp-and-delete-account';

  // Content Management
  static const String getAllEvents = '$baseUrl/get-all-events-list';
  static const String getEventById = '$baseUrl/get-event-by-id';
  static const String getOnBoardingData = '$baseUrl/onboard-screen';

  // Utils
  static const String userOptions = '$baseUrl/user-profile-options';
  static const String getCities = '$baseUrl/cities';
  static const String faqList = '$baseUrl/faq-list';

  // Translations
  static const String getTranslations = '$baseUrl/get-translations';
}
