import 'package:flutter/material.dart';

class Achievement {
  String id;
  String title;
  String description;
  String issuer;
  DateTime dateEarned;
  String? credentialId;
  String? credentialUrl;
  String? badgeImagePath;
  AchievementType type;
  bool isVerified;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.issuer,
    required this.dateEarned,
    this.credentialId,
    this.credentialUrl,
    this.badgeImagePath,
    this.type = AchievementType.certification,
    this.isVerified = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'issuer': issuer,
      'dateEarned': dateEarned.toIso8601String(),
      'credentialId': credentialId,
      'credentialUrl': credentialUrl,
      'badgeImagePath': badgeImagePath,
      'type': type.index,
      'isVerified': isVerified,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      issuer: json['issuer'] ?? '',
      dateEarned: DateTime.parse(json['dateEarned'] ?? DateTime.now().toIso8601String()),
      credentialId: json['credentialId'],
      credentialUrl: json['credentialUrl'],
      badgeImagePath: json['badgeImagePath'],
      type: AchievementType.values[json['type'] ?? 0],
      isVerified: json['isVerified'] ?? false,
    );
  }

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? issuer,
    DateTime? dateEarned,
    String? credentialId,
    String? credentialUrl,
    String? badgeImagePath,
    AchievementType? type,
    bool? isVerified,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      issuer: issuer ?? this.issuer,
      dateEarned: dateEarned ?? this.dateEarned,
      credentialId: credentialId ?? this.credentialId,
      credentialUrl: credentialUrl ?? this.credentialUrl,
      badgeImagePath: badgeImagePath ?? this.badgeImagePath,
      type: type ?? this.type,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  String get formattedDate {
    return '${dateEarned.month}/${dateEarned.year}';
  }

  IconData get icon {
    switch (type) {
      case AchievementType.certification:
        return Icons.workspace_premium;
      case AchievementType.award:
        return Icons.emoji_events;
      case AchievementType.course:
        return Icons.school;
      case AchievementType.publication:
        return Icons.article;
      case AchievementType.patent:
        return Icons.lightbulb;
      case AchievementType.volunteering:
        return Icons.volunteer_activism;
      case AchievementType.speaking:
        return Icons.mic;
      case AchievementType.leadership:
        return Icons.people;
    }
  }

  Color get color {
    switch (type) {
      case AchievementType.certification:
        return Colors.blue;
      case AchievementType.award:
        return Colors.amber;
      case AchievementType.course:
        return Colors.green;
      case AchievementType.publication:
        return Colors.purple;
      case AchievementType.patent:
        return Colors.orange;
      case AchievementType.volunteering:
        return Colors.teal;
      case AchievementType.speaking:
        return Colors.indigo;
      case AchievementType.leadership:
        return Colors.deepPurple;
    }
  }
}

enum AchievementType {
  certification,
  award,
  course,
  publication,
  patent,
  volunteering,
  speaking,
  leadership,
}