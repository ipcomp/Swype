import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swype/commons/widgets/custom_bottom_bar.dart';
import 'package:swype/commons/widgets/match_avatar_widget.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class QuestionAnswerScreen extends ConsumerStatefulWidget {
  const QuestionAnswerScreen({super.key});

  @override
  ConsumerState<QuestionAnswerScreen> createState() =>
      _QuestionAnswerScreenState();
}

class _QuestionAnswerScreenState extends ConsumerState<QuestionAnswerScreen> {
  @override
  Widget build(BuildContext context) {
    final translations = CHelperFunctions().getTranslations(ref);
    final textDirection = Directionality.of(context);

    return Scaffold(
      appBar: appbar(textDirection, translations),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),

          // Create a Question Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ButtonStyle(
                    padding: WidgetStateProperty.all(const EdgeInsets.only(
                        top: 10, right: 99, bottom: 14, left: 98)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ))),
                onPressed: () =>
                    {_showCreateQuestionDialog(context, translations)},
                child: Text(
                  translations['Create A Questions'] ?? "Create A Question",
                  style: const TextStyle(
                      height: 1.5, fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
                child: Text(
              "Or",
              style: TextStyle(
                  height: 1.5,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: CColors.primary),
            )),
          ),
          const SizedBox(height: 5),
          // List of Questions
          Expanded(
            child: ListView(
              children: [
                _buildQuestionCard(
                  context,
                  'How do you spend your spare time?',
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of typesetting industry.',
                  ['Abigail Cohen', 'Elizabeth Cohen'],
                ),
                _buildQuestionCard(
                  context,
                  'How do you spend your spare time?',
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of typesetting industry.',
                  ['Abigail Cohen', 'Elizabeth Cohen'],
                ),
                // Add more question cards
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          customBottomBar(context, AppRoutes.questionAnswer, ref),
    );
  }

  PreferredSizeWidget appbar(
      TextDirection textDirection, Map<String, String> translations) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        translations["Question/Answer"] ?? "Question/Answer",
        style: TextStyle(
          color: CColors.secondary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
      ),
      automaticallyImplyLeading: false,
      titleSpacing: 20,
      actions: [
        Padding(
          padding: textDirection == TextDirection.rtl
              ? const EdgeInsets.only(left: 20.0)
              : const EdgeInsets.only(right: 20.0),
          child: Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: CColors.accent),
              color: Colors.white,
            ),
            child: IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: CColors.primary,
                size: 24,
              ),
              onPressed: () {
                Navigator.pop(context); // Navigate back
              },
            ),
          ),
        ),
      ],
    );
  }

  // Helper function to build the question card widget
  Widget _buildQuestionCard(BuildContext context, String question,
      String description, List<String> responses) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 0),
              blurRadius: 10,
            ),
          ],
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 15.0, top: 23, left: 15, right: 19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            questionCardTopSection(question, description),
            const SizedBox(height: 10),

            Divider(
              color: CColors.borderColor,
            ),
            // List of responses
            for (var response in responses)
              Column(
                children: [
                  questionCardBottomSection(response),
                  const SizedBox(height: 10)
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget questionCardTopSection(String question, String description) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        matchAvatar('', true, false, 27, 27,
            onlineDotHeight: 5.304,
            onlineDotWidth: 5.304,
            onlineDotRight: 0,
            onlineDotTop: 3,
            doShowInsidePadding: false,
            insidePadding: 0.5),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              questionText(question),
              const SizedBox(height: 5),
              descriptionText(description),
              const SizedBox(height: 10),
              // Like & Answer buttons
              reactionButtons()
            ],
          ),
        ),
      ],
    );
  }

  Widget questionText(String question) {
    return Text(question,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.5,
            color: CColors.secondary));
  }

  Widget descriptionText(String description) {
    return Text(description,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: CColors.textOpacity));
  }

  Widget reactionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () {
            // Handle like action
          },
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              visualDensity: const VisualDensity(
                horizontal: -2,
                vertical: -2,
              ),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)))),
          iconAlignment: IconAlignment.end,
          icon: SvgPicture.asset('assets/svg/like_icon.svg'),
          label: Text('Like',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: CColors.textOpacity)),
        ),
        const SizedBox(width: 21),
        TextButton.icon(
          iconAlignment: IconAlignment.end,
          onPressed: () {
            // Handle answer action
          },
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              visualDensity: const VisualDensity(
                horizontal: -2,
                vertical: -2,
              ),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)))),
          icon: SvgPicture.asset('assets/svg/answer_icon.svg'),
          label: Text(
            'Answer',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: CColors.textOpacity),
          ),
        ),
      ],
    );
  }

  Widget questionCardBottomSection(String response) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        matchAvatar('', true, false, 27, 27,
            onlineDotHeight: 5.304,
            onlineDotWidth: 5.304,
            onlineDotRight: 0,
            onlineDotTop: 3,
            doShowInsidePadding: false,
            insidePadding: 0.5),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              questionText(response),
              const SizedBox(height: 5),
              descriptionText(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
            ],
          ),
        ),
      ],
    );
  }

  // Show dialog to create a question
  void _showCreateQuestionDialog(
      BuildContext context, Map<String, String> translations) {
    final TextEditingController questionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 17, horizontal: 11),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: CColors.secondary),
                // cursorColor: CColors.primary,
                decoration: InputDecoration(
                    hintText: "Type your Question",
                    contentPadding:
                        const EdgeInsets.only(top: 10, bottom: 14, left: 16),
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: CColors.borderColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: CColors.borderColor, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: CColors.borderColor, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: CColors.borderColor, width: 1),
                        borderRadius: BorderRadius.circular(5))),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.only(top: 10, bottom: 14)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ))),
                  onPressed: () {
                    if (questionController.text.isNotEmpty) {
                      // Send the question to API
                      _submitQuestion(context, questionController.text);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    translations['Submit'] ?? "Submit",
                    style: const TextStyle(
                        height: 1.5, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Submit the question to the backend API
  Future<void> _submitQuestion(BuildContext context, String question) async {
    // Assuming you use Dio client for network requests
    /* try {
      final response = await DioClient().postWithFormData(
        ApiRoutes.createOrUpdateQuestion,
         {'question': question},
      );
      if (response.statusCode == 200) {
        // Handle successful response
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Question submitted successfully.')));
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit question.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('An error occurred.')));
  }*/
  }
}
