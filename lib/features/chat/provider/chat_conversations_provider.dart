import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/chat/models/conversations.dart';

class ConversationNotifier extends StateNotifier<List<Conversations>> {
  ConversationNotifier() : super([]);

  void loadConversations(List<Conversations> conversations) {
    state = conversations;
  }

  void addConversation(Conversations conversation) {
    state = [conversation, ...state];
  }

  void removeConversation(int id) {
    state = state
        .where((conversation) => conversation.conversationId != id)
        .toList();
  }

  void clearConversations() {
    state = [];
  }
}

final chatConversationProvider =
    StateNotifierProvider<ConversationNotifier, List<Conversations>>(
  (ref) => ConversationNotifier(),
);
