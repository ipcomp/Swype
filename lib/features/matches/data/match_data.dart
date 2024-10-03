class MatchesData {
  List<SwipesReceived>? swipesReceived;
  List<Matches>? matches;

  MatchesData({this.swipesReceived, this.matches});

  MatchesData.fromJson(Map<String, dynamic> json) {
    if (json['swipes_received'] != null) {
      swipesReceived = <SwipesReceived>[];
      json['swipes_received'].forEach((v) {
        SwipesReceived swipe = SwipesReceived.fromJson(v);
        if (swipe.swiper != null) {
          swipesReceived!.add(swipe);
        }
      });
    }
    if (json['matches'] != null) {
      matches = <Matches>[];
      json['matches'].forEach((v) {
        Matches match = Matches.fromJson(v);
        if (match.matchUser != null) {
          matches!.add(match);
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (swipesReceived != null) {
      data['swipes_received'] = swipesReceived!.map((v) => v.toJson()).toList();
    }
    if (matches != null) {
      data['matches'] = matches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SwipesReceived {
  String? id;
  String? swiperId;
  String? swipedAt;
  Swiper? swiper;
  String? swipedId;
  String? swipeType;
  String? createdAt;
  String? updatedAt;

  SwipesReceived(
      {this.id,
      this.swiperId,
      this.swipedAt,
      this.swiper,
      this.swipedId,
      this.swipeType,
      this.createdAt,
      this.updatedAt});

  SwipesReceived.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    swiperId = json['swiper_id'];
    swipedAt = json['swiped_at'];
    swiper = json['swiper'] != null ? Swiper.fromJson(json['swiper']) : null;
    swipedId = json['swiped_id'];
    swipeType = json['swipe_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['swiper_id'] = swiperId;
    data['swiped_at'] = swipedAt;
    if (swiper != null) {
      data['swiper'] = swiper!.toJson();
    }
    data['swiped_id'] = swipedId;
    data['swipe_type'] = swipeType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Swiper {
  String? username;
  String? profilePictureUrl;
  int? age;
  String? isOnline;

  Swiper({this.username, this.profilePictureUrl, this.age, this.isOnline});

  Swiper.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    profilePictureUrl = json['profile_picture_url'];
    age = json['age'];
    isOnline = json['is_online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['profile_picture_url'] = profilePictureUrl;
    data['age'] = age;
    data['is_online'] = isOnline;
    return data;
  }
}

class Matches {
  String? id;
  String? userId1;
  String? matchedAt;
  MatchUser? matchUser;

  Matches({this.id, this.userId1, this.matchedAt, this.matchUser});

  Matches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId1 = json['user_id_1'];
    matchedAt = json['matched_at'];
    matchUser = json['match_user'] != null
        ? MatchUser.fromJson(json['match_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id_1'] = userId1;
    data['matched_at'] = matchedAt;
    if (matchUser != null) {
      data['match_user'] = matchUser!.toJson();
    }
    return data;
  }
}

class MatchUser {
  String? id;
  String? username;
  String? profilePictureUrl;
  int? age;
  String? isOnline;

  MatchUser(
      {this.id,
      this.username,
      this.profilePictureUrl,
      this.age,
      this.isOnline});

  MatchUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    profilePictureUrl = json['profile_picture_url'];
    age = json['age'];
    isOnline = json['is_online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['profile_picture_url'] = profilePictureUrl;
    data['age'] = age;
    data['is_online'] = isOnline;
    return data;
  }
}
