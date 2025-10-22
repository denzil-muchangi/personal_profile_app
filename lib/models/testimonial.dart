import 'package:flutter/material.dart';

class Testimonial {
  String id;
  String name;
  String position;
  String company;
  String message;
  String? photoPath;
  String? linkedInUrl;
  String? websiteUrl;
  DateTime dateGiven;
  int rating; // 1-5 stars
  bool isVerified;

  Testimonial({
    required this.id,
    required this.name,
    required this.position,
    required this.company,
    required this.message,
    this.photoPath,
    this.linkedInUrl,
    this.websiteUrl,
    required this.dateGiven,
    this.rating = 5,
    this.isVerified = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'company': company,
      'message': message,
      'photoPath': photoPath,
      'linkedInUrl': linkedInUrl,
      'websiteUrl': websiteUrl,
      'dateGiven': dateGiven.toIso8601String(),
      'rating': rating,
      'isVerified': isVerified,
    };
  }

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      position: json['position'] ?? '',
      company: json['company'] ?? '',
      message: json['message'] ?? '',
      photoPath: json['photoPath'],
      linkedInUrl: json['linkedInUrl'],
      websiteUrl: json['websiteUrl'],
      dateGiven: DateTime.parse(json['dateGiven'] ?? DateTime.now().toIso8601String()),
      rating: json['rating'] ?? 5,
      isVerified: json['isVerified'] ?? false,
    );
  }

  Testimonial copyWith({
    String? id,
    String? name,
    String? position,
    String? company,
    String? message,
    String? photoPath,
    String? linkedInUrl,
    String? websiteUrl,
    DateTime? dateGiven,
    int? rating,
    bool? isVerified,
  }) {
    return Testimonial(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      company: company ?? this.company,
      message: message ?? this.message,
      photoPath: photoPath ?? this.photoPath,
      linkedInUrl: linkedInUrl ?? this.linkedInUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      dateGiven: dateGiven ?? this.dateGiven,
      rating: rating ?? this.rating,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  String get formattedDate {
    return '${dateGiven.month}/${dateGiven.year}';
  }

  String get ratingText {
    return '★' * rating + '☆' * (5 - rating);
  }

  Color get ratingColor {
    if (rating >= 4) return Colors.green;
    if (rating >= 3) return Colors.orange;
    return Colors.red;
  }

  String get companyWithPosition {
    if (position.isNotEmpty && company.isNotEmpty) {
      return '$position at $company';
    } else if (position.isNotEmpty) {
      return position;
    } else if (company.isNotEmpty) {
      return company;
    }
    return '';
  }
}