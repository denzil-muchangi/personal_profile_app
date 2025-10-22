import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum SocialPlatform {
  github,
  linkedin,
  twitter,
  instagram,
  facebook,
  youtube,
  medium,
  website,
  email,
  phone,
  whatsapp,
  telegram,
  discord,
  stackoverflow,
  dribbble,
  behance,
  spotify,
  twitch,
  reddit,
  tiktok,
}

class SocialLink {
  String url;
  SocialPlatform platform;
  String? customName;

  SocialLink({
    required this.url,
    required this.platform,
    this.customName,
  });

  String get displayName {
    if (customName != null && customName!.isNotEmpty) {
      return customName!;
    }

    switch (platform) {
      case SocialPlatform.github:
        return 'GitHub';
      case SocialPlatform.linkedin:
        return 'LinkedIn';
      case SocialPlatform.twitter:
        return 'Twitter';
      case SocialPlatform.instagram:
        return 'Instagram';
      case SocialPlatform.facebook:
        return 'Facebook';
      case SocialPlatform.youtube:
        return 'YouTube';
      case SocialPlatform.medium:
        return 'Medium';
      case SocialPlatform.website:
        return 'Website';
      case SocialPlatform.email:
        return 'Email';
      case SocialPlatform.phone:
        return 'Phone';
      case SocialPlatform.whatsapp:
        return 'WhatsApp';
      case SocialPlatform.telegram:
        return 'Telegram';
      case SocialPlatform.discord:
        return 'Discord';
      case SocialPlatform.stackoverflow:
        return 'Stack Overflow';
      case SocialPlatform.dribbble:
        return 'Dribbble';
      case SocialPlatform.behance:
        return 'Behance';
      case SocialPlatform.spotify:
        return 'Spotify';
      case SocialPlatform.twitch:
        return 'Twitch';
      case SocialPlatform.reddit:
        return 'Reddit';
      case SocialPlatform.tiktok:
        return 'TikTok';
    }
  }

  IconData get icon {
    switch (platform) {
      case SocialPlatform.github:
        return FontAwesomeIcons.github;
      case SocialPlatform.linkedin:
        return FontAwesomeIcons.linkedin;
      case SocialPlatform.twitter:
        return FontAwesomeIcons.twitter;
      case SocialPlatform.instagram:
        return FontAwesomeIcons.instagram;
      case SocialPlatform.facebook:
        return FontAwesomeIcons.facebook;
      case SocialPlatform.youtube:
        return FontAwesomeIcons.youtube;
      case SocialPlatform.medium:
        return FontAwesomeIcons.medium;
      case SocialPlatform.website:
        return FontAwesomeIcons.globe;
      case SocialPlatform.email:
        return Icons.email;
      case SocialPlatform.phone:
        return Icons.phone;
      case SocialPlatform.whatsapp:
        return FontAwesomeIcons.whatsapp;
      case SocialPlatform.telegram:
        return FontAwesomeIcons.telegram;
      case SocialPlatform.discord:
        return FontAwesomeIcons.discord;
      case SocialPlatform.stackoverflow:
        return FontAwesomeIcons.stackOverflow;
      case SocialPlatform.dribbble:
        return FontAwesomeIcons.dribbble;
      case SocialPlatform.behance:
        return FontAwesomeIcons.behance;
      case SocialPlatform.spotify:
        return FontAwesomeIcons.spotify;
      case SocialPlatform.twitch:
        return FontAwesomeIcons.twitch;
      case SocialPlatform.reddit:
        return FontAwesomeIcons.reddit;
      case SocialPlatform.tiktok:
        return FontAwesomeIcons.tiktok;
    }
  }

  Color get color {
    switch (platform) {
      case SocialPlatform.github:
        return Colors.black;
      case SocialPlatform.linkedin:
        return Color(0xFF0077B5);
      case SocialPlatform.twitter:
        return Color(0xFF1DA1F2);
      case SocialPlatform.instagram:
        return Color(0xFFE4405F);
      case SocialPlatform.facebook:
        return Color(0xFF1877F2);
      case SocialPlatform.youtube:
        return Color(0xFFFF0000);
      case SocialPlatform.medium:
        return Colors.black;
      case SocialPlatform.website:
        return Colors.blue;
      case SocialPlatform.email:
        return Colors.red;
      case SocialPlatform.phone:
        return Colors.green;
      case SocialPlatform.whatsapp:
        return Color(0xFF25D366);
      case SocialPlatform.telegram:
        return Color(0xFF0088CC);
      case SocialPlatform.discord:
        return Color(0xFF5865F2);
      case SocialPlatform.stackoverflow:
        return Color(0xFFF48024);
      case SocialPlatform.dribbble:
        return Color(0xFFEA4C89);
      case SocialPlatform.behance:
        return Color(0xFF1769FF);
      case SocialPlatform.spotify:
        return Color(0xFF1DB954);
      case SocialPlatform.twitch:
        return Color(0xFF9146FF);
      case SocialPlatform.reddit:
        return Color(0xFFFF4500);
      case SocialPlatform.tiktok:
        return Colors.black;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'platform': platform.index,
      'customName': customName,
    };
  }

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      url: json['url'] ?? '',
      platform: SocialPlatform.values[json['platform'] ?? 0],
      customName: json['customName'],
    );
  }

  SocialLink copyWith({
    String? url,
    SocialPlatform? platform,
    String? customName,
  }) {
    return SocialLink(
      url: url ?? this.url,
      platform: platform ?? this.platform,
      customName: customName ?? this.customName,
    );
  }
}