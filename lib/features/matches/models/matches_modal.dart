class MatchModalItem {
  final int id;
  final int userId;
  final DateTime swipedAt;
  final String status;
  final String username;
  final String firstName;
  final String lastName;
  final String profilePictureUrl;
  final int age;
  final bool isMatch;

  MatchModalItem({
    required this.id,
    required this.userId,
    required this.swipedAt,
    required this.status,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.profilePictureUrl,
    required this.age,
    required this.isMatch,
  });

  factory MatchModalItem.fromJson(Map<String, dynamic> json, bool isMatch) {
    return MatchModalItem(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      swipedAt: DateTime.parse(json['swiped_at']),
      status: json['status'] ?? '',
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      profilePictureUrl: json['profile_picture_url'] ?? '',
      age: json['age'] ?? 0,
      isMatch: isMatch,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'swiped_at': swipedAt.toIso8601String(),
      'status': status,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'profile_picture_url': profilePictureUrl,
      'age': age,
      'is_match': isMatch,
    };
  }
}

class MatchModal {
  final List<MatchModalItem> mergedItems;

  MatchModal({
    required this.mergedItems,
  });

  factory MatchModal.fromJson(Map<String, dynamic> json) {
    List<MatchModalItem> mergedItems = [];

    // Merge swipes_received with isMatch = false
    if (json['swipes_received'] != null) {
      mergedItems.addAll((json['swipes_received'] as List)
          .map((item) => MatchModalItem.fromJson(item, false))
          .toList());
    }

    // Merge matches with isMatch = true
    if (json['matches'] != null) {
      mergedItems.addAll((json['matches'] as List)
          .map((item) => MatchModalItem.fromJson(item, true))
          .toList());
    }

    return MatchModal(
      mergedItems: mergedItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merged_items': mergedItems.map((item) => item.toJson()).toList(),
    };
  }
}
