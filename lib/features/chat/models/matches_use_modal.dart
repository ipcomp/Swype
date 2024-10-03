class MatchesUserModal {
  List<Matches>? matches;

  MatchesUserModal({this.matches});

  MatchesUserModal.fromJson(Map<String, dynamic> json) {
    if (json['matches'] != null) {
      matches = <Matches>[];
      json['matches'].forEach((v) {
        matches!.add(Matches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (matches != null) {
      data['matches'] = matches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Matches {
  int? id;
  int? userId1;
  int? userId2;
  String? matchedAt;
  String? status;
  String? createdAt;
  String? updatedAt;
  MatchUser? matchUser;

  Matches(
      {this.id,
      this.userId1,
      this.userId2,
      this.matchedAt,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.matchUser});

  Matches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId1 = json['user_id_1'];
    userId2 = json['user_id_2'];
    matchedAt = json['matched_at'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    matchUser = json['match_user'] != null
        ? MatchUser.fromJson(json['match_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id_1'] = userId1;
    data['user_id_2'] = userId2;
    data['matched_at'] = matchedAt;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (matchUser != null) {
      data['match_user'] = matchUser!.toJson();
    }
    return data;
  }
}

class MatchUser {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? profilePictureUrl;
  String? bio;
  List<String>? publicPhotos;

  MatchUser(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.profilePictureUrl,
      this.bio,
      this.publicPhotos});

  MatchUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    profilePictureUrl = json['profile_picture_url'];
    bio = json['bio'];
    if (json['public_photos'] != null) {
      publicPhotos = List<String>.from(json['public_photos']);
    } else {
      publicPhotos = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['profile_picture_url'] = profilePictureUrl;
    data['bio'] = bio;
    if (publicPhotos != null) {
      data['public_photos'] = publicPhotos;
    }
    return data;
  }
}
