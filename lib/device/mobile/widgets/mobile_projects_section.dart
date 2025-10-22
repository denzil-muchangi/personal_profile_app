import 'package:flutter/material.dart';
import '../../../models/profile.dart';
import '../../../models/project.dart';
import '../../../shared/utils/responsive_utils.dart';

class MobileProjectsSection extends StatelessWidget {
  final Profile profile;

  const MobileProjectsSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    Widget _buildMobileProjectCard(Project project) {
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
            Text(
              project.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 8)),
            Text(
              project.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 8)),
            Wrap(
              spacing: ResponsiveUtils.getResponsiveIconSize(context, 6),
              children: project.technologies.map<Widget>((tech) {
                return Chip(
                  label: Text(
                    tech,
                    style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 10)),
                  ),
                  backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
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
              Icon(Icons.folder, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 20)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 8)),
              Text(
                'Featured Projects',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),
          Column(
            children: profile.featuredProjects.map((project) {
              return _buildMobileProjectCard(project);
            }).toList(),
          ),
        ],
      ),
    );
  }
}