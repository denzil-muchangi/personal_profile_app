import 'package:flutter/material.dart';
import '../../../models/profile.dart';
import '../../../models/experience.dart';
import '../../../shared/utils/responsive_utils.dart';

class MobileExperienceSection extends StatelessWidget {
  final Profile profile;

  const MobileExperienceSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    Widget _buildMobileExperienceCard(Experience experience) {
      return Container(
        margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveIconSize(context, 12)),
        padding: ResponsiveUtils.getResponsiveCardPadding(context),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 8)),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    experience.position,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                    ),
                  ),
                ),
                Text(
                  experience.duration,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 10),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 4)),
            Text(
              experience.companyName,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 8)),
            Text(
              experience.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
              ),
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
              Icon(Icons.work, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 20)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 8)),
              Text(
                'Experience',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),
          Column(
            children: profile.experiences.map((experience) {
              return _buildMobileExperienceCard(experience);
            }).toList(),
          ),
        ],
      ),
    );
  }
}