// ignore_for_file: prefer_collection_literals, unnecessary_new, unnecessary_this, unnecessary_question_mark

class Conversations {
  int? senderId;
  dynamic? receiverId;
  int? conversationId;
  String? name;
  int? age;
  String? imagePath;
  LastMsg? lastMsg;
  String? isOnline;
  String? matchedAt;

  Conversations(
      {this.senderId,
      this.receiverId,
      this.conversationId,
      this.name,
      this.age,
      this.imagePath,
      this.lastMsg,
      this.isOnline,
      this.matchedAt});

  Conversations.fromJson(Map<String, dynamic> json) {
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    conversationId = json['conversation_id'];
    name = json['name'];
    age = json['age'];
    imagePath = json['imagePath'];
    lastMsg =
        json['lastMsg'] != null ? new LastMsg.fromJson(json['lastMsg']) : null;
    isOnline = json['isOnline'];
    matchedAt = json['matched_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['conversation_id'] = this.conversationId;
    data['name'] = this.name;
    data['age'] = this.age;
    data['imagePath'] = this.imagePath;
    if (this.lastMsg != null) {
      data['lastMsg'] = this.lastMsg!.toJson();
    }
    data['isOnline'] = this.isOnline;
    data['matched_at'] = this.matchedAt;
    return data;
  }
}

class LastMsg {
  int? id;
  int? conversationId;
  Null? matchId;
  int? senderId;
  int? receiverId;
  String? content;
  String? mediaUrl;
  Null? fileType;
  String? sentAt;
  int? isRead;
  String? createdAt;
  String? updatedAt;

  LastMsg(
      {this.id,
      this.conversationId,
      this.matchId,
      this.senderId,
      this.receiverId,
      this.content,
      this.mediaUrl,
      this.fileType,
      this.sentAt,
      this.isRead,
      this.createdAt,
      this.updatedAt});

  LastMsg.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conversationId = json['conversation_id'];
    matchId = json['match_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    content = json['content'];
    mediaUrl = json['media_url'];
    fileType = json['file_type'];
    sentAt = json['sent_at'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['conversation_id'] = this.conversationId;
    data['match_id'] = this.matchId;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['content'] = this.content;
    data['media_url'] = this.mediaUrl;
    data['file_type'] = this.fileType;
    data['sent_at'] = this.sentAt;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
