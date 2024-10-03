import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:swype/commons/widgets/custom_bottom_bar.dart';
import 'package:swype/features/settings/screens/events/event_detail_screen.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/helpers/loader_screen.dart';

class EventListScreen extends ConsumerStatefulWidget {
  const EventListScreen({super.key});

  @override
  ConsumerState<EventListScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventListScreen> {
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
        final data = response.data;
        if (data['status_code'] == 200) {
          setState(() {
            _events = data['data'];
            _isLoading = false;
          });
        } else {
          CHelperFunctions.showToaster(context, data['message']);
        }
      } else {
        CHelperFunctions.showToaster(context, response.statusMessage!);
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
          : _events.isEmpty
              ? const Center(
                  child: Text('No events available.'),
                )
              : ListView.builder(
                  // padding: const EdgeInsets.all(20.0),
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

  String formatDate(String dateString) {
    // Parse the date string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime object to the desired format
    String formattedDate = DateFormat('d MMM, yyyy').format(dateTime);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    print(event['event_date']);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageAnimationTransition(
            page: EventDetailScreen(eventId: event['id']),
            pageAnimationType: FadeAnimationTransition(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container
              Container(
                width: 157,
                height: 144,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: event['event_image'] != null &&
                          event['event_image'].isNotEmpty
                      ? Image.network(
                          event['event_image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey,
                              child: const Icon(Icons.error, color: Colors.red),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey,
                        ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['title'] ?? 'Event title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: CColors.secondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      event['description'] ?? 'Event description...',
                      // "Lorem Ipsum is simply dummy text of the prinLorem Ipsum is simply dummy text of the printing and typesetting industry.ting and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                      style: TextStyle(
                        fontSize: 10,
                        color: CColors.textOpacity,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 19),
                    Row(
                      // runSpacing: 5,
                      children: [
                        Image.asset('assets/icon/calendar_icon.png',
                            width: 12, height: 12, color: CColors.primary),
                        const SizedBox(width: 5),
                        Text(
                          event['event_date'] != null
                              ? formatDate(event['event_date'])
                              : '20 Oct, 2024',
                          style: TextStyle(
                            color: CColors.secondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icon/location_icon.png',
                          width: 12,
                          height: 12,
                          color: CColors.primary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          event['location'] ?? 'Jerusalem',
                          style: TextStyle(
                            color: CColors.secondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
