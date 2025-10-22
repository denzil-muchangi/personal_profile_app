import 'package:flutter/material.dart';
import '../../../models/profile.dart';
import '../../../models/testimonial.dart';
import '../../../shared/utils/responsive_utils.dart';

class MobileTestimonialsSection extends StatelessWidget {
  final Profile profile;

  const MobileTestimonialsSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    Widget _buildMobileTestimonialPreviewCard(Testimonial testimonial) {
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
              children: [
                CircleAvatar(
                  radius: ResponsiveUtils.getResponsiveIconSize(context, 16),
                  backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
                  child: Text(
                    testimonial.name.isNotEmpty ? testimonial.name[0].toUpperCase() : 'U',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 8)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        testimonial.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                        ),
                      ),
                      Text(
                        testimonial.companyWithPosition,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 10),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      testimonial.ratingText,
                      style: TextStyle(
                        color: testimonial.ratingColor,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 10),
                      ),
                    ),
                    if (testimonial.isVerified)
                      Padding(
                        padding: EdgeInsets.only(left: ResponsiveUtils.getResponsiveIconSize(context, 3)),
                        child: Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: ResponsiveUtils.getResponsiveIconSize(context, 10),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 6)),
            Text(
              '"${testimonial.message.length > 100 ? '${testimonial.message.substring(0, 100)}...' : testimonial.message}"',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 10),
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
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
              Icon(Icons.people, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 20)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 8)),
              Text(
                'Testimonials',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/testimonials'),
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
            children: profile.testimonials.take(2).map((testimonial) {
              return _buildMobileTestimonialPreviewCard(testimonial);
            }).toList(),
          ),
        ],
      ),
    );
  }
}