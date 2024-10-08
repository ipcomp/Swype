import 'package:swype/features/chat/models/conversations.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';

class ChatController {
  DioClient dioClient = DioClient();

  Future<List<Conversations>> fecthConversations() async {
    try {
      final response = await dioClient.get(ApiRoutes.getConversations);
      final data = response.data;
      if (data['status_code'] == 200) {
        List<Conversations> conversations = (data['data'] as List)
            .map((item) => Conversations.fromJson(item))
            .toList();
        return conversations;
      } else {
        print(data['message']);
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
