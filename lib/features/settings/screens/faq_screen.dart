import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/commons/widgets/custom_bottom_bar.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/loader_screen.dart';

class FaqScreen extends ConsumerStatefulWidget {
  const FaqScreen({super.key});

  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends ConsumerState<FaqScreen> {
  int _currentOpenIndex = -1;
  DioClient dioClient = DioClient();

  bool _isLoading = true; // For showing loader
  bool _hasError = false; // For error state
  String _errorMessage = ''; // Store error message

  List<Map<String, dynamic>> faqs = []; // List to hold FAQs fetched from API

  @override
  void initState() {
    super.initState();
    fetchFaqList(); // Fetch FAQ data when the screen is initialized
  }

  // Method to fetch FAQ list from the API
  Future<void> fetchFaqList() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Simulate API call (Replace this with your actual API call)
      final response = await dioClient.get(ApiRoutes.faqList);

      // Check if response is successful and has data
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status_code'] == 200) {
          setState(() {
            faqs = List<Map<String, dynamic>>.from(response.data['data']);
            _isLoading = false;
          });
        } else {
          throw Exception('Failed to load FAQ data');
        }
      } else {
        throw Exception('Failed to load FAQ data');
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage =
            'Unable to load FAQs. Please try again later.'; // More user-friendly error message
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "FAQ's",
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
                Navigator.pop(context);
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
      body: _buildBody(),
      bottomNavigationBar: customBottomBar(context, AppRoutes.settings, ref),
    );
  }

  // Build the body based on different states (loading, error, success, no data)
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: LoaderScreen(gifPath: 'assets/gif/loader.gif'),
      );
    }

    if (_hasError) {
      return Center(
        child: Text(
          _errorMessage,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.red,
          ),
        ),
      );
    }

    if (faqs.isEmpty) {
      return Center(
        child: Text(
          "No FAQs available at the moment.",
          style: TextStyle(fontSize: 18, color: CColors.borderColor),
        ),
      );
    }

    // Display the FAQ list
    return ListView.builder(
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: _currentOpenIndex == index
                ? const Color(0xFFFDECEE)
                : Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  faqs[index]['question'] ?? 'No question available',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: CColors.secondary,
                  ),
                ),
                trailing: Icon(
                  _currentOpenIndex == index
                      ? Icons.expand_less
                      : Icons.expand_more,
                  color: CColors.primary,
                ),
                onTap: () {
                  setState(() {
                    _currentOpenIndex = _currentOpenIndex == index ? -1 : index;
                  });
                },
              ),
              if (_currentOpenIndex == index)
                Container(
                  padding:
                      const EdgeInsets.only(right: 15, left: 15, bottom: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDECEE),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    faqs[index]['answer'] ?? 'No answer available',
                    style: TextStyle(
                      fontSize: 14,
                      color: CColors.textOpacity,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
