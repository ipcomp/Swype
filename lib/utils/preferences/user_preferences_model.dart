class UserPreferencesModel {
  final bool localAuthEnabled;
  final String preferredLanguage;

  UserPreferencesModel({
    required this.localAuthEnabled,
    required this.preferredLanguage,
  });

  // CopyWith method to help update specific fields
  UserPreferencesModel copyWith({
    bool? localAuthEnabled,
    String? preferredLanguage,
  }) {
    return UserPreferencesModel(
      localAuthEnabled: localAuthEnabled ?? this.localAuthEnabled,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    );
  }
}
