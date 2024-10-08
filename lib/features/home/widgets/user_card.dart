import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/features/home/data/user_model.dart';
import 'package:swype/features/home/widgets/profile_bottom_sheet.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:vibration/vibration.dart';

class Usercard extends ConsumerStatefulWidget {
  final Candidate user;
  final bool isSwiping;
  final String swipeDir;
  final int currentImageIndex;
  final Function nextImage;
  final Function prevImage;
  final CardSwiperController controller;
  final int swipingCardIndex;
  final allUser;

  const Usercard(
    this.user, {
    super.key,
    this.isSwiping = false,
    this.swipeDir = '',
    required this.currentImageIndex,
    required this.nextImage,
    required this.prevImage,
    required this.controller,
    required this.swipingCardIndex,
    required this.allUser,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UsercardState();
}

class _UsercardState extends ConsumerState<Usercard> {
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

    void handleTap(Offset localPosition) async {
      final width = MediaQuery.of(context).size.width;

      if (await Vibration.hasVibrator() != null) {
        Vibration.vibrate(duration: 50);
      }

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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      color: Colors.black.withOpacity(0.8),
                    ),
                    child: GestureDetector(
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
                                widget.allUser![widget.swipingCardIndex],
                              ),
                              controller: widget.controller,
                            );
                          },
                        );
                      },
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
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
