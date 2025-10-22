import 'package:flutter/material.dart';
import '../../../models/profile.dart';
import '../../../models/education.dart';
import '../../../shared/utils/responsive_utils.dart';

class MobileEducationSection extends StatelessWidget {
  final Profile profile;

  const MobileEducationSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    Widget _buildMobileEducationCard(Education education) {
      return Container(
        padding: ResponsiveUtils.getResponsiveCardPadding(context),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 8)),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              education.degreeWithField,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 4)),
            Text(
              education.institutionName,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 4)),
            Text(
              education.duration,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 10),
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
              Icon(Icons.school, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 20)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 8)),
              Text(
                'Education',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),
          _buildMobileEducationCard(profile.education[0]),
        ],
      ),
    );
  }
}