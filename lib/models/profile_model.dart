class ProfileModel {
  final String id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String role;
  final String? assignedParishId;

  ProfileModel({
    required this.id,
    this.fullName,
    this.email,
    this.phone,
    this.role = 'regular_user',
    this.assignedParishId,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json, {Map<String, dynamic>? userMetadata}) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? userMetadata?['full_name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString() ?? userMetadata?['phone']?.toString(),
      role: json['role']?.toString() ?? 'regular_user',
      assignedParishId: json['assigned_parish_id']?.toString() ?? userMetadata?['assigned_parish_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'assigned_parish_id': assignedParishId,
    };
  }
}
