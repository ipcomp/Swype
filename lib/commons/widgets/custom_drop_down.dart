// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:swype/utils/constants/colors.dart';

// class CustomDropdownBottomSheet extends StatefulWidget {
//   final String title;
//   final List<Map<String, dynamic>>? items;
//   final int? initialValueId;
//   final Function(int) onItemSelected;
//   const CustomDropdownBottomSheet({
//     Key? key,
//     required this.title,
//     required this.items,
//     this.initialValueId, // Make this optional
//     required this.onItemSelected,
//   }) : super(key: key);

//   @override
//   _CustomDropdownBottomSheetState createState() =>
//       _CustomDropdownBottomSheetState();
// }

// class _CustomDropdownBottomSheetState extends State<CustomDropdownBottomSheet> {
//   late int? selectedValueId;

//   @override
//   void initState() {
//     super.initState();
//     selectedValueId = widget.initialValueId;
//   }

//   void _showBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       isDismissible: true,
//       enableDrag: true,
//       builder: (BuildContext context) {
//         TextEditingController searchController = TextEditingController();
//         List<Map<String, dynamic>> filteredItems = List.from(widget.items!);
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Container(
//               height: 600,
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: searchController,
//                     decoration: const InputDecoration(
//                       labelText: 'Search',
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         filteredItems = widget.items!
//                             .where((item) => item['name']
//                                 .toLowerCase()
//                                 .contains(value.toLowerCase()))
//                             .toList();
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: filteredItems.length,
//                       itemBuilder: (context, index) {
//                         final item = filteredItems[index];
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               selectedValueId = item['id'];
//                             });
//                             widget.onItemSelected(item['id']);
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(14),
//                               color: selectedValueId == item['id']
//                                   ? CColors.primary.withOpacity(0.1)
//                                   : Colors.transparent,
//                             ),
//                             padding: const EdgeInsets.all(12),
//                             child: Text(
//                               item['name'],
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 height: 1.5,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Find the name for the selected value based on the id, handle case for null
//     String selectedValueName = selectedValueId != null
//         ? widget.items!.firstWhere((item) => item['id'] == selectedValueId,
//             orElse: () => {'name': ''})['name']
//         : 'Select an item';

//     return GestureDetector(
//       onTap: () => _showBottomSheet(context),
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: widget.title,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               selectedValueName,
//               style: TextStyle(
//                 fontWeight: selectedValueId != null
//                     ? FontWeight.w700
//                     : FontWeight.normal,
//                 color: selectedValueId != null
//                     ? Colors.black
//                     : CColors.borderColor,
//                 fontSize: 18,
//               ),
//             ),
//             SvgPicture.asset(
//               'assets/svg/drop_down.svg',
//               height: 9,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class CustomDropdownBottomSheet extends ConsumerStatefulWidget {
  final String title;
  final List<Map<String, dynamic>>? items; // List of maps
  final int? initialValueId; // Optional initial selected id
  final Function(int) onItemSelected; // Callback function for selected id

  const CustomDropdownBottomSheet({
    Key? key,
    required this.title,
    required this.items,
    this.initialValueId, // Make this optional
    required this.onItemSelected,
  }) : super(key: key);

  @override
  _CustomDropdownBottomSheetState createState() =>
      _CustomDropdownBottomSheetState();
}

class _CustomDropdownBottomSheetState
    extends ConsumerState<CustomDropdownBottomSheet> {
  late int? selectedValueId;

  @override
  void initState() {
    super.initState();
    selectedValueId = widget.initialValueId;
  }

  void _showBottomSheet(BuildContext context) {
    final textDirection = Directionality.of(context);
    final translations = CHelperFunctions().getTranslations(ref);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext context) {
        TextEditingController searchController = TextEditingController();
        List<Map<String, dynamic>> filteredItems = List.from(widget.items!);
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 600,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: translations['Search'] ?? 'Search',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredItems = widget.items!.where((item) {
                          String itemName = (textDirection == TextDirection.rtl
                              ? (item['name_iw'] ?? 'NA')
                              : (item['name'] ?? 'NA'));

                          return itemName
                              .toLowerCase()
                              .contains(value.toLowerCase());
                        }).toList();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        String itemName = (textDirection == TextDirection.rtl
                            ? (item['name_iw'] ?? 'NA')
                            : (item['name'] ?? 'NA'));
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedValueId = item['id'];
                            });
                            widget.onItemSelected(item['id']);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: selectedValueId == item['id']
                                  ? CColors.primary.withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              itemName.isEmpty ? 'NA' : itemName,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Find the name for the selected value based on the id, handle case for null
    final translations = CHelperFunctions().getTranslations(ref);

    String selectedValueName =
        translations['Select an item'] ?? 'Select an item';

    if (selectedValueId != null) {
      Map<String, dynamic> foundItem = widget.items!.firstWhere(
        (item) => item['id'] == selectedValueId,
        orElse: () => {
          'name': '',
          'name_iw': '',
        },
      );

      if (Directionality.of(context) == TextDirection.rtl) {
        selectedValueName = foundItem['name_iw'] ?? 'NA';
      } else {
        selectedValueName = foundItem['name'] ?? 'NA';
      }
    }

    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.title,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedValueName.isEmpty
                  ? (translations['Select an item'] ?? 'Select an item')
                  : selectedValueName,
              style: TextStyle(
                fontWeight: selectedValueId != null
                    ? FontWeight.w700
                    : FontWeight.normal,
                color: selectedValueId != null
                    ? Colors.black
                    : CColors.borderColor,
                fontSize: 18,
              ),
            ),
            SvgPicture.asset(
              'assets/svg/drop_down.svg',
              height: 9,
            ),
          ],
        ),
      ),
    );
  }
}
