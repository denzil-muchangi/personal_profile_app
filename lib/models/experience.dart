class Experience {
  String companyName;
  String position;
  String description;
  DateTime startDate;
  DateTime? endDate;
  String location;
  List<String> achievements;

  Experience({
    required this.companyName,
    required this.position,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.location,
    required this.achievements,
  });

  bool get isCurrentPosition => endDate == null;

  String get duration {
    final end = endDate ?? DateTime.now();
    final months = (end.difference(startDate).inDays / 30.4375).round();

    if (months < 12) {
      return '$months month${months == 1 ? '' : 's'}';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;

      if (remainingMonths == 0) {
        return '$years year${years == 1 ? '' : 's'}';
      } else {
        return '$years year${years == 1 ? '' : 's'} $remainingMonths month${remainingMonths == 1 ? '' : 's'}';
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'position': position,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'location': location,
      'achievements': achievements,
    };
  }

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      companyName: json['companyName'] ?? '',
      position: json['position'] ?? '',
      description: json['description'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      location: json['location'] ?? '',
      achievements: List<String>.from(json['achievements'] ?? []),
    );
  }

  Experience copyWith({
    String? companyName,
    String? position,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
    List<String>? achievements,
  }) {
    return Experience(
      companyName: companyName ?? this.companyName,
      position: position ?? this.position,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      achievements: achievements ?? this.achievements,
    );
  }
}