import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class UpdateLocation extends StatefulWidget {
  @override
  _ChangeLocationScreenState createState() => _ChangeLocationScreenState();
}

class _ChangeLocationScreenState extends State<UpdateLocation> {
  final TextEditingController currentLocationController =
      TextEditingController();
  final TextEditingController newLocationController = TextEditingController();
  LatLng? newLocation;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    // Set a default current location (this could be user's current location fetched via GPS)
    currentLocationController.text = "75 Sokolov Nachum, Jerusalem, Israel";
    newLocationController.text = "9 Maagal Hashalom, Rishon Lezion, Israel";
  }

  // Function to update the location by geocoding the address
  Future<void> updateAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        setState(() {
          newLocation = LatLng(loc.latitude, loc.longitude);
          mapController?.moveCamera(
            CameraUpdate.newLatLng(newLocation!),
          );
        });
      }
    } catch (e) {
      print("Error in geocoding: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to fetch location for the address."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Location'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Current Location
            TextFormField(
              controller: currentLocationController,
              readOnly: true, // Current location is static
              decoration: InputDecoration(
                labelText: 'Current Location',
                suffixIcon: IconButton(
                  onPressed: () => currentLocationController.clear(),
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Change to',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // New Location TextField
            TextFormField(
              controller: newLocationController,
              decoration: InputDecoration(
                labelText: 'New Location',
                suffixIcon: IconButton(
                  onPressed: () {
                    updateAddress(newLocationController.text);
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Google Map Display
            Expanded(
              child: GoogleMap(
                onMapCreated: (controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(31.7683, 35.2137), // Default to Jerusalem
                  zoom: 14.0,
                ),
                markers: newLocation != null
                    ? {
                        Marker(
                          markerId: const MarkerId('newLocation'),
                          position: newLocation!,
                        )
                      }
                    : {},
              ),
            ),
            const SizedBox(height: 20),
            // Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle address update logic here
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Address updated to: ${newLocationController.text}"),
                  ));
                },
                child: const Text('Update the Address'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
