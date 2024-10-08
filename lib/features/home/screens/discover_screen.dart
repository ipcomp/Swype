import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/commons/widgets/custom_bottom_bar.dart';
import 'package:swype/features/authentication/providers/all_users_provider.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/home/controllers/advanced_search_controller.dart';
import 'package:swype/features/home/data/user_model.dart';
import 'package:swype/features/home/widgets/filter_bottom_sheet.dart';
import 'package:swype/features/home/widgets/profile_bottom_sheet.dart';
import 'package:swype/features/home/widgets/user_card.dart';
import 'package:swype/features/matches/controllers/match_screen_controller.dart';
import 'package:swype/features/settings/providers/user_options_provider.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenPageState();
}

class _DiscoverScreenPageState extends ConsumerState<DiscoverScreen> {
  final CardSwiperController controller = CardSwiperController();
  final AdvancedSearchController advancedSearchController =
      AdvancedSearchController();
  final MatchScreenController matchScreenController = MatchScreenController();
  int swipingCardIndex = 0;
  String swipeDir = '';
  Map<String, dynamic> appliedFilters = {};
  bool isLoading = false;
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    ref.read(profileOptionsProvider.notifier).fetchProfileOptions();
  }

  void applyFilters(Map<String, dynamic> filters) async {
    print(filters);
    final response =
        await advancedSearchController.performAdvancedSearch(filters);
    print(response);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(allUsersProvider);
    final currentUser = ref.watch(userProvider);
    final allUser = ref
        .watch(allUsersProvider)
        ?.where((user) => user['id'] != currentUser?['id'])
        .toList();
    final translations = CHelperFunctions().getTranslations(ref);
    final textDirection = Directionality.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppBar(
              backgroundColor: Colors.white,
              leadingWidth: 52,
              leading: GestureDetector(
                onTap: () {
                  SystemNavigator.pop();
                },
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFE8E6EA),
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/svg/back_button.svg',
                  ),
                ),
              ),
              title: Column(
                children: [
                  Text(
                    translations['Discover'] ?? "Discover",
                    style: TextStyle(
                      color: CColors.secondary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   PageAnimationTransition(
                      //     page: UpdateLocationScreen(),
                      //     pageAnimationType: FadeAnimationTransition(),
                      //   ),
                      // );
                    },
                    child: Text(
                      currentUser?['current_city'] ?? "Update Location",
                      style: TextStyle(
                        color: CColors.secondary.withOpacity(.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (BuildContext context) {
                          return SizedBox(
                            width: double.infinity,
                            child: FilterBottomSheet(
                              onApplyFilter: applyFilters,
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 52,
                      width: 52,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFFE8E6EA),
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/svg/filter.svg',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: allUser == null || allUser.isEmpty
                  ? const Center(child: Text('No more users to display!'))
                  : CardSwiper(
                      controller: controller,
                      cardsCount: allUser.length,
                      allowedSwipeDirection:
                          const AllowedSwipeDirection.symmetric(
                        horizontal: true,
                      ),
                      numberOfCardsDisplayed: 1,
                      scale: 0.9,
                      maxAngle: 30,
                      isLoop: true,
                      backCardOffset: const Offset(0, -36),
                      padding: const EdgeInsets.all(20.0),
                      onSwipeDirectionChange:
                          (horizontalDirection, verticalDirection) => {
                        setState(() {
                          swipeDir = horizontalDirection.name;
                        })
                      },
                      onSwipe: (prevInx, currInx, dir) {
                        setState(() {
                          swipingCardIndex = currInx!;
                          currentImageIndex = 0;
                        });
                        return true;
                      },
                      cardBuilder: (
                        context,
                        index,
                        horizontalThresholdPercentage,
                        verticalThresholdPercentage,
                      ) {
                        final user = Candidate.fromJson(allUser[index]);
                        return Usercard(
                          user,
                          isSwiping: index == swipingCardIndex,
                          swipeDir: swipeDir,
                          currentImageIndex: currentImageIndex,
                          controller: controller,
                          swipingCardIndex: swipingCardIndex,
                          allUser: allUser,
                          nextImage: () {
                            setState(() {
                              if (currentImageIndex <
                                  (user.images!.length + 1) - 1) {
                                currentImageIndex++;
                              }
                            });
                          },
                          prevImage: () {
                            setState(() {
                              currentImageIndex = (currentImageIndex > 0)
                                  ? currentImageIndex - 1
                                  : 0;
                            });
                          },
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: SizedBox(
                height: 78,
                child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //  Dislike
                        GestureDetector(
                          onTap: () {
                            if (textDirection == TextDirection.rtl) {
                              setState(() {
                                swipeDir = "right";
                                currentImageIndex = 0;
                              });
                              controller.swipe(CardSwiperDirection.right);
                            } else {
                              setState(() {
                                swipeDir = "left";
                                currentImageIndex = 0;
                              });
                              controller.swipe(CardSwiperDirection.left);
                            }
                          },
                          child: Container(
                            height: 78,
                            width: 78,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  offset: const Offset(0, 3.5),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: SvgPicture.asset('assets/svg/cancel.svg'),
                          ),
                        ),
                        //  Like
                        GestureDetector(
                          onTap: () {
                            if (textDirection == TextDirection.ltr) {
                              setState(() {
                                swipeDir = "right";
                              });
                              controller.swipe(CardSwiperDirection.right);
                            } else {
                              setState(() {
                                swipeDir = "left";
                              });
                              controller.swipe(CardSwiperDirection.left);
                            }
                          },
                          child: Container(
                            height: 78,
                            width: 78,
                            padding: const EdgeInsets.only(
                              top: 22,
                              left: 18,
                              right: 18,
                              bottom: 17,
                            ),
                            decoration: BoxDecoration(
                              color: CColors.primary,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(233, 64, 87, 0.2),
                                  offset: Offset(0, 15),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              'assets/svg/favorite.svg',
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return ProfileBottomSheet(
                                  user: Candidate.fromJson(
                                    allUser![swipingCardIndex],
                                  ),
                                  controller: controller,
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 78,
                            width: 78,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  offset: const Offset(0, 3.5),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              'assets/svg/user.svg',
                              colorFilter: ColorFilter.mode(
                                CColors.borderColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: customBottomBar(context, AppRoutes.home, ref),
    );
  }
}
