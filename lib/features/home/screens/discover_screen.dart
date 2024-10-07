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
                  Text(
                    "Chicago, IL",
                    style: TextStyle(
                      color: CColors.secondary.withOpacity(.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
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
                        return ExampleCard(
                          user,
                          isSwiping: index == swipingCardIndex,
                          swipeDir: swipeDir,
                          currentImageIndex: currentImageIndex,
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

class ExampleCard extends StatefulWidget {
  final Candidate user;
  final bool isSwiping;
  final String swipeDir;
  final int currentImageIndex;
  final Function nextImage;
  final Function prevImage;

  const ExampleCard(
    this.user, {
    super.key,
    this.isSwiping = false,
    this.swipeDir = '',
    required this.currentImageIndex,
    required this.nextImage,
    required this.prevImage,
  });

  @override
  State<ExampleCard> createState() => _ExampleCardState();
}

class _ExampleCardState extends State<ExampleCard> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final username = user.username;
    final age = user.age;
    final distance = user.distance;
    final imgUrl = user.profilePictureUrl;
    final textDirection = Directionality.of(context);
    final isSwiping = widget.isSwiping;
    final swipeDir = widget.swipeDir;

    final userImages = user.images
            ?.map((imageObj) => imageObj['photo_url'] as String?)
            .where((photoUrl) => photoUrl != null && photoUrl.isNotEmpty)
            .toList() ??
        [];

    final allImages = [imgUrl, ...userImages];

    for (var imageUrl in allImages) {
      if (imageUrl != null && imageUrl.isNotEmpty) {
        precacheImage(NetworkImage(imageUrl), context);
      }
    }

    void handleTap(Offset localPosition) {
      final width = MediaQuery.of(context).size.width;

      if (localPosition.dx < width / 2) {
        widget.prevImage();
      } else {
        widget.nextImage();
      }
    }

    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        handleTap(details.localPosition);
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox.expand(
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    allImages[widget.currentImageIndex]!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // This will display if there's an error loading the image
                      return Image.network(
                        'https://i.pinimg.com/564x/ba/6f/57/ba6f5764aaa4e756d81ccb6a55fdc354.jpg',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Positioned(
                  top: 10,
                  left: 30,
                  right: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(allImages.length, (index) {
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: index == widget.currentImageIndex
                                ? CColors.primary
                                : const Color(0xFF7D8A88),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              if (isSwiping &&
                  swipeDir ==
                      (textDirection == TextDirection.ltr ? 'right' : 'left'))
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0x4DE31D35),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Transform.rotate(
                          angle: 0.3,
                          child: Container(
                              width: 78,
                              height: 78,
                              padding: const EdgeInsets.only(top: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/svg/favorite.svg',
                                  height: 36,
                                  colorFilter: ColorFilter.mode(
                                    CColors.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              if (isSwiping &&
                  swipeDir ==
                      (textDirection == TextDirection.ltr ? 'left' : 'right'))
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(77, 211, 127, 75),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Transform.rotate(
                            angle: -0.3,
                            child: Container(
                              width: 78,
                              height: 78,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/svg/cancel.svg',
                                  height: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                    color: Colors.black.withOpacity(0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "$username",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            ', ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$age",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/location.svg",
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '$distance km away',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
