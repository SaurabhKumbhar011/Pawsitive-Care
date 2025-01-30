import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerScreen extends StatefulWidget {
  final Function(LatLng) onLocationPicked;

  const LocationPickerScreen({Key? key, required this.onLocationPicked}) : super(key: key);

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _controller;
  LatLng _initialPosition = const LatLng(20.5937, 78.9629); // Default to India's coordinates
  LatLng? _pickedLocation;
  LatLng? _currentLocation; // Store current location

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch current location when the screen loads
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled');
      return;
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _initialPosition = _currentLocation!; // Update initial position to current location
    });
  }

  // Navigate to current location and place marker
  void _goToCurrentLocation() {
    if (_currentLocation != null && _controller != null) {
      _controller!.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
      setState(() {
        _pickedLocation = _currentLocation; // Place marker at the current location
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition, // Initially focused on current location
              zoom: 10.0, // Adjust zoom level
            ),
            onMapCreated: (controller) => _controller = controller,
            onTap: (LatLng location) {
              setState(() {
                _pickedLocation = location;
              });
            },
            markers: _pickedLocation != null
                ? {
              Marker(
                markerId: const MarkerId('pickedLocation'),
                position: _pickedLocation!,
              ),
            }
                : {},
          ),
          // Current location button
          if (_currentLocation != null)
            Positioned(
              top: 50,
              right: 20,
              child: FloatingActionButton(
                onPressed: _goToCurrentLocation, // Go to current location and place marker
                child: Icon(Icons.my_location),
                backgroundColor: Colors.blue,
              ),
            ),
          // Confirm location button
          if (_pickedLocation != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  widget.onLocationPicked(_pickedLocation!); // Send picked location back
                },
                child: const Text('Confirm Location'),
              ),
            ),
        ],
      ),
    );
  }
}