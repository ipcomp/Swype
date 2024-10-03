import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/utils/constants/colors.dart';

class CustomDropdownBottomSheetWithNames extends StatefulWidget {
  final String title;
  final List<String> items;
  final String initialValue;
  final Function(String) onItemSelected;

  const CustomDropdownBottomSheetWithNames({
    Key? key,
    required this.title,
    required this.items,
    required this.initialValue,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  _CustomDropdownBottomSheetState createState() =>
      _CustomDropdownBottomSheetState();
}

class _CustomDropdownBottomSheetState
    extends State<CustomDropdownBottomSheetWithNames> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  void _showBottomSheet(BuildContext context) {
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
        List<String> filteredItems = List.from(widget.items);
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 600,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredItems = widget.items
                            .where((item) => item
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedValue = item;
                              });
                              widget.onItemSelected(item);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: selectedValue == item
                                    ? CColors.primary.withOpacity(0.1)
                                    : Colors.transparent,
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
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
              selectedValue,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
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
