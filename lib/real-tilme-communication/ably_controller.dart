import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/real-tilme-communication/ably_service.dart';

class AblyController {
  late AblyService ablyService;

  AblyController(WidgetRef ref) {
    ablyService = AblyService(ref);
  }

  void swipeChannelInit(String id) async {
    ablyService.publishNewMatch(id);
  }
}
