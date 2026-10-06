import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  List<Marker> _markers = [];
  Map<String, dynamic>? _selectedParish;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      LocationPermission permission;

      // 1. Check and Request Permissions FIRST
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setFallbackPosition('Location permissions were denied.');
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        _setFallbackPosition('Location permissions are permanently denied in settings.');
        return;
      } 

      // 2. Check if Location Services (GPS) are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setFallbackPosition('Location services (GPS) are turned off. Please enable them in your device settings.');
        return;
      }

      // 3. Get the actual position
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15), // Don't hang forever
      );
      _currentPosition = LatLng(pos.latitude, pos.longitude);
      await _fetchLiveParishes(_currentPosition!);
    } catch (e) {
      debugPrint('Error in _determinePosition: $e');
      _setFallbackPosition('Could not fetch GPS location: $e');
    }
  }

  void _setFallbackPosition([String? reason]) async {
    if (reason != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(reason),
          backgroundColor: Colors.red.shade800,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    // Default fallback to Glenvista, Johannesburg
    _currentPosition = const LatLng(-26.276, 28.046);
    await _fetchLiveParishes(_currentPosition!);
  }
  
  /// Fetches real Catholic churches using Overpass API
  Future<void> _fetchLiveParishes(LatLng position) async {
    const String overpassUrl = 'https://overpass-api.de/api/interpreter';
    
    // QL Query for Catholic places of worship within a 5km radius
    final String query = '''
      [out:json];
      (
        node(around:5000, ${position.latitude}, ${position.longitude})["amenity"="place_of_worship"]["denomination"="catholic"];
        way(around:5000, ${position.latitude}, ${position.longitude})["amenity"="place_of_worship"]["denomination"="catholic"];
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
        
        List<Marker> newMarkers = [];
        List<Map<String, dynamic>> parishesList = [];

        for (var el in elements) {
          final double lat = el['type'] == 'node' ? el['lat'] : el['center']['lat'];
          final double lon = el['type'] == 'node' ? el['lon'] : el['center']['lon'];
          final tags = el['tags'] ?? {};
          
          final String name = tags['name'] ?? 'Catholic Church';
          
          // Build a readable address
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

          final double distanceMeters = const Distance().as(
            LengthUnit.Meter, 
            LatLng(position.latitude, position.longitude), 
            LatLng(lat, lon)
          );
          final String distanceKm = (distanceMeters / 1000).toStringAsFixed(1);
          final String id = el['id'].toString();

          final parishData = {
            'id': id,
            'name': name,
            'address': address,
            'distance': '$distanceKm km away',
            'distanceMeters': distanceMeters,
            'lat': lat,
            'lon': lon,
          };
          
          parishesList.add(parishData);

          newMarkers.add(
            Marker(
              point: LatLng(lat, lon),
              width: 50,
              height: 60,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedParish = parishData;
                  });
                  _mapController.move(LatLng(lat, lon), 15.0);
                },
                child: _buildPin(true, Icons.church),
              ),
            ),
          );
        }

        // Sort by distance
        parishesList.sort((a, b) => (a['distanceMeters'] as double).compareTo(b['distanceMeters'] as double));

        setState(() {
          _markers = newMarkers;
          if (parishesList.isNotEmpty) {
            _selectedParish = parishesList.first;
          }
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error fetching parishes: $e');
      setState(() => _isLoading = false);
    }
  }

  void _goToCurrentLocation() {
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, 14.5);
    }
  }

  void _zoom(double change) {
    _mapController.move(_mapController.camera.center, _mapController.camera.zoom + change);
  }

  Widget _buildPin(bool isSelected, IconData icon) {
    return Transform.translate(
      offset: const Offset(0, -20), // Lift the pin so bottom points to exact coordinate
      child: Transform.rotate(
        angle: -45 * 3.14159 / 180,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.green : AppColors.gold,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(8),
            ),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [BoxShadow(color: Color(0x38213627), blurRadius: 10, offset: Offset(5, 5))],
          ),
          child: Transform.rotate(
            angle: 45 * 3.14159 / 180,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.parchment,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.green),
              SizedBox(height: 16),
              Text(
                'Locating nearby parishes...',
                style: TextStyle(
                  color: AppColors.greenDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE7E5DD),
      body: Stack(
        children: [
          // The Free OpenStreetMap
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition ?? const LatLng(-26.276, 28.046),
                initialZoom: 13.5,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.parish_hub',
                ),
                MarkerLayer(
                  markers: [
                    // Plot all the Catholic Church markers
                    ..._markers,
                    
                    // Plot the User's Current Location Dot
                    if (_currentPosition != null)
                      Marker(
                        point: _currentPosition!,
                        width: 24,
                        height: 24,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
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
                                _selectedParish != null ? 'OPEN TODAY' : 'NO PARISHES FOUND',
                                style: const TextStyle(color: AppColors.greenDark, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.4),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _selectedParish?['name'] ?? 'Try adjusting map area',
                              style: const TextStyle(fontFamily: 'Newsreader', fontSize: 19, fontWeight: FontWeight.w600, color: AppColors.ink),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _selectedParish != null ? '${_selectedParish!['distance']} · ${_selectedParish!['address']}' : '',
                              style: const TextStyle(color: AppColors.muted, fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 9),
                            if (_selectedParish != null)
                              Row(
                                children: const [
                                  Icon(Icons.access_time, size: 14, color: AppColors.green),
                                  SizedBox(width: 4),
                                  Text(
                                    'Next Mass at 5:30 PM',
                                    style: TextStyle(color: AppColors.green, fontSize: 9, fontWeight: FontWeight.w700),
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
}
