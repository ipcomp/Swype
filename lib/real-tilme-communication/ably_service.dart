// import 'package:ably_flutter/ably_flutter.dart' as ably;
// import 'package:swype/routes/api_routes.dart';
// import 'package:swype/utils/dio/dio_client.dart';

// class AblyService {
//   ably.Realtime? ablyInstance;
//   DioClient dioClient = DioClient();

//   Future<String> fetchAblyApiKey() async {
//     try {
//       final response = await dioClient.get(ApiRoutes.appSettings);

//       if (response.statusCode == 200) {
//         final data = response.data;
//         if (data['status_code'] == 200) {
//           final ablyKey = data['data'][0]['value'];
//           return ablyKey;
//         } else {
//           throw Exception('Invalid status code: ${data['status_code']}');
//         }
//       } else {
//         throw Exception(
//             'Failed to load Ably API key, status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching Ably API key: $e');
//       throw e;
//     }
//   }

//   Future<void> initializeAbly(String username) async {
//     try {
//       final apiKey = await fetchAblyApiKey();
//       // Initialize Ably with clientId as username
//       ablyInstance = ably.Realtime(
//           options: ably.ClientOptions(key: apiKey, clientId: username));

//       // Wait for connection to be established
//       await ablyInstance?.connection.on(ably.ConnectionEvent.connected);

//       // Print client ID and available channels
//       print('Client ID: ${username}');
//       printAvailableChannels();
//     } catch (e) {
//       print('Error initializing Ably: $e');
//       throw e;
//     }
//   }

//   void printAvailableChannels() {
//     // Get all channels
//     var allChannels = ablyInstance?.channels;
//     var channel = ablyInstance?.channels.get("online-offline");
//     print(channel);

//     if (allChannels != null) {
//       print('Available channels: $allChannels');
//     } else {
//       print('No available channels found.');
//     }
//   }
// }
