import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import '../models/profile.dart';
import '../models/skill.dart';
import '../models/experience.dart';
import '../models/education.dart';
import '../models/project.dart';
import '../models/achievement.dart';
import '../models/testimonial.dart';
import '../providers/profile_provider.dart';
import '../providers/settings_provider.dart';
import '../services/sharing_service.dart';
import '../services/pdf_service.dart';
import '../shared/utils/responsive_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        if (profileProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final profile = profileProvider.profile;

        // Increment view count on load
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            profileProvider.incrementViewCount();
            // Show notification if enabled
            final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
            if (settingsProvider.notifications) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile viewed!')),
              );
            }
          }
        });

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Modern App Bar with glassmorphism effect
               SliverAppBar(
                 expandedHeight: ResponsiveUtils.getResponsiveAppBarHeight(context, 160),
                 floating: false,
                 pinned: true,
                 backgroundColor: Colors.transparent,
                 flexibleSpace: FlexibleSpaceBar(
                   background: Container(
                     decoration: BoxDecoration(
                       gradient: LinearGradient(
                         begin: Alignment.topLeft,
                         end: Alignment.bottomRight,
                         colors: [
                           Theme.of(context).primaryColor,
                           Theme.of(context).primaryColor.withValues(alpha: 0.7),
                           Theme.of(context).primaryColor.withValues(alpha: 0.5),
                         ],
                       ),
                     ),
                     child: Container(
                       decoration: BoxDecoration(
                         gradient: LinearGradient(
                           begin: Alignment.topCenter,
                           end: Alignment.bottomCenter,
                           colors: [
                             Colors.white.withValues(alpha: 0.1),
                             Colors.white.withValues(alpha: 0.05),
                           ],
                         ),
                       ),
                       child: _buildProfileHeader(profile),
                     ),
                   ),
                 ),
                 actions: [
                   IconButton(
                     icon: Icon(
                       Icons.search,
                       size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                     ),
                     onPressed: () => _navigateToSearch(context),
                     tooltip: 'Search Profile',
                   ),
                   IconButton(
                     icon: Icon(
                       Icons.share,
                       size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                     ),
                     onPressed: () => _showShareOptions(context, profile),
                   ),
                   IconButton(
                     icon: Icon(
                       Icons.settings,
                       size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                     ),
                     onPressed: () => _navigateToSettings(context),
                   ),
                 ],
               ),

              // Profile content sections
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),

                      // Personal Information Section
                      if (profile.isPersonalInfoVisible)
                        _buildPersonalInfoSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),

                      // Skills Section
                      if (profile.areSkillsVisible && profile.skills.isNotEmpty)
                        _buildSkillsSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),

                      // Experience Section
                      if (profile.areExperiencesVisible && profile.experiences.isNotEmpty)
                        _buildExperienceSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),

                      // Education Section
                      if (profile.isEducationVisible && profile.education.isNotEmpty)
                        _buildEducationSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),

                      // Projects Section
                      if (profile.areProjectsVisible && profile.projects.isNotEmpty)
                        _buildProjectsSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),

                      // Social Links Section
                      if (profile.areSocialLinksVisible && profile.socialLinks.isNotEmpty)
                        _buildSocialLinksSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),

                      // Achievements Section
                      if (profile.areAchievementsVisible && profile.achievements.isNotEmpty)
                        _buildAchievementsSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),

                      // Testimonials Section
                      if (profile.areTestimonialsVisible && profile.testimonials.isNotEmpty)
                        _buildTestimonialsSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveAppBarHeight(context, 80)), // Space for FAB
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Modern Floating Action Button with glassmorphism
           floatingActionButton: ScaleTransition(
             scale: _fabAnimation,
             child: Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 16)),
                 boxShadow: [
                   BoxShadow(
                     color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                     blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 16),
                     spreadRadius: 0,
                     offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 6)),
                   ),
                 ],
               ),
               child: FloatingActionButton.extended(
                 onPressed: () => _navigateToEditProfile(context),
                 backgroundColor: Theme.of(context).primaryColor,
                 foregroundColor: Colors.white,
                 elevation: 0,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 16)),
                 ),
                 icon: Icon(
                   Icons.edit_rounded,
                   size: ResponsiveUtils.getResponsiveIconSize(context, 16),
                 ),
                 label: Text(
                   'Edit Profile',
                   style: TextStyle(
                     fontFamily: 'Inter',
                     fontWeight: FontWeight.w600,
                     fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                   ),
                 ),
               ),
             ),
           ),
        );
      },
    );
  }

  void _showShareOptions(BuildContext context, Profile profile) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share Profile'),
                onTap: () {
                  Navigator.pop(context);
                  _shareProfile(profile);
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text('Export as JSON'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement JSON export
                },
              ),
              ListTile(
                leading: const Icon(Icons.qr_code),
                title: const Text('Generate QR Code'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/qr-code');
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Export as PDF'),
                onTap: () {
                  Navigator.pop(context);
                  _exportAsPdf(profile);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToSearch(BuildContext context) {
    Navigator.pushNamed(context, '/search');
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings');
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.pushNamed(context, '/edit-profile');
  }

  Widget _buildProfileHeader(Profile profile) {
    return Padding(
      padding: ResponsiveUtils.getResponsivePadding(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Modern profile avatar with glow effect
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.3),
                  blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 12),
                  spreadRadius: ResponsiveUtils.getResponsiveIconSize(context, 3),
                ),
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 18),
                  spreadRadius: ResponsiveUtils.getResponsiveIconSize(context, 6),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: ResponsiveUtils.getResponsiveAvatarRadius(context, 35),
              backgroundColor: Colors.white,
              child: profile.personalInfo.profileImagePath != null
                  ? ClipOval(
                      child: Image.asset(
                        profile.personalInfo.profileImagePath!,
                        width: ResponsiveUtils.getResponsiveAvatarRadius(context, 70),
                        height: ResponsiveUtils.getResponsiveAvatarRadius(context, 70),
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
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 24),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),
          // Modern name styling
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveIconSize(context, 8),
              vertical: ResponsiveUtils.getResponsiveIconSize(context, 4),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Text(
              profile.personalInfo.fullName,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
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
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 8)),
          // Modern title styling
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveIconSize(context, 6),
              vertical: ResponsiveUtils.getResponsiveIconSize(context, 3),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 8)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Text(
              profile.personalInfo.professionalTitle,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
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

  Widget _buildPersonalInfoSection(Profile profile) {
    return Container(
      margin: ResponsiveUtils.getResponsiveMargin(context),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 20)),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 16),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 6)),
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
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 10)),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: Theme.of(context).primaryColor,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 20),
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 10)),
              Text(
                'About Me',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),
          Container(
            padding: ResponsiveUtils.getResponsiveCardPadding(context),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Text(
              profile.personalInfo.bio,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontFamily: 'Inter',
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                height: 1.6,
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),
          _buildContactInfo(profile),
        ],
      ),
    );
  }

  Widget _buildContactInfo(Profile profile) {
    return Column(
      children: [
        _buildContactItem(Icons.email, profile.personalInfo.email),
        SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 8)),
        _buildContactItem(Icons.phone, profile.personalInfo.phone),
        SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 8)),
        _buildContactItem(Icons.location_on, profile.personalInfo.location),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: ResponsiveUtils.getResponsiveIconSize(context, 16),
          color: Colors.grey[600],
        ),
        SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 8)),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[800],
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection(Profile profile) {
    return Container(
      margin: ResponsiveUtils.getResponsiveMargin(context),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 20)),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 16),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 6)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveIconSize(context, 8)),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
                ),
                child: Icon(
                  Icons.rocket_launch_rounded,
                  color: Theme.of(context).primaryColor,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 10)),
              Text(
                'Skills & Expertise',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),
          Wrap(
            spacing: ResponsiveUtils.getResponsiveIconSize(context, 10),
            runSpacing: ResponsiveUtils.getResponsiveIconSize(context, 10),
            children: profile.skills.map((skill) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getResponsiveIconSize(context, 12),
                  vertical: ResponsiveUtils.getResponsiveIconSize(context, 8),
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
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 20)),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 6),
                      offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 3)),
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
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 6)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.getResponsiveIconSize(context, 6),
                        vertical: ResponsiveUtils.getResponsiveIconSize(context, 1.5),
                      ),
                      decoration: BoxDecoration(
                        color: _getSkillLevelColor(skill.level).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 10)),
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

  Widget _buildExperienceSection(Profile profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.work, color: Colors.deepPurple),
              const SizedBox(width: 10),
              Text(
                'Experience',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Column(
            children: profile.experiences.map((experience) {
              return _buildExperienceCard(experience);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(Experience experience) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                experience.duration,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            experience.companyName,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            experience.description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationSection(Profile profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.school, color: Colors.deepPurple),
              const SizedBox(width: 10),
              Text(
                'Education',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildEducationCard(profile.education[0]),
        ],
      ),
    );
  }

  Widget _buildEducationCard(Education education) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            education.degreeWithField,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            education.institutionName,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            education.duration,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
        ),
      );
  }

  Widget _buildProjectsSection(Profile profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.folder, color: Colors.deepPurple),
              const SizedBox(width: 10),
              Text(
                'Featured Projects',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Column(
            children: profile.featuredProjects.map((project) {
              return _buildProjectCard(project);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            project.description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: project.technologies.map<Widget>((tech) {
              return Chip(
                label: Text(
                  tech,
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinksSection(Profile profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.link, color: Colors.deepPurple),
              const SizedBox(width: 10),
              Text(
                'Connect',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 15,
            children: profile.socialLinks.map((socialLink) {
              return IconButton(
                onPressed: () => _launchSocialUrl(socialLink.url),
                icon: Icon(
                  socialLink.icon,
                  color: socialLink.color,
                  size: 28,
                ),
                tooltip: socialLink.displayName,
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
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $url')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching URL: $e')),
        );
      }
    }
  }

  Future<void> _shareProfile(Profile profile) async {
    try {
      await SharingService.shareProfile(profile);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing profile: $e')),
        );
      }
    }
  }

  Widget _buildAchievementsSection(Profile profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium, color: Colors.deepPurple),
              const SizedBox(width: 10),
              Text(
                'Achievements & Certifications',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/achievements'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Column(
            children: profile.achievements.take(2).map((achievement) {
              return _buildAchievementPreviewCard(achievement);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementPreviewCard(Achievement achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: achievement.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              achievement.icon,
              color: achievement.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  achievement.issuer,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (achievement.isVerified)
            const Icon(
              Icons.verified,
              color: Colors.green,
              size: 16,
            ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection(Profile profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people, color: Colors.deepPurple),
              const SizedBox(width: 10),
              Text(
                'Testimonials',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/testimonials'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Column(
            children: profile.testimonials.take(2).map((testimonial) {
              return _buildTestimonialPreviewCard(testimonial);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialPreviewCard(Testimonial testimonial) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
                child: Text(
                  testimonial.name.isNotEmpty ? testimonial.name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      testimonial.companyWithPosition,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
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
                      fontSize: 12,
                    ),
                  ),
                  if (testimonial.isVerified)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: 12,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '"${testimonial.message.length > 100 ? '${testimonial.message.substring(0, min(100, testimonial.message.length))}...' : testimonial.message}"',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportAsPdf(Profile profile) async {
    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Generating PDF...')),
        );
      }

      await PdfService.generateAndPrintProfile(profile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF generated and sent to printer!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
    }
  }
}