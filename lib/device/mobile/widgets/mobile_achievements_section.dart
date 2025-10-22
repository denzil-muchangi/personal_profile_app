import 'package:flutter/material.dart';
import '../../../models/profile.dart';
import '../../../models/achievement.dart';
import '../../../shared/utils/responsive_utils.dart';

class MobileAchievementsSection extends StatelessWidget {
  final Profile profile;

  const MobileAchievementsSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    Widget _buildMobileAchievementPreviewCard(Achievement achievement) {
      return Container(
        margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveIconSize(context, 8)),
        padding: ResponsiveUtils.getResponsiveCardPadding(context),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 8)),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.getResponsiveIconSize(context, 6)),
              decoration: BoxDecoration(
                color: achievement.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 6)),
              ),
              child: Icon(
                achievement.icon,
                color: achievement.color,
                size: ResponsiveUtils.getResponsiveIconSize(context, 16),
              ),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                    ),
                  ),
                  Text(
                    achievement.issuer,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 10),
                    ),
                  ),
                ],
              ),
            ),
            if (achievement.isVerified)
              Icon(
                Icons.verified,
                color: Colors.green,
                size: ResponsiveUtils.getResponsiveIconSize(context, 14),
              ),
          ],
        ),
      );
    }

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
              Icon(Icons.workspace_premium, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 20)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 8)),
              Text(
                'Achievements & Certifications',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/achievements'),
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),
          Column(
            children: profile.achievements.take(2).map((achievement) {
              return _buildMobileAchievementPreviewCard(achievement);
            }).toList(),
          ),
        ],
      ),
    );
  }
}