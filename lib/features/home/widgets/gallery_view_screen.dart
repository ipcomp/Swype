import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/utils/constants/colors.dart';

class GalleryViewScreen extends ConsumerStatefulWidget {
  final List<dynamic> imageList;
  final int initialIndex;

  const GalleryViewScreen(
      {super.key, required this.imageList, this.initialIndex = 0});

  @override
  ConsumerState<GalleryViewScreen> createState() => _GalleryViewScreenState();
}

class _GalleryViewScreenState extends ConsumerState<GalleryViewScreen> {
  int currentIndex = 0;
  final CarouselSliderController carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 24, left: 40),
            child: AppBar(
              backgroundColor: Colors.white,
              leading: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: CColors.accent),
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: CColors.primary,
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                ),
              ),
              automaticallyImplyLeading: false,
            ),
          ),
          Expanded(
            child: CarouselSlider.builder(
              carouselController: carouselController,
              options: CarouselOptions(
                initialPage: currentIndex,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                viewportFraction: 1,
                height: double.maxFinite,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              itemCount: widget.imageList.length,
              itemBuilder: (context, index, realIdx) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.network(
                    widget.imageList[index]['photo_url'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 21),
          _buildThumbnailBar(), // Thumbnail bar at the bottom
          const SizedBox(height: 55),
        ],
      ),
    );
  }

  Widget _buildThumbnailBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 64,
        child: Row(
          children: List.generate(widget.imageList.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = index;
                });
                carouselController.jumpToPage(currentIndex);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: currentIndex == index ? 64 : 54,
                height: currentIndex == index ? 64 : 54,
                margin: const EdgeInsets.symmetric(horizontal: 11),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.imageList[index]['photo_url'],
                    fit: BoxFit.cover,
                    opacity: currentIndex == index
                        ? const AlwaysStoppedAnimation(1)
                        : const AlwaysStoppedAnimation(0.4),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
