// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
//
// class LocationPickerScreen extends StatefulWidget {
//   final Function(LatLng) onLocationPicked;
//
//   const LocationPickerScreen({Key? key, required this.onLocationPicked}) : super(key: key);
//
//   @override
//   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// }
//
// class _LocationPickerScreenState extends State<LocationPickerScreen> {
//   GoogleMapController? _controller;
//   LatLng _initialPosition = const LatLng(20.5937, 78.9629); // Default to India's coordinates
//   LatLng? _pickedLocation;
//   LatLng? _currentLocation; // Store current location
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation(); // Fetch current location when the screen loads
//   }
//
//   // Get current location
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       print('Location services are disabled');
//       return;
//     }
//
//     // Check for location permission
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         print('Location permissions are denied');
//         return;
//       }
//     }
//
//     // Get current position
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//
//     setState(() {
//       _currentLocation = LatLng(position.latitude, position.longitude);
//       _initialPosition = _currentLocation!; // Update initial position to current location
//     });
//   }
//
//   // Navigate to current location and place marker
//   void _goToCurrentLocation() {
//     if (_currentLocation != null && _controller != null) {
//       _controller!.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
//       setState(() {
//         _pickedLocation = _currentLocation; // Place marker at the current location
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: _initialPosition, // Initially focused on current location
//               zoom: 10.0, // Adjust zoom level
//             ),
//             onMapCreated: (controller) => _controller = controller,
//             onTap: (LatLng location) {
//               setState(() {
//                 _pickedLocation = location;
//               });
//             },
//             markers: _pickedLocation != null
//                 ? {
//               Marker(
//                 markerId: const MarkerId('pickedLocation'),
//                 position: _pickedLocation!,
//               ),
//             }
//                 : {},
//           ),
//           // Current location button
//           if (_currentLocation != null)
//             Positioned(
//               top: 50,
//               right: 20,
//               child: FloatingActionButton(
//                 onPressed: _goToCurrentLocation, // Go to current location and place marker
//                 child: Icon(Icons.my_location),
//                 backgroundColor: Colors.blue,
//               ),
//             ),
//           // Confirm location button
//           if (_pickedLocation != null)
//             Positioned(
//               bottom: 20,
//               left: 20,
//               right: 20,
//               child: ElevatedButton(
//                 onPressed: () {
//                   widget.onLocationPicked(_pickedLocation!); // Send picked location back
//                 },
//                 child: const Text('Confirm Location'),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

//02/05
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationPickerScreen extends StatefulWidget {
  final Function(LatLng) onLocationPicked;

  const LocationPickerScreen({Key? key, required this.onLocationPicked}) : super(key: key);

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _controller;
  LatLng _initialPosition = const LatLng(20.5937, 78.9629); // Default to India
  LatLng? _pickedLocation;
  LatLng? _currentLocation;

  final Location _location = Location();
  bool _isMapInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locData = await _location.getLocation();
    setState(() {
      _currentLocation = LatLng(locData.latitude!, locData.longitude!);
      _initialPosition = _currentLocation!;
    });

    if (_controller != null && _isMapInitialized) {
      _controller!.animateCamera(CameraUpdate.newLatLngZoom(_initialPosition, 15));
    }
  }

  void _goToCurrentLocation() {
    if (_currentLocation != null && _controller != null) {
      _controller!.animateCamera(CameraUpdate.newLatLngZoom(_currentLocation!, 15));
      setState(() {
        _pickedLocation = _currentLocation;
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
              target: _initialPosition,
              zoom: 10.0,
            ),
            onMapCreated: (controller) {
              _controller = controller;
              _isMapInitialized = true;

              if (_currentLocation != null) {
                _controller!.animateCamera(CameraUpdate.newLatLngZoom(_currentLocation!, 15));
              }
            },
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
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          if (_currentLocation != null)
            Positioned(
              top: 50,
              right: 20,
              child: FloatingActionButton(
                onPressed: _goToCurrentLocation,
                backgroundColor: Colors.blue,
                child: const Icon(Icons.my_location),
              ),
            ),
          if (_pickedLocation != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  widget.onLocationPicked(_pickedLocation!);
                },
                child: const Text('Confirm Location'),
              ),
            ),
        ],
      ),
    );
  }
}
