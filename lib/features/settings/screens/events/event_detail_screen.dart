import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/commons/widgets/custom_bottom_bar.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/loader_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final int eventId; // Assume you pass the event ID from the event list
  const EventDetailScreen({super.key, required this.eventId});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  dynamic _event;
  bool _isLoading = true;
  DioClient dioClient = DioClient();

  @override
  void initState() {
    super.initState();
    _fetchEventDetails();
  }

  // Fetch event details by ID from the API
  Future<void> _fetchEventDetails() async {
    try {
      var response =
          await dioClient.get("${ApiRoutes.getEventById}?${widget.eventId}");

      if (response.statusCode == 200) {
        setState(() {
          _event = response.data;
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching event details: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Launch URL in a browser
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Events',
          style: TextStyle(
            color: CColors.secondary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              },
              child: Text(
                'Back',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: CColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: LoaderScreen(gifPath: 'assets/gif/loader.gif'),
            )
          : _event == null
              ? const Center(child: Text('Event details not available'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          _event['event_image'] ??
                              'https://via.placeholder.com/400x200',
                          height: 229,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _event['title'] ?? 'Event title',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(21, 33, 31, 1)),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Image.asset('assets/icon/location_icon.png',
                                      width: 12,
                                      height: 12,
                                      color: CColors.primary),
                                  const SizedBox(width: 5),
                                  Text(
                                    _event['date'] ?? '20 Oct, 2024',
                                    style: TextStyle(
                                        color: Color.fromRGBO(21, 33, 31, 1),
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset('assets/icon/calendar_icon.png',
                                  width: 12,
                                  height: 12,
                                  color: CColors.primary),
                              const SizedBox(width: 5),
                              Text(
                                _event['location'] ?? 'Jerusalem',
                                style: TextStyle(
                                    color: Color.fromRGBO(21, 33, 31, 1),
                                    fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _event['description'] ??
                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s...'
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s...'
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s...'
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s...'
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s...'
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s...',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: CColors.textOpacity,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_event['url'] != null &&
                          _event['url'].isNotEmpty) ...[
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => _launchURL(_event['url']),
                          child: Row(
                            children: [
                              const Icon(Icons.link, color: Colors.blue),
                              const SizedBox(width: 5),
                              Text(
                                'Event Website',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
      bottomNavigationBar: customBottomBar(context, AppRoutes.settings, ref),
    );
  }
}
