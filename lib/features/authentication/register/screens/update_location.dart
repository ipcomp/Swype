import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:swype/features/authentication/providers/register_provider.dart';
import 'package:swype/features/authentication/providers/user_provider.dart';
import 'package:swype/features/authentication/register/screens/user_preferences.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/dio/dio_client.dart';
import 'package:swype/utils/helpers/helper_functions.dart';
import 'package:swype/utils/helpers/loader_screen.dart';

class UpdateLocationScreen extends ConsumerStatefulWidget {
  const UpdateLocationScreen({super.key});

  @override
  _UpdateLocationScreenState createState() => _UpdateLocationScreenState();
}

class _UpdateLocationScreenState extends ConsumerState<UpdateLocationScreen> {
  final TextEditingController currentLocationController =
      TextEditingController();

  LatLng? currentLocation;
  GoogleMapController? mapController;
  List<String> suggestions = [];
  DioClient dioClient = DioClient();
  bool isLoading = true;
  Set<Marker> markers = {};
  String? cityName;

  @override
  void initState() {
    super.initState();
    currentLocationController.text = "Fetching your location...";
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          CHelperFunctions.showToaster(
            context,
            "Location services are disabled.",
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            CHelperFunctions.showToaster(
              context,
              "Location permissions are denied.",
            );
          }
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
      ));
      String city =
          placemarks.isNotEmpty ? placemarks.first.locality ?? '' : '';

      if (mounted) {
        setState(() {
          currentLocation = LatLng(position.latitude, position.longitude);
          currentLocationController.text = city;
          cityName = city;
          if (mapController != null) {
            mapController!.moveCamera(CameraUpdate.newLatLng(currentLocation!));
          }
          setState(() {
            isLoading = false;
          });
        });
      }
    } catch (e) {
      print("Error getting current location: $e");
      if (mounted) {
        CHelperFunctions.showToaster(
            context, "Failed to get current location.");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> updateUserLocation() async {
    if (currentLocation == null) {
      print("No new location selected.");
      CHelperFunctions.showToaster(context, "No new location selected.");
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      FormData formData = FormData.fromMap({
        'latitude': currentLocation!.latitude,
        'longitude': currentLocation!.longitude,
        'current_city': cityName,
      });

      final response = await dioClient.postWithFormData(
        ApiRoutes.updateLoaction,
        formData,
      );
      final data = response.data;
      if (data['status_code'] == 200) {
        CHelperFunctions.showToaster(context, data['message']);
        final userData = data['data']['user'];
        ref.read(registerProvider.notifier).updateIsLocationUpdated(true);
        ref.read(userProvider.notifier).setUser(userData);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const UserPreferences(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        print(data);
        CHelperFunctions.showToaster(context, data['message']);
      }
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
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyC6JQ3AaJopbIxj3e8ELKXHHEWCs4gEYqI");

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
              translations['Your Location'] ?? 'Your Location',
              style: TextStyle(
                color: CColors.secondary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                GooglePlaceAutoCompleteTextField(
                  textEditingController: currentLocationController,
                  googleAPIKey: "AIzaSyC6JQ3AaJopbIxj3e8ELKXHHEWCs4gEYqI",
                  debounceTime: 200,
                  language: "hebrew",
                  countries: const ["in", "il"],
                  isLatLngRequired: true,
                  inputDecoration: InputDecoration(
                      hintText: "Search your City",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            currentLocationController.text = '';
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
                      currentLocation = LatLng(latitude, longitude);
                    });
                  },
                  itemClick: (Prediction prediction) {
                    currentLocationController.text = prediction.description!;
                    currentLocationController.selection =
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
                const SizedBox(height: 24),
                Expanded(
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(31.7683, 35.2137),
                      zoom: 10.0,
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
                const SizedBox(height: 20),
              ],
            ),
            if (isLoading)
              const SizedBox(
                child: LoaderScreen(gifPath: 'assets/gif/loader.gif'),
              ),
          ],
        ),
      ),
    );
  }
}
