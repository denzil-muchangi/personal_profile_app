import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/profile.dart';
import '../../models/skill.dart';
import '../../providers/profile_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/sharing_service.dart';
import '../../services/pdf_service.dart';
import '../../../shared/utils/responsive_utils.dart';

class DesktopProfileScreen extends StatefulWidget {
  const DesktopProfileScreen({super.key});

  @override
  State<DesktopProfileScreen> createState() => _DesktopProfileScreenState();
}

class _DesktopProfileScreenState extends State<DesktopProfileScreen>
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
          profileProvider.incrementViewCount();
          // Show notification if enabled
          final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
          if (settingsProvider.notifications) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile viewed!')),
            );
          }
        });

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Desktop-optimized App Bar
              SliverAppBar(
                expandedHeight: ResponsiveUtils.getResponsiveAppBarHeight(context, 200),
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
                          Theme.of(context).primaryColor.withOpacity(0.7),
                          Theme.of(context).primaryColor.withOpacity(0.5),
                        ],
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: _buildDesktopProfileHeader(profile),
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

              // Desktop-optimized Profile content sections
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
                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 20)),

                      // Three-column layout for desktop
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left column - Personal info, skills
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                // Personal Information Section
                                if (profile.isPersonalInfoVisible)
                                  _buildDesktopPersonalInfoSection(profile),

                                SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 20)),

                                // Skills Section
                                if (profile.areSkillsVisible && profile.skills.isNotEmpty)
                                  _buildDesktopSkillsSection(profile),
                              ],
                            ),
                          ),

                          SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 20)),

                          // Middle column - Experience, education
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                // Experience Section
                                if (profile.areExperiencesVisible && profile.experiences.isNotEmpty)
                                  _buildDesktopExperienceSection(profile),

                                SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 20)),

                                // Education Section
                                if (profile.isEducationVisible && profile.education.isNotEmpty)
                                  _buildDesktopEducationSection(profile),
                              ],
                            ),
                          ),

                          SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 20)),

                          // Right column - Projects, social, achievements, testimonials
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                // Projects Section
                                if (profile.areProjectsVisible && profile.projects.isNotEmpty)
                                  _buildDesktopProjectsSection(profile),

                                SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 20)),

                                // Social Links Section
                                if (profile.areSocialLinksVisible && profile.socialLinks.isNotEmpty)
                                  _buildDesktopSocialLinksSection(profile),

                                SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 20)),

                                // Achievements Section
                                if (profile.areAchievementsVisible && profile.achievements.isNotEmpty)
                                  _buildDesktopAchievementsSection(profile),

                                SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 20)),

                                // Testimonials Section
                                if (profile.areTestimonialsVisible && profile.testimonials.isNotEmpty)
                                  _buildDesktopTestimonialsSection(profile),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: ResponsiveUtils.getResponsiveAppBarHeight(context, 100)), // Space for FAB
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Desktop-optimized Floating Action Button
          floatingActionButton: ScaleTransition(
            scale: _fabAnimation,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 16)),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
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
                  size: ResponsiveUtils.getResponsiveIconSize(context, 18),
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

  Widget _buildDesktopProfileHeader(Profile profile) {
    return Padding(
      padding: ResponsiveUtils.getResponsivePadding(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large profile avatar for desktop
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 16),
                  spreadRadius: ResponsiveUtils.getResponsiveIconSize(context, 5),
                ),
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 24),
                  spreadRadius: ResponsiveUtils.getResponsiveIconSize(context, 8),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: ResponsiveUtils.getResponsiveAvatarRadius(context, 50),
              backgroundColor: Colors.white,
              child: profile.personalInfo.profileImagePath != null
                  ? ClipOval(
                      child: Image.asset(
                        profile.personalInfo.profileImagePath!,
                        width: ResponsiveUtils.getResponsiveAvatarRadius(context, 100),
                        height: ResponsiveUtils.getResponsiveAvatarRadius(context, 100),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.8),
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
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 36),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),
          // Large name styling for desktop
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveIconSize(context, 14),
              vertical: ResponsiveUtils.getResponsiveIconSize(context, 7),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 18)),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(
              profile.personalInfo.fullName,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 24),
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Inter',
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 4),
                    offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 2)),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),
          // Large title styling for desktop
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveIconSize(context, 12),
              vertical: ResponsiveUtils.getResponsiveIconSize(context, 6),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 14)),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Text(
              profile.personalInfo.professionalTitle,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 15),
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

  Widget _buildDesktopPersonalInfoSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        left: ResponsiveUtils.getResponsiveMargin(context).horizontal / 3,
        right: ResponsiveUtils.getResponsiveIconSize(context, 10),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 20)),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: Theme.of(context).primaryColor,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 12)),
              Text(
                'About Me',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 22),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),
          Container(
            padding: ResponsiveUtils.getResponsiveCardPadding(context),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 14)),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
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
          _buildDesktopContactInfo(profile),
        ],
      ),
    );
  }

  Widget _buildDesktopContactInfo(Profile profile) {
    return Column(
      children: [
        _buildDesktopContactItem(Icons.email, profile.personalInfo.email),
        SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 10)),
        _buildDesktopContactItem(Icons.phone, profile.personalInfo.phone),
        SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 10)),
        _buildDesktopContactItem(Icons.location_on, profile.personalInfo.location),
      ],
    );
  }

  Widget _buildDesktopContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: ResponsiveUtils.getResponsiveIconSize(context, 18),
          color: Colors.grey[600],
        ),
        SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 10)),
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

  Widget _buildDesktopSkillsSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        left: ResponsiveUtils.getResponsiveMargin(context).horizontal / 3,
        right: ResponsiveUtils.getResponsiveIconSize(context, 10),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 20)),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveIconSize(context, 10)),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 14)),
                ),
                child: Icon(
                  Icons.rocket_launch_rounded,
                  color: Theme.of(context).primaryColor,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 26),
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 12)),
              Text(
                'Skills & Expertise',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 22),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),
          Wrap(
            spacing: ResponsiveUtils.getResponsiveIconSize(context, 12),
            runSpacing: ResponsiveUtils.getResponsiveIconSize(context, 12),
            children: profile.skills.map((skill) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getResponsiveIconSize(context, 14),
                  vertical: ResponsiveUtils.getResponsiveIconSize(context, 10),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.1),
                      Theme.of(context).primaryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 20)),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 8),
                      offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 4)),
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
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 13),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 8)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.getResponsiveIconSize(context, 8),
                        vertical: ResponsiveUtils.getResponsiveIconSize(context, 2),
                      ),
                      decoration: BoxDecoration(
                        color: _getSkillLevelColor(skill.level).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
                      ),
                      child: Text(
                        skill.levelText,
                        style: TextStyle(
                          color: _getSkillLevelColor(skill.level),
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 10),
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
      default:
        return Colors.grey;
    }
  }

  // Desktop-optimized Experience Section
  Widget _buildDesktopExperienceSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        left: ResponsiveUtils.getResponsiveIconSize(context, 10),
        right: ResponsiveUtils.getResponsiveIconSize(context, 10),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 10),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 3)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.work, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 26)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 12)),
              Text(
                'Experience',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 22),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),
          Column(
            children: profile.experiences.map((experience) {
              return _buildDesktopExperienceCard(experience);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopExperienceCard(experience) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveIconSize(context, 16)),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
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
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                  ),
                ),
              ),
              Text(
                experience.duration,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 6)),
          Text(
            experience.companyName,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),
          Text(
            experience.description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
            ),
          ),
        ],
      ),
    );
  }

  // Desktop-optimized Education Section
  Widget _buildDesktopEducationSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        left: ResponsiveUtils.getResponsiveIconSize(context, 10),
        right: ResponsiveUtils.getResponsiveIconSize(context, 10),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 10),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 3)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 26)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 12)),
              Text(
                'Education',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 22),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),
          _buildDesktopEducationCard(profile.education[0]),
        ],
      ),
    );
  }

  Widget _buildDesktopEducationCard(education) {
    return Container(
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            education.degreeWithField,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 6)),
          Text(
            education.institutionName,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 6)),
          Text(
            education.duration,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
            ),
          ),
        ],
      ),
    );
  }

  // Desktop-optimized Projects Section
  Widget _buildDesktopProjectsSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        right: ResponsiveUtils.getResponsiveIconSize(context, 10),
        left: ResponsiveUtils.getResponsiveIconSize(context, 10),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 10),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 3)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.folder, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 26)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 12)),
              Text(
                'Featured Projects',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 22),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),
          Column(
            children: profile.featuredProjects.map((project) {
              return _buildDesktopProjectCard(project);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopProjectCard(project) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveIconSize(context, 16)),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),
          Text(
            project.description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),
          Wrap(
            spacing: ResponsiveUtils.getResponsiveIconSize(context, 10),
            children: project.technologies.map<Widget>((tech) {
              return Chip(
                label: Text(
                  tech,
                  style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12)),
                ),
                backgroundColor: Colors.deepPurple.withOpacity(0.1),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopSocialLinksSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        right: ResponsiveUtils.getResponsiveIconSize(context, 10),
        left: ResponsiveUtils.getResponsiveIconSize(context, 10),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 10),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 3)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.link, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 26)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 12)),
              Text(
                'Connect',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 22),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),
          Wrap(
            spacing: ResponsiveUtils.getResponsiveIconSize(context, 16),
            children: profile.socialLinks.map((socialLink) {
              return IconButton(
                onPressed: () => _launchSocialUrl(socialLink.url),
                icon: Icon(
                  socialLink.icon,
                  color: socialLink.color,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 30),
                ),
                tooltip: socialLink.displayName,
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveIconSize(context, 12)),
                constraints: BoxConstraints(
                  minWidth: ResponsiveUtils.getResponsiveIconSize(context, 40),
                  minHeight: ResponsiveUtils.getResponsiveIconSize(context, 40),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopAchievementsSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        right: ResponsiveUtils.getResponsiveIconSize(context, 10),
        left: ResponsiveUtils.getResponsiveIconSize(context, 10),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 10),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 3)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.workspace_premium, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 26)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 12)),
              Text(
                'Achievements & Certifications',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 22),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/achievements'),
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),
          Column(
            children: profile.achievements.take(3).map((achievement) {
              return _buildDesktopAchievementPreviewCard(achievement);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopAchievementPreviewCard(achievement) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveIconSize(context, 12)),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveIconSize(context, 10)),
            decoration: BoxDecoration(
              color: achievement.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 10)),
            ),
            child: Icon(
              achievement.icon,
              color: achievement.color,
              size: ResponsiveUtils.getResponsiveIconSize(context, 20),
            ),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  ),
                ),
                Text(
                  achievement.issuer,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                  ),
                ),
              ],
            ),
          ),
          if (achievement.isVerified)
            Icon(
              Icons.verified,
              color: Colors.green,
              size: ResponsiveUtils.getResponsiveIconSize(context, 18),
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopTestimonialsSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        right: ResponsiveUtils.getResponsiveIconSize(context, 10),
        left: ResponsiveUtils.getResponsiveIconSize(context, 10),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 10),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 3)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 26)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 12)),
              Text(
                'Testimonials',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 22),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/testimonials'),
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 16)),
          Column(
            children: profile.testimonials.take(3).map((testimonial) {
              return _buildDesktopTestimonialPreviewCard(testimonial);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTestimonialPreviewCard(testimonial) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveIconSize(context, 16)),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: ResponsiveUtils.getResponsiveIconSize(context, 20),
                backgroundColor: Colors.deepPurple.withOpacity(0.1),
                child: Text(
                  testimonial.name.isNotEmpty ? testimonial.name[0].toUpperCase() : 'U',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                      ),
                    ),
                    Text(
                      testimonial.companyWithPosition,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
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
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                    ),
                  ),
                  if (testimonial.isVerified)
                    Padding(
                      padding: EdgeInsets.only(left: ResponsiveUtils.getResponsiveIconSize(context, 5)),
                      child: Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: ResponsiveUtils.getResponsiveIconSize(context, 14),
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 10)),
          Text(
            '"${testimonial.message.length > 150 ? testimonial.message.substring(0, 150) + '...' : testimonial.message}"',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // Navigation methods
  void _showShareOptions(BuildContext context, Profile profile) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: ResponsiveUtils.getResponsiveCardPadding(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.share, size: ResponsiveUtils.getResponsiveIconSize(context, 24)),
                title: Text('Share Profile', style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16))),
                onTap: () {
                  Navigator.pop(context);
                  _shareProfile(profile);
                },
              ),
              ListTile(
                leading: Icon(Icons.file_download, size: ResponsiveUtils.getResponsiveIconSize(context, 24)),
                title: Text('Export as JSON', style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16))),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement JSON export
                },
              ),
              ListTile(
                leading: Icon(Icons.qr_code, size: ResponsiveUtils.getResponsiveIconSize(context, 24)),
                title: Text('Generate QR Code', style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16))),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/qr-code');
                },
              ),
              ListTile(
                leading: Icon(Icons.picture_as_pdf, size: ResponsiveUtils.getResponsiveIconSize(context, 24)),
                title: Text('Export as PDF', style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16))),
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

  Future<void> _launchSocialUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching URL: $e')),
      );
    }
  }

  Future<void> _shareProfile(Profile profile) async {
    try {
      await SharingService.shareProfile(profile);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing profile: $e')),
      );
    }
  }

  Future<void> _exportAsPdf(Profile profile) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generating PDF...')),
      );

      await PdfService.generateAndPrintProfile(profile);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF generated and sent to printer!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
  }
}