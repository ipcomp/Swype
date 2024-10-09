import 'dart:async';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/chat/models/conversations.dart';
import 'package:swype/features/chat/provider/chat_conversations_provider.dart';

class AblyService {
  ably.Realtime? realtime;
  final WidgetRef ref;

  AblyService(this.ref);

  Future<void> initialize() async {
    realtime = ably.Realtime(
      key: "ABLY_KEY",
    );
  }

  Future<void> publishNewMatch(String id) async {
    print(id);
    ably.RealtimeChannel matchChannel = realtime!.channels.get('match:$id');

    matchChannel.subscribe(name: "newMatch").listen((ably.Message message) {
      if (message.data is Map) {
        final data = message.data as Map;

        // Convert Map<Object?, Object?> to Map<String, dynamic>
        final userMap = <String, dynamic>{};
        data['user'].forEach((key, value) {
          if (key is String) {
            userMap[key] = value;
          } else {
            print('Key is not a String: $key');
          }
        });

        final conversation = Conversations.fromJson(userMap);
        ref
            .read(chatConversationProvider.notifier)
            .addConversation(conversation);
      } else {
        print('Unexpected data format: ${message.data}');
      }
    });
  }
}
