import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:swype/features/home/data/user_model.dart';
import 'package:flutter/material.dart';
import 'package:swype/features/home/widgets/gallery_view_screen.dart';
import 'package:swype/features/settings/providers/user_options_provider.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class ProfileBottomSheet extends ConsumerStatefulWidget {
  final Candidate user;
  final CardSwiperController controller;
  const ProfileBottomSheet(
      {super.key, required this.user, required this.controller});

  @override
  ConsumerState<ProfileBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends ConsumerState<ProfileBottomSheet> {
  bool isReadMore = false;

  void navigateToGalleryView({required int initialIndex}) {
    Navigator.of(context).push(
      PageAnimationTransition(
        page: GalleryViewScreen(
          imageList: widget.user.images!,
          initialIndex: initialIndex,
        ),
        pageAnimationType: FadeAnimationTransition(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final userOptions = ref.watch(profileOptionsProvider);
    final translations = CHelperFunctions().getTranslations(ref);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    widget.user.profilePictureUrl!.isEmpty
                        ? Image.asset(
                            'assets/images/user_icon.png',
                            height: 425,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            widget.user.profilePictureUrl ?? 'NA',
                            height: 425,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // This will display if there's an error loading the image
                              return Image.asset(
                                'assets/images/user_icon.png',
                                height: 425,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                    Container(
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                          bottom: Radius.circular(0),
                        ),
                      ),
                      width: double.infinity,
                      child: const SizedBox.shrink(),
                    ),
                  ],
                ),
                Positioned(
                  top: 50,
                  left: 40,
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white),
                      color: const Color(0xFFE8E6EA).withOpacity(0.5),
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        "assets/svg/back_button.svg",
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Navigate back
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 400,
                  child: Container(
                    height: 52,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white),
                      color: Colors.white,
                    ),
                    child: const SizedBox.shrink(),
                  ),
                ),
                Positioned(
                  top: 353,
                  child: SizedBox(
                    width: screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                widget.controller.swipe(
                                  CardSwiperDirection.left,
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
                                child:
                                    SvgPicture.asset('assets/svg/cancel.svg'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                widget.controller
                                    .swipe(CardSwiperDirection.right);
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
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            //Profile content Starts from here
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                  bottom: Radius.circular(0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.user.username}, ${widget.user.age}',
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                height: 1.5),
                          ),
                          Text(
                            widget.user.profession == null ||
                                    widget.user.profession!.isEmpty
                                ? 'Profession not added'
                                : widget.user.profession!,
                            style: const TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(21, 33, 31, 0.7)),
                          ),
                        ],
                      ),
                      Container(
                        height: 52,
                        width: 52,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: CColors.accent,
                            width: 1.0,
                          ),
                          color: Colors.white,
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/send.svg',
                          width: 52,
                          height: 52,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    translations['Location'] ?? 'Location',
                    style: TextStyle(
                      color: CColors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    // 'Jerusalem, Israel',
                    widget.user.currentCity == null ||
                            widget.user.currentCity!.isEmpty
                        ? 'No City'
                        : widget.user.currentCity!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(21, 33, 31, 0.7),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    translations['About'] ?? 'About',
                    style: TextStyle(
                      color: CColors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.user.bio == null || widget.user.bio!.isEmpty
                        ? 'No About'
                        : widget.user.bio!,
                    maxLines: !isReadMore ? 3 : 10,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(21, 33, 31, 0.7),
                    ),
                  ),
                  ...[
                    if (widget.user.bio != null && widget.user.bio!.isNotEmpty)
                      const SizedBox(height: 5),
                    if (widget.user.bio != null && widget.user.bio!.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isReadMore = !isReadMore;
                          });
                        },
                        child: Text(
                          isReadMore ? 'Read less' : 'Read more',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        translations['Gallery'] ?? 'Gallery',
                        style: TextStyle(
                          color: CColors.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                      if (widget.user.images != null &&
                          widget.user.images!.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            navigateToGalleryView(initialIndex: 0);
                          },
                          child: const Text(
                            'See All',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                            ),
                          ),
                        )
                    ],
                  ),
                  const SizedBox(height: 5),
                  buildImages(
                      widget.user.images!
                      // [
                      //   'assets/images/onboarding3.png',
                      //   'assets/images/onboarding1.png',
                      //   'assets/images/onboarding2.png',
                      //   'assets/images/onboarding1.png',
                      //   'assets/images/onboarding3.png',
                      // ]
                      ,
                      navigateToGalleryView),
                  const SizedBox(height: 30),
                  Text(
                    translations['Other Details'] ?? 'Other Details',
                    style: TextStyle(
                      color: CColors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 17),
                  _buildOtherDetails(widget.user, userOptions),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildOtherDetails(
    Candidate user, Map<String, List<Map<String, dynamic>>> userOptions) {
  String education =
      userOptions['education']?[user.education ?? 0]['name'].toString() ?? 'NA';
  String bodyType =
      userOptions['body_type']?[user.bodyType ?? 0]['name'].toString() ?? 'NA';
  String maritalStatus = userOptions['marital_status']?[user.maritalStatus ?? 0]
              ['name']
          .toString() ??
      'NA';
  String smokingHabits = userOptions['smoking_habits']?[user.smokingHabits ?? 0]
              ['name']
          .toString() ??
      'NA';
  String drinkingHabits =
      userOptions['drinking_habits']?[user.bodyType ?? 0]['name'].toString() ??
          'NA';
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDetailRow('Education', education.isNotEmpty ? education : 'NA'),
      const SizedBox(height: 10),
      _buildDetailRow('Body Type', bodyType.isNotEmpty ? bodyType : 'NA'),
      const SizedBox(height: 10),
      _buildDetailRow(
          'Marital Status', maritalStatus.isNotEmpty ? maritalStatus : 'NA'),
      const SizedBox(height: 10),
      _buildDetailRow(
          'Smoking Habits', smokingHabits.isNotEmpty ? smokingHabits : 'NA'),
      const SizedBox(height: 10),
      _buildDetailRow(
          'Drinking Habits', drinkingHabits.isNotEmpty ? drinkingHabits : 'NA'),
    ],
  );
}

Widget _buildDetailRow(String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          '$title:',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ),
      Expanded(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromRGBO(21, 33, 31, .70),
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
      )
    ],
  );
}

Widget buildImages(List<dynamic> images, navigateToGalleryView) {
  if (images.isEmpty) {
    return const Text("Images Not Added!",
        style: TextStyle(
          fontSize: 14,
          color: Color.fromRGBO(21, 33, 31, 0.7),
        ));
  }

  if (images.length <= 4) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            navigateToGalleryView(initialIndex: index);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              images[index]['photo_url'],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  } else {
    return

        /*Column(
      children: [
        Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                navigateToGalleryView(initialIndex: 0);
              },
              child: Expanded(
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      images[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                navigateToGalleryView(initialIndex: 1);
              },
              child: Expanded(
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      images[1],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                navigateToGalleryView(initialIndex: 2);
              },
              child: Expanded(
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      images[2],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                navigateToGalleryView(initialIndex: 3);
              },
              child: Expanded(
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      images[3],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                navigateToGalleryView(initialIndex: 4);
              },
              child: Expanded(
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      images[4],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  
  */

        Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: GestureDetector(
                onTap: () {
                  navigateToGalleryView(initialIndex: 0);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    images[0]['photo_url'],
                    fit: BoxFit.cover,
                    width: 143,
                    height: 190,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  navigateToGalleryView(initialIndex: 1);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    images[1]['photo_url'],
                    fit: BoxFit.cover,
                    width: 143,
                    height: 190,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: GestureDetector(
                onTap: () {
                  navigateToGalleryView(initialIndex: 2);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(images[2]['photo_url'],
                      fit: BoxFit.cover, width: 91, height: 122),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  navigateToGalleryView(initialIndex: 3);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(images[3]['photo_url'],
                      fit: BoxFit.cover, width: 91, height: 122),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  navigateToGalleryView(initialIndex: 4);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(images[4]['photo_url'],
                      fit: BoxFit.cover, width: 91, height: 122),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
