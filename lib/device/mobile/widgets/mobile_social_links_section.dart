import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/profile.dart';
import '../../../shared/utils/responsive_utils.dart';

class MobileSocialLinksSection extends StatelessWidget {
  final Profile profile;

  const MobileSocialLinksSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveUtils.getResponsiveMargin(context),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 6),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 1)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.link, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 20)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 8)),
              Text(
                'Connect',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),
          Wrap(
            spacing: ResponsiveUtils.getResponsiveIconSize(context, 12),
            children: profile.socialLinks.map((socialLink) {
              return IconButton(
                onPressed: () => _launchSocialUrl(socialLink.url),
                icon: Icon(
                  socialLink.icon,
                  color: socialLink.color,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                ),
                tooltip: socialLink.displayName,
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveIconSize(context, 8)),
                constraints: BoxConstraints(
                  minWidth: ResponsiveUtils.getResponsiveIconSize(context, 32),
                  minHeight: ResponsiveUtils.getResponsiveIconSize(context, 32),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _launchSocialUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error silently or log
    }
  }
}