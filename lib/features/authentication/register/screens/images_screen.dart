import 'dart:io'; // To work with File images
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:swype/utils/helpers/helper_functions.dart';

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
                    child: images[0] != null
                        ? Image(
                            image: FileImage(File(images[0]!.path)),
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                ); // Show loading indicator while image is loading
                              }
                            },
                          )
                        : Image.asset(
                            'assets/images/blank.png',
                            fit: BoxFit.cover,
                          ),
                  ),
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
                            _pickImage(0); // Pick image for main container
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
                            child: images[imageIndex] != null
                                ? Image.file(
                                    File(images[imageIndex]!.path),
                                    fit: BoxFit.cover,
                                  )
                                : Center(
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  ),
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
                                _pickImage(index);
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
                                _pickImage(index);
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

  // Image picker function for picking images
  Future<void> _pickImage(int index) async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      images[index] = null;
    });

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? originalImage = img.decodeImage(imageBytes);

      if (originalImage != null) {
        int targetSizeInBytes = 2 * 1024 * 1024;
        int quality = 100;

        while (true) {
          List<int> compressedImageBytes =
              img.encodeJpg(originalImage, quality: quality);

          if (compressedImageBytes.length <= targetSizeInBytes ||
              quality <= 0) {
            await imageFile
                .writeAsBytes(Uint8List.fromList(compressedImageBytes));
            break;
          }
          quality -= 5;
        }

        setState(() {
          images[index] = XFile(imageFile.path);
        });
      }
    }
  }
}

// import 'dart:io'; // To work with File images
// import 'dart:typed_data'; // For image bytes
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart'; // For temporary file storage
// import 'package:swype/utils/constants/colors.dart';
// import 'package:swype/utils/helpers/helper_functions.dart';

// class MediaScreen extends ConsumerStatefulWidget {
//   const MediaScreen({super.key});

//   @override
//   _MediaScreenState createState() => _MediaScreenState();
// }

// class _MediaScreenState extends ConsumerState<MediaScreen>
//     with SingleTickerProviderStateMixin {
//   final List<XFile?> images = List.filled(7, null);
//   late AnimationController _controller;
//   int _repeatCount = 0;
//   final int _maxRepeatCount = 6;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );

//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _repeatCount++;
//         if (_repeatCount < _maxRepeatCount) {
//           _controller.reverse();
//         } else {
//           _controller.stop();
//         }
//       } else if (status == AnimationStatus.dismissed &&
//           _repeatCount < _maxRepeatCount) {
//         _controller.forward();
//       }
//     });
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final translations = CHelperFunctions().getTranslations(ref);
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 40),
//             Text(
//               translations['Media'] ?? "Media",
//               style: const TextStyle(
//                 fontSize: 34,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Stack(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(26),
//                     border: Border.all(
//                       color: Colors.white,
//                       width: 10,
//                     ),
//                   ),
//                   height: 170,
//                   width: 170,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(25),
//                     child: Image(
//                       key: UniqueKey(),
//                       image: images[0] != null
//                           ? FileImage(File(images[0]!.path))
//                           : const AssetImage('assets/images/blank.png')
//                               as ImageProvider,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: ScaleTransition(
//                     scale: Tween(begin: 1.0, end: 1.2).animate(
//                       CurvedAnimation(
//                         parent: _controller,
//                         curve: Curves.easeInOut,
//                       ),
//                     ),
//                     child: Container(
//                       width: 42,
//                       height: 42,
//                       decoration: BoxDecoration(
//                         color: CColors.primary,
//                         borderRadius: BorderRadius.circular(26),
//                         border: Border.all(
//                           color: Colors.white,
//                           width: 3,
//                         ),
//                       ),
//                       child: TextButton(
//                         onPressed: () {
//                           _pickImage(0);
//                         },
//                         style: TextButton.styleFrom(
//                           padding: EdgeInsets.zero,
//                           backgroundColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(26),
//                           ),
//                         ),
//                         child: SvgPicture.asset(
//                           'assets/svg/camera.svg',
//                           height: 19,
//                           width: 19,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   mainAxisSpacing: 10,
//                   crossAxisSpacing: 15,
//                 ),
//                 itemCount: images.length - 1,
//                 itemBuilder: (context, index) {
//                   final imageIndex = index + 1;

//                   return Stack(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(22),
//                             border: Border.all(
//                               color: Colors.grey,
//                               width: 2,
//                             ),
//                           ),
//                           height: 145,
//                           width: 200,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(20),
//                             child: images[imageIndex] != null
//                                 ? Image.file(
//                                     File(images[imageIndex]!.path),
//                                     fit: BoxFit.cover,
//                                   )
//                                 : Center(
//                                     child: Container(
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: Container(
//                           width: 35,
//                           height: 35,
//                           decoration: BoxDecoration(
//                             color: CColors.primary,
//                             borderRadius: BorderRadius.circular(26),
//                             border: Border.all(
//                               color: Colors.white,
//                               width: 3,
//                             ),
//                           ),
//                           child: TextButton(
//                             onPressed: () {
//                               _pickImage(imageIndex);
//                             },
//                             style: TextButton.styleFrom(
//                               padding: EdgeInsets.zero,
//                               backgroundColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(26),
//                               ),
//                             ),
//                             child: IconButton(
//                               padding: EdgeInsets.zero,
//                               icon: SvgPicture.asset(
//                                 images[imageIndex] == null
//                                     ? 'assets/svg/add.svg'
//                                     : 'assets/svg/pen.svg',
//                                 height: 20,
//                                 width: 20,
//                               ),
//                               onPressed: () {
//                                 _pickImage(imageIndex);
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (images[0] == null) {
//                     CHelperFunctions.showToaster(
//                       context,
//                       "Please select the Profile Picture!",
//                     );
//                   } else {
//                     Navigator.pop(context, images);
//                   }
//                 },
//                 child: const Text(
//                   'Save',
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20)
//           ],
//         ),
//       ),
//     );
//   }

//   // Future<void> _pickImage(int index) async {
//   //   print(index);
//   //   try {
//   //     final ImagePicker picker = ImagePicker();
//   //     final XFile? pickedImage =
//   //         await picker.pickImage(source: ImageSource.gallery);

//   //     if (pickedImage != null) {
//   //       final Uint8List imageBytes = await pickedImage.readAsBytes();

//   //       img.Image? image = img.decodeImage(imageBytes);
//   //       if (image != null) {
//   //         final compressedImage = img.copyResize(image, width: 800);
//   //         final compressedImageBytes = Uint8List.fromList(img.encodeJpg(
//   //           compressedImage,
//   //           quality: 85,
//   //         ));
//   //         final tempDir = await getTemporaryDirectory();
//   //         final filePath = '${tempDir.path}/compressed_image_$index.jpg';
//   //         File(filePath).writeAsBytesSync(compressedImageBytes);

//   //         setState(() {
//   //           images[index] = XFile(filePath);
//   //         });
//   //       }
//   //     }
//   //   } catch (e) {
//   //     CHelperFunctions.showToaster(
//   //       context,
//   //       "Failed to pick or compress the image.",
//   //     );
//   //   }
//   // }

//   Future<void> _pickImage(int index) async {
//     print("Selected image at index: $index");
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? pickedImage =
//           await picker.pickImage(source: ImageSource.gallery);

//       if (pickedImage != null) {
//         final Uint8List imageBytes = await pickedImage.readAsBytes();

//         // Decode the image
//         img.Image? image = img.decodeImage(imageBytes);
//         if (image != null) {
//           // Compress the image
//           final compressedImage = img.copyResize(image, width: 800);
//           final compressedImageBytes =
//               Uint8List.fromList(img.encodeJpg(compressedImage, quality: 85));

//           // Get temporary directory to save the compressed image
//           final tempDir = await getTemporaryDirectory();
//           final filePath = '${tempDir.path}/compressed_image_$index.jpg';

//           // Write the compressed image to the file
//           await File(filePath).writeAsBytes(compressedImageBytes);

//           // Update the state with the new image and assign a unique key
//           setState(() {
//             images[index] = XFile(filePath);
//           });
//         } else {
//           CHelperFunctions.showToaster(
//             context,
//             "Failed to decode the image.",
//           );
//         }
//       } else {
//         CHelperFunctions.showToaster(
//           context,
//           "No image selected.",
//         );
//       }
//     } catch (e) {
//       CHelperFunctions.showToaster(
//         context,
//         "Failed to pick or compress the image.",
//       );
//     }
//   }
// }
