import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../liturgical_theme.dart';
import 'parish_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Position? _currentPosition;
  Set<Marker> _markers = {};
  Map<String, dynamic>? _selectedParish;
  
  // Default fallback location
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(40.7128, -74.0060),
    zoom: 13.0,
  );

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    
    if (permission == LocationPermission.deniedForever) return;

    _currentPosition = await Geolocator.getCurrentPosition();
    
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        zoom: 13.5,
      ),
    ));
    
    _fetchLiveParishes(_currentPosition!);
  }
  
  /// Fetches real Catholic churches using OpenStreetMap's Overpass API
  /// This is used because it's completely free and doesn't require an API Key!
  Future<void> _fetchLiveParishes(Position position) async {
    const String overpassUrl = 'https://overpass-api.de/api/interpreter';
    
    // Search for Catholic places of worship within roughly a 10-mile radius (16000 meters)
    final String query = '''
      [out:json];
      (
        node["amenity"="place_of_worship"]["denomination"="catholic"](around:16000,${position.latitude},${position.longitude});
        way["amenity"="place_of_worship"]["denomination"="catholic"](around:16000,${position.latitude},${position.longitude});
      );
      out center;
    ''';

    try {
      final response = await http.post(
        Uri.parse(overpassUrl),
        body: {'data': query},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List;
        
        Set<Marker> newMarkers = {};
        List<Map<String, dynamic>> parishesList = [];

        for (var el in elements) {
          final double lat = el['type'] == 'node' ? el['lat'] : el['center']['lat'];
          final double lon = el['type'] == 'node' ? el['lon'] : el['center']['lon'];
          final tags = el['tags'] ?? {};
          
          final String name = tags['name'] ?? 'Catholic Church';
          
          // Build a readable address from OSM tags
          String address = '';
          if (tags['addr:housenumber'] != null && tags['addr:street'] != null) {
            address = '${tags['addr:housenumber']} ${tags['addr:street']}';
            if (tags['addr:city'] != null) address += ', ${tags['addr:city']}';
          } else if (tags['addr:street'] != null) {
            address = tags['addr:street'];
          } else if (tags['addr:city'] != null) {
            address = tags['addr:city'];
          } else {
            address = 'Address not available';
          }

          final double distanceMeters = Geolocator.distanceBetween(position.latitude, position.longitude, lat, lon);
          final String distanceMiles = (distanceMeters / 1609.34).toStringAsFixed(1);
          final String id = el['id'].toString();

          final parishData = {
            'id': id,
            'name': name,
            'address': address,
            'distance': '$distanceMiles miles away',
            'distanceMeters': distanceMeters,
            'lat': lat,
            'lon': lon,
          };
          
          parishesList.add(parishData);

          newMarkers.add(
            Marker(
              markerId: MarkerId(id),
              position: LatLng(lat, lon),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              onTap: () async {
                setState(() {
                  _selectedParish = parishData;
                });
                
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lon)));
              },
            ),
          );
        }

        // Sort to find the closest parish
        parishesList.sort((a, b) => (a['distanceMeters'] as double).compareTo(b['distanceMeters'] as double));

        setState(() {
          _markers = newMarkers;
          if (parishesList.isNotEmpty && _selectedParish == null) {
            _selectedParish = parishesList.first; // Default to nearest
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching parishes: $e');
    }
  }

  Future<void> _goToCurrentLocation() async {
    if (_currentPosition == null) {
      await _determinePosition();
    } else {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 14.5,
        ),
      ));
    }
  }

  Future<void> _zoom(double change) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomBy(change));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7E5DD),
      body: Stack(
        children: [
          // The Google Map
          Positioned.fill(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),

          // Map Top (Search & Location)
          Positioned(
            top: 24 + MediaQuery.of(context).padding.top,
            left: 18,
            right: 18,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Color(0x14203527), blurRadius: 28, offset: Offset(0, 8))],
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search, size: 20, color: AppColors.muted),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search this area',
                              hintStyle: TextStyle(color: Color(0xFF909991), fontSize: 13),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _goToCurrentLocation,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Color(0x14203527), blurRadius: 28, offset: Offset(0, 8))],
                    ),
                    child: const Icon(Icons.navigation, color: AppColors.green, size: 20),
                  ),
                ),
              ],
            ),
          ),

          // Map Controls
          Positioned(
            right: 18,
            bottom: 305,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Color(0x14203527), blurRadius: 28, offset: Offset(0, 8))],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _zoom(1.0),
                    child: _buildMapControlButton(Icons.add),
                  ),
                  Container(height: 1, width: 40, color: AppColors.line),
                  GestureDetector(
                    onTap: () => _zoom(-1.0),
                    child: _buildMapControlButton(Icons.remove),
                  ),
                ],
              ),
            ),
          ),

          // Map Sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 9, 20, 105),
              decoration: const BoxDecoration(
                color: AppColors.parchment,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [BoxShadow(color: Color(0x1F223026), blurRadius: 30, offset: Offset(0, -8))],
              ),
              child: Column(
                children: [
                  Container(
                    width: 39,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(color: const Color(0xFFD4D3CE), borderRadius: BorderRadius.circular(4)),
                  ),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1624573830079-7fd9ce354be5?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080',
                          width: 93,
                          height: 94,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.greenPale,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                _selectedParish != null ? 'OPEN TODAY' : 'SEARCHING...',
                                style: const TextStyle(color: AppColors.greenDark, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.4),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _selectedParish?['name'] ?? 'Finding nearby parishes...',
                              style: const TextStyle(fontFamily: 'Newsreader', fontSize: 19, fontWeight: FontWeight.w600, color: AppColors.ink),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _selectedParish != null ? '${_selectedParish!['distance']} · ${_selectedParish!['address']}' : 'Please wait...',
                              style: const TextStyle(color: AppColors.muted, fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 9),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 14, color: AppColors.green),
                                const SizedBox(width: 4),
                                Text(
                                  _selectedParish != null ? 'Next Mass at 5:30 PM' : '',
                                  style: const TextStyle(color: AppColors.green, fontSize: 9, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: _selectedParish != null ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParishDetailScreen())) : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: _selectedParish != null ? AppColors.green : AppColors.muted.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('View parish', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                          SizedBox(width: 7),
                          Icon(Icons.chevron_right, size: 17, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControlButton(IconData icon) {
    return SizedBox(
      width: 40,
      height: 38,
      child: Icon(icon, size: 20, color: AppColors.ink),
    );
  }
}
