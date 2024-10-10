import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/commons/widgets/custom_bottom_bar.dart';
import 'package:swype/features/matches/controllers/match_screen_controller.dart';
import 'package:swype/features/matches/models/matches_modal.dart';
import 'package:swype/features/matches/provider/matches_provider.dart';
import 'package:swype/features/matches/widgets/grid_view.dart';
import 'package:swype/features/matches/widgets/list_view.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/helpers/loader_screen.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
  MatchScreenController matchScreenController = MatchScreenController();

  bool isGridView = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final matchesUser = ref.watch(matchesProvider);
    final translations = CHelperFunctions().getTranslations(ref);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, d) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            translations["Matches"] ?? 'Matches',
            style: TextStyle(
              fontSize: 24,
              color: CColors.secondary,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isGridView = !isGridView;
                });
              },
              child: Container(
                height: 52,
                width: 52,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: CColors.accent,
                  ),
                ),
                child: SvgPicture.asset(
                  isGridView
                      ? 'assets/svg/list_view.svg'
                      : 'assets/svg/grid_view.svg',
                  colorFilter:
                      ColorFilter.mode(CColors.primary, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
        body: isLoading
            ? const LoaderScreen(gifPath: "assets/gif/loader.gif")
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isGridView)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        translations[
                                'This is a list of people who have liked you and your matches.'] ??
                            "This is a list of people who have liked you and your matches.",
                        style: TextStyle(
                          color: CColors.textOpacity,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ),
                  Expanded(
                    child: isGridView
                        ? buildGridView(matchesUser.mergedItems,
                            (liked, userId, user) {
                            onTapOfMatchCard(liked, userId, user);
                          }, isLoading)
                        : buildListView(matchesUser.mergedItems,
                            (liked, userId, user) {
                            onTapOfMatchCard(liked, userId, user);
                          }, isLoading),
                  ),
                ],
              ),
        bottomNavigationBar: customBottomBar(context, AppRoutes.matches, ref),
      ),
    );
  }

  void onTapOfMatchCard(String liked, int userId, MatchModalItem user) async {
    setState(() {
      isLoading = true;
    });

    FormData formData = FormData();

    print('user id = $userId');

    formData.fields.add(MapEntry('to_user_id', userId.toString()));
    formData.fields.add(MapEntry('liked', liked));

    await matchScreenController.swipeUser(context, ref, formData, user);

    setState(() {
      isLoading = false;
    });
  }
}
