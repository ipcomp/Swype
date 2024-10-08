import 'dart:async';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AblyService {
  ably.Realtime? realtime;
  final WidgetRef ref;

  AblyService(this.ref);

  Future<void> initialize() async {
    realtime = ably.Realtime(
      key: "NywJkg.YSZnbg:sjB5yvU8_33NnURpi08Acfm9SJzlAdMFmQEbUHpQoeU",
    );
  }

  Future<void> subscribeToOnlineUsers() async {
    ably.RealtimeChannel channel = realtime!.channels.get('chat');
    channel.subscribe(name: "message").listen((ably.Message message) {
      if (message.data is Map) {
        final data = message.data as Map;
        print(data);
      } else {
        print('Unexpected data format: ${message.data}');
      }
    });
  }
}
