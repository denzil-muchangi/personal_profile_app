import 'package:flutter/material.dart';
import '../../../models/profile.dart';
import '../../../models/skill.dart';
import '../../../shared/utils/responsive_utils.dart';

class MobileSkillsSection extends StatelessWidget {
  final Profile profile;

  const MobileSkillsSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    Color _getSkillLevelColor(SkillLevel level) {
      switch (level) {
        case SkillLevel.beginner:
          return Colors.orange;
        case SkillLevel.intermediate:
          return Colors.blue;
        case SkillLevel.advanced:
          return Colors.purple;
        case SkillLevel.expert:
          return Colors.green;
      }
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
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveIconSize(context, 6)),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 8)),
                ),
                child: Icon(
                  Icons.rocket_launch_rounded,
                  color: Theme.of(context).primaryColor,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 18),
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 8)),
              Text(
                'Skills & Expertise',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),
          Wrap(
            spacing: ResponsiveUtils.getResponsiveIconSize(context, 8),
            runSpacing: ResponsiveUtils.getResponsiveIconSize(context, 8),
            children: profile.skills.map((skill) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getResponsiveIconSize(context, 10),
                  vertical: ResponsiveUtils.getResponsiveIconSize(context, 6),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      Theme.of(context).primaryColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 16)),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 4),
                      offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 2)),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      skill.name,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 10),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 4)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.getResponsiveIconSize(context, 4),
                        vertical: ResponsiveUtils.getResponsiveIconSize(context, 1),
                      ),
                      decoration: BoxDecoration(
                        color: _getSkillLevelColor(skill.level).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 8)),
                      ),
                      child: Text(
                        skill.levelText,
                        style: TextStyle(
                          color: _getSkillLevelColor(skill.level),
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 8),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}