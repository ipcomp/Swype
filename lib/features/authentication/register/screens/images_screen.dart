import 'dart:io'; // To work with File images
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/helpers/loader_screen.dart';

class MediaScreen extends ConsumerStatefulWidget {
  const MediaScreen({super.key});

  @override
  _MediaScreenState createState() => _MediaScreenState();
}

class _MediaScreenState extends ConsumerState<MediaScreen>
    with SingleTickerProviderStateMixin {
  final List<XFile?> images = List.filled(7, null);
  List<bool> isLoading = List<bool>.filled(7, false);
  late AnimationController _controller;
  int _repeatCount = 0;
  final int _maxRepeatCount = 6;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _repeatCount++;
        if (_repeatCount < _maxRepeatCount) {
          _controller.reverse();
        } else {
          _controller.stop();
        }
      } else if (status == AnimationStatus.dismissed &&
          _repeatCount < _maxRepeatCount) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translations = CHelperFunctions().getTranslations(ref);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              translations['Media'] ?? "Media",
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: Colors.white,
                      width: 10,
                    ),
                  ),
                  height: 170,
                  width: 170,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: isLoading[0] == false
                          ? Image(
                              image: FileImage(File(
                                  images[0] == null ? '' : images[0]!.path)),
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                // Handle any error that occurs during loading
                                return Image.asset(
                                  'assets/images/blank.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : const LoaderScreen(
                              gifPath: "assets/gif/loader.gif",
                            )),
                ),
                // Camera Icon to Edit Main Image
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: ScaleTransition(
                      scale: Tween(begin: 1.0, end: 1.2).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: CColors.primary,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isLoading[0] = true;
                            });
                            _pickImage(0);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: SvgPicture.asset(
                            'assets/svg/camera.svg',
                            height: 19,
                            width: 19,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
            // Grid for Additional Media
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 15,
                ),
                itemCount: images.length - 1,
                itemBuilder: (context, index) {
                  final imageIndex = index + 1;

                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                          height: 145,
                          width: 200,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: isLoading[imageIndex] == false
                                  ? Image(
                                      image: FileImage(File(
                                          images[imageIndex] == null
                                              ? ''
                                              : images[imageIndex]!.path)),
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) {
                                        // Handle any error that occurs during loading
                                        return Center(
                                          child: Container(
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    )
                                  : const LoaderScreen(
                                      gifPath: "assets/gif/loader.gif",
                                    )

                              //  images[imageIndex] != null
                              //     ? Image.file(
                              //         File(images[imageIndex]!.path),
                              //         fit: BoxFit.cover,
                              //       )
                              //     : Center(
                              //         child: Container(
                              //           color: Colors.white,
                              //         ),
                              //       ),
                              ),
                        ),
                      ),
                      // Camera Icon to Edit Main Image
                      if (images[imageIndex] == null)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: CColors.primary,
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  isLoading[imageIndex] = true;
                                });
                                _pickImage(imageIndex);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: SvgPicture.asset(
                                  'assets/svg/add.svg',
                                  height: 20,
                                  width: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isLoading[imageIndex] = true;
                                  });
                                  _pickImage(imageIndex);
                                },
                              ),
                            ),
                          ),
                        ),
                      if (images[imageIndex] != null)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: CColors.primary,
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  isLoading[imageIndex] = true;
                                });
                                _pickImage(imageIndex);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: SvgPicture.asset(
                                  'assets/svg/pen.svg',
                                  height: 14,
                                  width: 14,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isLoading[imageIndex] = true;
                                  });
                                  _pickImage(imageIndex);
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (images[0] == null) {
                    CHelperFunctions.showToaster(
                      context,
                      "Please select the Profile Picture!",
                    );
                  } else {
                    Navigator.pop(context, images);
                  }
                },
                child: const Text(
                  'Save',
                ),
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      Uint8List imageBytes = await imageFile.readAsBytes();

      int targetSizeInBytes = 2 * 1024 * 1024; // 2 MB
      List<int>? compressedImageBytes;
      int quality = 85;

      // Determine the image format from the file extension
      String? extension = pickedImage.name.split('.').last.toLowerCase();
      CompressFormat? format;

      if (extension == 'png') {
        // Convert PNG to JPEG in memory
        compressedImageBytes = await convertPngToJpgInMemory(imageBytes);
        format = CompressFormat.jpeg; // Set format to JPEG
      } else if (extension == 'jpg' || extension == 'jpeg') {
        format = CompressFormat.jpeg;
        compressedImageBytes = imageBytes;
      } else {
        // Show SnackBar for unsupported formats
        setState(() {
          isLoading[index] = false;
        });
        CHelperFunctions.showToaster(
            context, 'Unsupported image format: $extension');

        return; // Exit the function early
      }

      // Compress the image if needed
      if (format == CompressFormat.jpeg) {
        do {
          compressedImageBytes = await FlutterImageCompress.compressWithList(
            compressedImageBytes as Uint8List,
            minWidth: 512, // Resize
            minHeight: 512,
            quality: quality,
            format: format,
          );
          quality -= 5; // Reduce quality iteratively
        } while (
            compressedImageBytes.length > targetSizeInBytes && quality > 0);
      }

      // Write the compressed image back to the file if compressed bytes are available
      if (compressedImageBytes != null) {
        await imageFile.writeAsBytes(compressedImageBytes);
      }

      setState(() {
        images[index] = XFile(imageFile.path);
        isLoading[index] = false;
      });
    } else {
      setState(() {
        isLoading[index] = false;
      });
    }
  }

  Future<List<int>> convertPngToJpgInMemory(Uint8List pngBytes) async {
    // Decode the PNG file to an image
    img.Image? image = img.decodePng(pngBytes);

    if (image == null) {
      throw Exception("Could not decode the PNG image");
    }

    // Encode the image as a JPEG
    List<int> jpgBytes =
        img.encodeJpg(image, quality: 90); // Set the quality if needed

    print('Conversion complete! JPG image in memory.');

    return jpgBytes;
  }
}
