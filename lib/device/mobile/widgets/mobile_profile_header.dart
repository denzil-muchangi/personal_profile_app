import 'package:flutter/material.dart';
import '../../../models/profile.dart';
import '../../../shared/utils/responsive_utils.dart';

class MobileProfileHeader extends StatelessWidget {
  final Profile profile;

  const MobileProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.getResponsivePadding(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Compact profile avatar for mobile
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.3),
                  blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 8),
                  spreadRadius: ResponsiveUtils.getResponsiveIconSize(context, 2),
                ),
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 12),
                  spreadRadius: ResponsiveUtils.getResponsiveIconSize(context, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: ResponsiveUtils.getResponsiveAvatarRadius(context, 30),
              backgroundColor: Colors.white,
              child: profile.personalInfo.profileImagePath != null
                  ? ClipOval(
                      child: Image.asset(
                        profile.personalInfo.profileImagePath!,
                        width: ResponsiveUtils.getResponsiveAvatarRadius(context, 60),
                        height: ResponsiveUtils.getResponsiveAvatarRadius(context, 60),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).primaryColor.withValues(alpha: 0.8),
                            Theme.of(context).primaryColor,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          profile.personalInfo.fullName.isNotEmpty
                              ? profile.personalInfo.fullName[0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 8)),
          // Compact name styling for mobile
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveIconSize(context, 6),
              vertical: ResponsiveUtils.getResponsiveIconSize(context, 3),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 8)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Text(
              profile.personalInfo.fullName,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Inter',
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 2),
                    offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 1)),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 6)),
          // Compact title styling for mobile
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveIconSize(context, 4),
              vertical: ResponsiveUtils.getResponsiveIconSize(context, 2),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 6)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Text(
              profile.personalInfo.professionalTitle,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 10),
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}