class PersonalInfo {
  String? profileImagePath;
  String fullName;
  String professionalTitle;
  String bio;
  String email;
  String phone;
  String location;
  DateTime? dateOfBirth;

  PersonalInfo({
    this.profileImagePath,
    required this.fullName,
    required this.professionalTitle,
    required this.bio,
    required this.email,
    required this.phone,
    required this.location,
    this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'profileImagePath': profileImagePath,
      'fullName': fullName,
      'professionalTitle': professionalTitle,
      'bio': bio,
      'email': email,
      'phone': phone,
      'location': location,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      profileImagePath: json['profileImagePath'],
      fullName: json['fullName'] ?? '',
      professionalTitle: json['professionalTitle'] ?? '',
      bio: json['bio'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
    );
  }

  PersonalInfo copyWith({
    String? profileImagePath,
    String? fullName,
    String? professionalTitle,
    String? bio,
    String? email,
    String? phone,
    String? location,
    DateTime? dateOfBirth,
  }) {
    return PersonalInfo(
      profileImagePath: profileImagePath ?? this.profileImagePath,
      fullName: fullName ?? this.fullName,
      professionalTitle: professionalTitle ?? this.professionalTitle,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}