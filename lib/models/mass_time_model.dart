class MassTimeModel {
  final String id;
  final String parishId;
  final int? dayOfWeek; // 0 = Sunday, 1 = Monday ... 6 = Saturday (or 1-7)
  final DateTime? specificDate;
  final String massTime; 
  final String language;
  final String massType; // Sunday, Saturday Vigil, Weekday, Holy Day, Special
  final String? notes;

  MassTimeModel({
    required this.id,
    required this.parishId,
    this.dayOfWeek,
    this.specificDate,
    required this.massTime,
    required this.language,
    required this.massType,
    this.notes,
  });

  factory MassTimeModel.fromJson(Map<String, dynamic> json) {
    int? dow;
    if (json['day_of_week'] != null) {
      dow = int.tryParse(json['day_of_week'].toString());
    }

    return MassTimeModel(
      id: json['id']?.toString() ?? '',
      parishId: json['parish_id']?.toString() ?? '',
      dayOfWeek: dow,
      specificDate: json['specific_date'] != null ? DateTime.tryParse(json['specific_date'].toString()) : null,
      massTime: json['mass_time']?.toString() ?? '',
      language: json['language']?.toString() ?? 'English',
      massType: json['mass_type']?.toString() ?? 'Sunday',
      notes: json['notes']?.toString(),
    );
  }

  String get dayName {
    if (dayOfWeek == null) {
      if (specificDate != null) {
        return '${specificDate!.month}/${specificDate!.day}/${specificDate!.year}';
      }
      return 'Special';
    }
    switch (dayOfWeek) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Day $dayOfWeek';
    }
  }

  String get displayType {
    final typeLower = massType.toLowerCase();
    if (typeLower == 'special') {
      return 'Special & Adoration';
    }
    if (typeLower == 'saturday vigil') {
      return 'Saturday Vigil';
    }
    return massType;
  }

  String get timeOnlyFormatted {
    try {
      final cleanTime = massTime.trim();
      final parts = cleanTime.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minutePart = parts[1].split('.')[0];
        final minute = int.parse(minutePart);
        
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
        final displayMinute = minute.toString().padLeft(2, '0');
        
        return '$displayHour:$displayMinute $period';
      }
    } catch (_) {}
    return massTime;
  }
  
  String get formattedTime {
    try {
      String timeStr = timeOnlyFormatted;
      
      if (language.isNotEmpty && language != 'English') {
        timeStr += ' ($language)';
      }
      if (notes != null && notes!.isNotEmpty) {
        timeStr += ' - $notes';
      }
      
      return timeStr;
    } catch (_) {}
    return massTime;
  }
}
