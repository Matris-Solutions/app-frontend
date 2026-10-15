class EventModel {
  final String id;
  final String parishId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime? endTime;
  final String? locationName;
  final String? locationAddress;

  EventModel({
    required this.id,
    required this.parishId,
    required this.title,
    this.description,
    required this.startTime,
    this.endTime,
    this.locationName,
    this.locationAddress,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id']?.toString() ?? '',
      parishId: json['parish_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      startTime: DateTime.tryParse(json['start_time']?.toString() ?? '') ?? DateTime.now(),
      endTime: json['end_time'] != null ? DateTime.tryParse(json['end_time'].toString()) : null,
      locationName: json['location_name']?.toString(),
      locationAddress: json['location_address']?.toString(),
    );
  }
}
