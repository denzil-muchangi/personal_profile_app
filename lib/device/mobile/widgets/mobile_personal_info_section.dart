import 'package:flutter/material.dart';
import '../../../models/profile.dart';
import '../../../shared/utils/responsive_utils.dart';

class MobilePersonalInfoSection extends StatelessWidget {
  final Profile profile;

  const MobilePersonalInfoSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    Widget _buildMobileContactItem(IconData icon, String text) {
      return Row(
        children: [
          Icon(
            icon,
            size: ResponsiveUtils.getResponsiveIconSize(context, 14),
            color: Colors.grey[600],
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 6)),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[800],
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
              ),
            ),
          ),
        ],
      );
    }

    Widget _buildMobileContactInfo() {
      return Column(
        children: [
          _buildMobileContactItem(Icons.email, profile.personalInfo.email),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 6)),
          _buildMobileContactItem(Icons.phone, profile.personalInfo.phone),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 6)),
          _buildMobileContactItem(Icons.location_on, profile.personalInfo.location),
        ],
      );
    }

    return Container(
      margin: ResponsiveUtils.getResponsiveMargin(context),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 16)),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 12),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 4)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveIconSize(context, 4)),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 8)),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: Theme.of(context).primaryColor,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 16),
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 8)),
              Text(
                'About Me',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),
          Container(
            padding: ResponsiveUtils.getResponsiveCardPadding(context),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 8)),
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Text(
              profile.personalInfo.bio,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontFamily: 'Inter',
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                height: 1.6,
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),
          _buildMobileContactInfo(),
        ],
      ),
    );
  }
}