class Candidate {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? emailVerificationCode;
  int? emailVerified;
  String? phone;
  String? gender;
  String? bio;
  String? profilePictureUrl;
  String? dateOfBirth;
  int? age;
  String? height;
  int? bodyType;
  int? maritalStatus;
  int? hasChildren;
  int? wantsChildren;
  int? zodiacSign;
  int? religion;
  String? politicalViews;
  int? education;
  String? profession;
  String? company;
  int? smokingHabits;
  int? drinkingHabits;
  int? exerciseFrequency;
  int? dietType;
  int? travelFrequency;
  String? currentCity;
  int? hometown;
  String? status;
  String? role;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? phoneVerificationCode;
  int? phoneVerified;
  String? isOnline;
  String? lastOnlineTime;
  int? agreedToTerms;
  String? googleId;
  String? facebookId;
  String? appleId;
  int? twoFactorAuthentication;
  String? preferredLanguage;
  List<dynamic>? images;

  Candidate(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.emailVerificationCode,
      this.emailVerified,
      this.phone,
      this.gender,
      this.bio,
      this.profilePictureUrl,
      this.dateOfBirth,
      this.age,
      this.height,
      this.bodyType,
      this.maritalStatus,
      this.hasChildren,
      this.wantsChildren,
      this.zodiacSign,
      this.religion,
      this.politicalViews,
      this.education,
      this.profession,
      this.company,
      this.smokingHabits,
      this.drinkingHabits,
      this.exerciseFrequency,
      this.dietType,
      this.travelFrequency,
      this.currentCity,
      this.hometown,
      this.status,
      this.role,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.phoneVerificationCode,
      this.phoneVerified,
      this.isOnline,
      this.lastOnlineTime,
      this.agreedToTerms,
      this.googleId,
      this.facebookId,
      this.appleId,
      this.twoFactorAuthentication,
      this.preferredLanguage,
      this.images});

  Candidate.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    username = json['username'] ?? '';
    firstName = json['first_name'] ?? '';
    lastName = json['last_name'] ?? '';
    email = json['email'] ?? '';
    emailVerificationCode = json['email_verification_code'] ?? '';
    emailVerified = json['email_verified'] ?? 0;
    phone = json['phone'] ?? '';
    gender = json['gender'] ?? '';
    bio = json['bio'] ?? '';
    profilePictureUrl = json['profile_picture_url'] ?? '';
    dateOfBirth = json['date_of_birth'] ?? '';
    age = json['age'] ?? 0;
    height = json['height'] ?? '';
    bodyType = json['body_type'] ?? 0;
    maritalStatus = json['marital_status'] ?? 0;
    hasChildren = json['has_children'] ?? 0;
    wantsChildren = json['wants_children'] ?? 0;
    zodiacSign = json['zodiac_sign'] ?? 0;
    religion = json['religion'] ?? 0;
    politicalViews = json['political_views'] ?? '';
    education = json['education'] ?? 0;
    profession = json['profession'] ?? '';
    company = json['company'] ?? '';
    smokingHabits = json['smoking_habits'] ?? 0;
    drinkingHabits = json['drinking_habits'] ?? 0;
    exerciseFrequency = json['exercise_frequency'] ?? 0;
    dietType = json['diet_type'] ?? 0;
    travelFrequency = json['travel_frequency'] ?? 0;
    currentCity = json['current_city'] ?? '';
    hometown = json['hometown'] ?? 0;
    status = json['status'] ?? '';
    role = json['role'] ?? '';
    emailVerifiedAt = json['email_verified_at'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    deletedAt = json['deleted_at'] ?? '';
    phoneVerificationCode = json['phone_verification_code'] ?? '';
    phoneVerified = json['phone_verified'] ?? 0;
    isOnline = json['is_online'] ?? '';
    lastOnlineTime = json['last_online_time'] ?? '';
    agreedToTerms = json['agreed_to_terms'] ?? 0;
    googleId = json['google_id'] ?? '';
    facebookId = json['facebook_id'] ?? '';
    appleId = json['apple_id'] ?? '';
    twoFactorAuthentication = json['two_factor_authentication'] ?? 0;
    preferredLanguage = json['preferred_language'] ?? '';
    images = json['photos'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['email_verification_code'] = emailVerificationCode;
    data['email_verified'] = emailVerified;
    data['phone'] = phone;
    data['gender'] = gender;
    data['bio'] = bio;
    data['profile_picture_url'] = profilePictureUrl;
    data['date_of_birth'] = dateOfBirth;
    data['age'] = age;
    data['height'] = height;
    data['body_type'] = bodyType;
    data['marital_status'] = maritalStatus;
    data['has_children'] = hasChildren;
    data['wants_children'] = wantsChildren;
    data['zodiac_sign'] = zodiacSign;
    data['religion'] = religion;
    data['political_views'] = politicalViews;
    data['education'] = education;
    data['profession'] = profession;
    data['company'] = company;
    data['smoking_habits'] = smokingHabits;
    data['drinking_habits'] = drinkingHabits;
    data['exercise_frequency'] = exerciseFrequency;
    data['diet_type'] = dietType;
    data['travel_frequency'] = travelFrequency;
    data['current_city'] = currentCity;
    data['hometown'] = hometown;
    data['status'] = status;
    data['role'] = role;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['phone_verification_code'] = phoneVerificationCode;
    data['phone_verified'] = phoneVerified;
    data['is_online'] = isOnline;
    data['last_online_time'] = lastOnlineTime;
    data['agreed_to_terms'] = agreedToTerms;
    data['google_id'] = googleId;
    data['facebook_id'] = facebookId;
    data['apple_id'] = appleId;
    data['two_factor_authentication'] = twoFactorAuthentication;
    data['preferred_language'] = preferredLanguage;
    data['photos'] = images ?? [];

    return data;
  }
}
