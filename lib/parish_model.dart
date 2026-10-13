class ParishModel {
  final String id;
  final String name;
  final String? diocese;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? province;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? email;
  final String? website;
  final String? parishPriestName;
  final List<String> activities;
  final String? imageUrl;
  final bool isActive;

  ParishModel({
    required this.id,
    required this.name,
    this.diocese,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.province,
    this.country,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.website,
    this.parishPriestName,
    this.activities = const [],
    this.imageUrl,
    this.isActive = true,
  });

  factory ParishModel.fromJson(Map<String, dynamic> json) {
    double? lat;
    double? lng;

    // Direct latitude and longitude numeric fields (from View or RPC)
    if (json['latitude'] != null) {
      lat = (json['latitude'] as num).toDouble();
    }
    if (json['longitude'] != null) {
      lng = (json['longitude'] as num).toDouble();
    }

    // PostGIS location field (GeoJSON map or coordinate map)
    if (lat == null && lng == null && json['location'] != null) {
      final loc = json['location'];
      if (loc is Map<String, dynamic>) {
        // GeoJSON standard: {"type": "Point", "coordinates": [longitude, latitude]}
        if (loc['coordinates'] is List && (loc['coordinates'] as List).length >= 2) {
          final coords = loc['coordinates'] as List;
          lng = (coords[0] as num).toDouble();
          lat = (coords[1] as num).toDouble();
        } else if (loc.containsKey('lat') && loc.containsKey('lng')) {
          lat = (loc['lat'] as num).toDouble();
          lng = (loc['lng'] as num).toDouble();
        } else if (loc.containsKey('latitude') && loc.containsKey('longitude')) {
          lat = (loc['latitude'] as num).toDouble();
          lng = (loc['longitude'] as num).toDouble();
        }
      }
    }

    // Safely parse Postgres text[] ARRAY
    List<String> activitiesList = [];
    if (json['activities'] != null && json['activities'] is List) {
      activitiesList = (json['activities'] as List).map((e) => e.toString()).toList();
    }

    return ParishModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      diocese: json['diocese']?.toString(),
      addressLine1: json['address_line1']?.toString(),
      addressLine2: json['address_line2']?.toString(),
      city: json['city']?.toString(),
      province: json['province']?.toString(),
      country: json['country']?.toString(),
      latitude: lat,
      longitude: lng,
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      website: json['website']?.toString(),
      parishPriestName: json['parish_priest_name']?.toString(),
      activities: activitiesList,
      imageUrl: json['image_url']?.toString(),
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'diocese': diocese,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'city': city,
      'province': province,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'website': website,
      'parish_priest_name': parishPriestName,
      'activities': activities,
      'image_url': imageUrl,
      'is_active': isActive,
    };
  }

  /// Formatted address string combining address lines, city, and province
  String get formattedAddress {
    final parts = [
      if (addressLine1 != null && addressLine1!.isNotEmpty) addressLine1,
      if (addressLine2 != null && addressLine2!.isNotEmpty) addressLine2,
      if (city != null && city!.isNotEmpty) city,
      if (province != null && province!.isNotEmpty) province,
    ];
    return parts.isEmpty ? 'No address available' : parts.join(', ');
  }
}