import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/helpers/loader_screen.dart';

class UpdateLocationScreen extends ConsumerStatefulWidget {
  @override
  _UpdateLocationScreenState createState() => _UpdateLocationScreenState();
}

class _UpdateLocationScreenState extends ConsumerState<UpdateLocationScreen> {
  final TextEditingController currentLocationController =
      TextEditingController();
  final TextEditingController newLocationController = TextEditingController();
  LatLng? newLocation;
  LatLng? currentLocation = LatLng(16.77, 32.55);
  GoogleMapController? mapController;
  List<String> suggestions = [];
  DioClient dioClient = DioClient();
  bool isLoading = false;
  String? cityName;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    final userData = ref.read(userProvider);
    print(userData?['current_city']);
    final longitude = userData?['longitude'];
    final latitude = userData?['latitude'];

    print(longitude);
    print(latitude);

    // _setMarker(latitude, longitude);

    // setState(() {
    //   currentLocation = LatLng(latitude, longitude);
    //   currentLocationController.text = userData?['current_city'];
    //   newLocationController.text = "";
    // });
  }

  Future<void> updateUserLocation() async {
    FocusScope.of(context).unfocus();
    if (newLocation == null) {
      print("No new location selected.");
      CHelperFunctions.showToaster(context, "No new location selected.");
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      FormData formData = FormData.fromMap({
        'latitude': newLocation!.latitude,
        'longitude': newLocation!.longitude,
        'current_city': cityName,
      });

      final response = await dioClient.postWithFormData(
        ApiRoutes.updateLoaction,
        formData,
      );
      final data = response.data;
      if (data['status_code'] == 200) {
        CHelperFunctions.showToaster(context, data['message']);
        final user = data['data']['user'];
        ref.read(userProvider.notifier).setUser(user);
        Navigator.pop(context);
      } else {
        print(data);
        CHelperFunctions.showToaster(context, data['message']);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getPlaceDetails(String placeId) async {
    try {
      final response = await Dio().get(
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=Google_API_KEY");

      if (response.statusCode == 200) {
        final data = response.data;
        final placeDetails = PlaceDetails.fromJson(data);
        setState(() {
          cityName = placeDetails.result?.name;
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching place details: $e");
    }
  }

  void _setMarker(double latitude, double longitude) {
    setState(() {
      markers.clear();
      mapController
          ?.animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
      markers.add(
        Marker(
          markerId: const MarkerId("newLocation"),
          position: LatLng(latitude, longitude),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final translations = CHelperFunctions().getTranslations(ref);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 75,
            title: Text(
              translations['Change Location'] ?? 'Change Location',
              style: TextStyle(
                color: CColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
            automaticallyImplyLeading: false,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  elevation: WidgetStateProperty.all(0),
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  shadowColor: WidgetStateProperty.all(Colors.transparent),
                ),
                child: Container(
                  height: 52,
                  width: 52,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFE8E6EA),
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/svg/back_right.svg',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: currentLocationController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Current Location',
                    suffixIcon: IconButton(
                      onPressed: () {
                        currentLocationController.clear();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Change to',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CColors.primary,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GooglePlaceAutoCompleteTextField(
                  textEditingController: newLocationController,
                  googleAPIKey: "Google_API_KEY",
                  debounceTime: 200,
                  language: "hebrew",
                  countries: const ["in", "il"],
                  isLatLngRequired: true,
                  inputDecoration: InputDecoration(
                      hintText: "Search your City",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            newLocationController.text = '';
                          });
                        },
                        icon: const Icon(Icons.clear),
                      )),
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    double latitude = double.tryParse(prediction.lat!) ?? 0.0;
                    double longitude = double.tryParse(prediction.lng!) ?? 0.0;
                    _setMarker(latitude, longitude);
                    getPlaceDetails(prediction.placeId!);
                    setState(() {
                      newLocation = LatLng(latitude, longitude);
                    });
                  },
                  itemClick: (Prediction prediction) {
                    FocusScope.of(context).unfocus();
                    newLocationController.text = prediction.description!;
                    newLocationController.selection =
                        TextSelection.fromPosition(
                      TextPosition(offset: prediction.description!.length),
                    );
                  },
                  itemBuilder: (context, index, Prediction prediction) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: CColors.borderColor,
                          )),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(
                            width: 7,
                          ),
                          Expanded(
                            child: Text(prediction.description ?? ""),
                          )
                        ],
                      ),
                    );
                  },
                  isCrossBtnShown: false,
                  containerHorizontalPadding: 0,
                  placeType: PlaceType.geocode,
                  boxDecoration: BoxDecoration(
                    border: Border.all(
                      width: 0,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: currentLocation!,
                      zoom: 14.0,
                    ),
                    markers: markers,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: updateUserLocation,
                    child: const Text("Update Address"),
                  ),
                ),
              ],
            ),
            if (isLoading) const LoaderScreen(gifPath: "assets/gif/loader.gif")
          ],
        ),
      ),
    );
  }
}
