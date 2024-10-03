import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/commons/widgets/custom_bottom_bar.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/dio/dio_client.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  List<dynamic> _events = [];
  bool _isLoading = true;
  DioClient dioClient = DioClient();

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  // Function to fetch events from the API
  Future<void> _fetchEvents() async {
    try {
      var response = await dioClient.get(ApiRoutes.getAllEvents);
      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          _events = response.data;
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching events: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _events.isEmpty
              ? const Center(
                  child: Text('No events available.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20.0),
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                    final event = _events[index];
                    return EventCard(event: event);
                  },
                ),
      bottomNavigationBar: customBottomBar(context, AppRoutes.settings, ref),
    );
  }
}

class EventCard extends StatelessWidget {
  final dynamic event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              event['image_url'] ?? 'https://via.placeholder.com/400x200',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'] ?? 'Event title',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  event['description'] ?? 'Event description...',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      event['date'] ?? '20 Oct, 2024',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 15),
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      event['location'] ?? 'Jerusalem',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
