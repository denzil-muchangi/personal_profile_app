class Project {
  String name;
  String description;
  String? imagePath;
  String? projectUrl;
  String? githubUrl;
  String? playStoreUrl;
  String? appStoreUrl;
  List<String> technologies;
  List<String> images;
  DateTime createdAt;
  bool isFeatured;

  Project({
    required this.name,
    required this.description,
    this.imagePath,
    this.projectUrl,
    this.githubUrl,
    this.playStoreUrl,
    this.appStoreUrl,
    required this.technologies,
    required this.images,
    required this.createdAt,
    this.isFeatured = false,
  });

  String get technologiesString => technologies.join(' • ');

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'projectUrl': projectUrl,
      'githubUrl': githubUrl,
      'playStoreUrl': playStoreUrl,
      'appStoreUrl': appStoreUrl,
      'technologies': technologies,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
      'isFeatured': isFeatured,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['imagePath'],
      projectUrl: json['projectUrl'],
      githubUrl: json['githubUrl'],
      playStoreUrl: json['playStoreUrl'],
      appStoreUrl: json['appStoreUrl'],
      technologies: List<String>.from(json['technologies'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Project copyWith({
    String? name,
    String? description,
    String? imagePath,
    String? projectUrl,
    String? githubUrl,
    String? playStoreUrl,
    String? appStoreUrl,
    List<String>? technologies,
    List<String>? images,
    DateTime? createdAt,
    bool? isFeatured,
  }) {
    return Project(
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      projectUrl: projectUrl ?? this.projectUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      playStoreUrl: playStoreUrl ?? this.playStoreUrl,
      appStoreUrl: appStoreUrl ?? this.appStoreUrl,
      technologies: technologies ?? this.technologies,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}