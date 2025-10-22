class Education {
  String institutionName;
  String degree;
  String fieldOfStudy;
  DateTime startDate;
  DateTime? endDate;
  String location;
  double? gpa;
  List<String> achievements;
  String? description;

  Education({
    required this.institutionName,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    this.endDate,
    required this.location,
    this.gpa,
    required this.achievements,
    this.description,
  });

  bool get isCurrentlyStudying => endDate == null;

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

  String get degreeWithField {
    return '$degree in $fieldOfStudy';
  }

  Map<String, dynamic> toJson() {
    return {
      'institutionName': institutionName,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'location': location,
      'gpa': gpa,
      'achievements': achievements,
      'description': description,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      institutionName: json['institutionName'] ?? '',
      degree: json['degree'] ?? '',
      fieldOfStudy: json['fieldOfStudy'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      location: json['location'] ?? '',
      gpa: json['gpa']?.toDouble(),
      achievements: List<String>.from(json['achievements'] ?? []),
      description: json['description'],
    );
  }

  Education copyWith({
    String? institutionName,
    String? degree,
    String? fieldOfStudy,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
    double? gpa,
    List<String>? achievements,
    String? description,
  }) {
    return Education(
      institutionName: institutionName ?? this.institutionName,
      degree: degree ?? this.degree,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      gpa: gpa ?? this.gpa,
      achievements: achievements ?? this.achievements,
      description: description ?? this.description,
    );
  }
}