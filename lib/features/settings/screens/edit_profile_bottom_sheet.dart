import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/commons/widgets/custom_drop_down.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/settings/providers/user_options_provider.dart';
import 'package:swype/utils/helpers/loader_screen.dart';

class EditProfileBottomSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> selectedOptions;
  final Function() onUpdate;
  final TextEditingController bioController;
  final TextEditingController heightController;
  final TextEditingController policalController;
  final TextEditingController professionController;
  final TextEditingController currentCityController;

  const EditProfileBottomSheet({
    super.key,
    required this.selectedOptions,
    required this.onUpdate,
    required this.bioController,
    required this.heightController,
    required this.policalController,
    required this.professionController,
    required this.currentCityController,
  });

  @override
  EditProfileBottomSheetState createState() => EditProfileBottomSheetState();
}

class EditProfileBottomSheetState
    extends ConsumerState<EditProfileBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final options = ref.watch(profileOptionsProvider);
    final user = ref.watch(userProvider);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 12),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Update Profile",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              child: TextFormField(
                                controller: widget.bioController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'Bio',
                                  floatingLabelBehavior: (user?['bio'] !=
                                              null &&
                                          user!['bio'].toString().isNotEmpty)
                                      ? FloatingLabelBehavior.always
                                      : FloatingLabelBehavior.auto,
                                  contentPadding: const EdgeInsets.all(20.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              child: TextFormField(
                                controller: widget.heightController,
                                decoration: InputDecoration(
                                  labelText: 'Height',
                                  floatingLabelBehavior: (user?['height'] !=
                                              null &&
                                          user!['height'].toString().isNotEmpty)
                                      ? FloatingLabelBehavior.always
                                      : FloatingLabelBehavior.auto,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              child: TextFormField(
                                controller: widget.policalController,
                                decoration: InputDecoration(
                                  labelText: 'Political Views',
                                  floatingLabelBehavior:
                                      (user?['political_views'] != null &&
                                              user!['political_views']
                                                  .toString()
                                                  .isNotEmpty)
                                          ? FloatingLabelBehavior.always
                                          : FloatingLabelBehavior.auto,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              child: TextFormField(
                                controller: widget.professionController,
                                decoration: InputDecoration(
                                  labelText: 'Profession',
                                  floatingLabelBehavior:
                                      (user?['profession'] != null &&
                                              user!['profession']
                                                  .toString()
                                                  .isNotEmpty)
                                          ? FloatingLabelBehavior.always
                                          : FloatingLabelBehavior.auto,
                                ),
                              ),
                            ),
                            ...options.entries.map((entry) {
                              if (entry.key == "pet_preference" ||
                                  entry.key == "relationship_goals") {
                                return const SizedBox.shrink();
                              }
                              return buildDropdownSection(
                                  entry.key, entry.value, user!);
                            }),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              child: TextFormField(
                                controller: widget.currentCityController,
                                decoration: InputDecoration(
                                  labelText: 'Current City',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: (user?['current_city'] != null &&
                                          user!['current_city']
                                              .toString()
                                              .isNotEmpty)
                                      ? user['current_city'].toString()
                                      : "Enter Current City",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    widget.onUpdate();
                                  },
                                  child: const Text('Submit'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Overlay for loader
            if (isLoading) const LoaderScreen(gifPath: 'assets/gif/loader.gif'),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownSection(String title, List<Map<String, dynamic>> items,
      Map<String, dynamic> user) {
    final selectedVal = user[title];
    final selectedItem = (selectedVal != null && selectedVal.isNotEmpty)
        ? items.firstWhere(
            (item) => item['name'] == selectedVal,
            orElse: () => <String, dynamic>{},
          )
        : null;

    // Update state to keep track of selectedId
    final selectedId = selectedItem != null && selectedItem.isNotEmpty
        ? selectedItem['id']
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: CustomDropdownBottomSheet(
        title: formatTitle(title),
        items: items,
        initialValueId: selectedId,
        onItemSelected: (int newSelectedId) {
          setState(() {
            widget.selectedOptions[title] =
                newSelectedId; // Update selectedOptions
          });
        },
      ),
    );
  }

  String formatTitle(String title) {
    return title
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }
}
