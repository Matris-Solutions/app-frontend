import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State createState() => _MapScreenState();
}

class _MapScreenState extends State {
  late GoogleMapController mapController;
  
  final LatLng _initialCenter = const LatLng(-26.2041, 28.0473); 

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parish Locator')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialCenter,
          zoom: 11.0,
        ),
        myLocationEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId('parish_1'),
            position: const LatLng(-26.1950, 28.0300),
            infoWindow: const InfoWindow(title: "Sacred Heart Church", snippet: 'Mass: Sun 9 AM'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              Theme.of(context).primaryColor == const Color(0xFF5E2D79) 
                  ? BitmapDescriptor.hueViolet 
                  : BitmapDescriptor.hueRed
            ),
          ),
        },
      ),
    );
  }
}