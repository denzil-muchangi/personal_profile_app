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

class TabletProfileScreen extends StatefulWidget {
  const TabletProfileScreen({super.key});

  @override
  State<TabletProfileScreen> createState() => _TabletProfileScreenState();
}

class _TabletProfileScreenState extends State<TabletProfileScreen>
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
              // Tablet-optimized App Bar
              SliverAppBar(
                expandedHeight: ResponsiveUtils.getResponsiveAppBarHeight(context, 180),
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
                      child: _buildTabletProfileHeader(profile),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 22),
                    ),
                    onPressed: () => _navigateToSearch(context),
                    tooltip: 'Search Profile',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 22),
                    ),
                    onPressed: () => _showShareOptions(context, profile),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 22),
                    ),
                    onPressed: () => _navigateToSettings(context),
                  ),
                ],
              ),

              // Tablet-optimized Profile content sections
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),

                      // Two-column layout for tablet
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left column - Personal info, skills, experience
                          Expanded(
                            child: Column(
                              children: [
                                // Personal Information Section
                                if (profile.isPersonalInfoVisible)
                                  _buildTabletPersonalInfoSection(profile),

                                SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),

                                // Skills Section
                                if (profile.areSkillsVisible && profile.skills.isNotEmpty)
                                  _buildTabletSkillsSection(profile),

                                SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),

                                // Experience Section
                                if (profile.areExperiencesVisible && profile.experiences.isNotEmpty)
                                  _buildTabletExperienceSection(profile),
                              ],
                            ),
                          ),

                          SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 14)),

                          // Right column - Education, projects, social, achievements, testimonials
                          Expanded(
                            child: Column(
                              children: [
                                // Education Section
                                if (profile.isEducationVisible && profile.education.isNotEmpty)
                                  _buildTabletEducationSection(profile),

                                SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),

                                // Projects Section
                                if (profile.areProjectsVisible && profile.projects.isNotEmpty)
                                  _buildTabletProjectsSection(profile),

                                SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),

                                // Social Links Section
                                if (profile.areSocialLinksVisible && profile.socialLinks.isNotEmpty)
                                  _buildTabletSocialLinksSection(profile),

                                SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),

                                // Achievements Section
                                if (profile.areAchievementsVisible && profile.achievements.isNotEmpty)
                                  _buildTabletAchievementsSection(profile),

                                SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),

                                // Testimonials Section
                                if (profile.areTestimonialsVisible && profile.testimonials.isNotEmpty)
                                  _buildTabletTestimonialsSection(profile),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: ResponsiveUtils.getResponsiveAppBarHeight(context, 80)), // Space for FAB
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Tablet-optimized Floating Action Button
          floatingActionButton: ScaleTransition(
            scale: _fabAnimation,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 14)),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 14),
                    spreadRadius: 0,
                    offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 5)),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: () => _navigateToEditProfile(context),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 14)),
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
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 13),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabletProfileHeader(Profile profile) {
    return Padding(
      padding: ResponsiveUtils.getResponsivePadding(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Balanced profile avatar for tablet
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 14),
                  spreadRadius: ResponsiveUtils.getResponsiveIconSize(context, 4),
                ),
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 20),
                  spreadRadius: ResponsiveUtils.getResponsiveIconSize(context, 7),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: ResponsiveUtils.getResponsiveAvatarRadius(context, 40),
              backgroundColor: Colors.white,
              child: profile.personalInfo.profileImagePath != null
                  ? ClipOval(
                      child: Image.asset(
                        profile.personalInfo.profileImagePath!,
                        width: ResponsiveUtils.getResponsiveAvatarRadius(context, 80),
                        height: ResponsiveUtils.getResponsiveAvatarRadius(context, 80),
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
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 28),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),
          // Balanced name styling for tablet
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveIconSize(context, 10),
              vertical: ResponsiveUtils.getResponsiveIconSize(context, 5),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 14)),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(
              profile.personalInfo.fullName,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Inter',
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 3),
                    offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 1.5)),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 10)),
          // Balanced title styling for tablet
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveIconSize(context, 8),
              vertical: ResponsiveUtils.getResponsiveIconSize(context, 4),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 10)),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Text(
              profile.personalInfo.professionalTitle,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 13),
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

  Widget _buildTabletPersonalInfoSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        left: ResponsiveUtils.getResponsiveMargin(context).horizontal / 2,
        right: ResponsiveUtils.getResponsiveIconSize(context, 7),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 18)),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 14),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 5)),
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
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
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
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),
          Container(
            padding: ResponsiveUtils.getResponsiveCardPadding(context),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Text(
              profile.personalInfo.bio,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontFamily: 'Inter',
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 13),
                height: 1.6,
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),
          _buildTabletContactInfo(profile),
        ],
      ),
    );
  }

  Widget _buildTabletContactInfo(Profile profile) {
    return Column(
      children: [
        _buildTabletContactItem(Icons.email, profile.personalInfo.email),
        SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 8)),
        _buildTabletContactItem(Icons.phone, profile.personalInfo.phone),
        SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 8)),
        _buildTabletContactItem(Icons.location_on, profile.personalInfo.location),
      ],
    );
  }

  Widget _buildTabletContactItem(IconData icon, String text) {
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
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletSkillsSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        left: ResponsiveUtils.getResponsiveMargin(context).horizontal / 2,
        right: ResponsiveUtils.getResponsiveIconSize(context, 7),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 18)),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 14),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 5)),
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
                  Icons.rocket_launch_rounded,
                  color: Theme.of(context).primaryColor,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 22),
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
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),
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
                      Theme.of(context).primaryColor.withOpacity(0.1),
                      Theme.of(context).primaryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 18)),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                        color: _getSkillLevelColor(skill.level).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 10)),
                      ),
                      child: Text(
                        skill.levelText,
                        style: TextStyle(
                          color: _getSkillLevelColor(skill.level),
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 9),
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

  // Tablet-optimized Experience Section
  Widget _buildTabletExperienceSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        left: ResponsiveUtils.getResponsiveMargin(context).horizontal / 2,
        right: ResponsiveUtils.getResponsiveIconSize(context, 7),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 14)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 8),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.work, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 22)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 10)),
              Text(
                'Experience',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),
          Column(
            children: profile.experiences.map((experience) {
              return _buildTabletExperienceCard(experience);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletExperienceCard(experience) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveIconSize(context, 14)),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 10)),
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
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 15),
                  ),
                ),
              ),
              Text(
                experience.duration,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 11),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 5)),
          Text(
            experience.companyName,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 13),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 10)),
          Text(
            experience.description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 13),
            ),
          ),
        ],
      ),
    );
  }

  // Right column sections (Education, Projects, Social, Achievements, Testimonials)
  Widget _buildTabletEducationSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        right: ResponsiveUtils.getResponsiveMargin(context).horizontal / 2,
        left: ResponsiveUtils.getResponsiveIconSize(context, 7),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 14)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 8),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 22)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 10)),
              Text(
                'Education',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),
          _buildTabletEducationCard(profile.education[0]),
        ],
      ),
    );
  }

  Widget _buildTabletEducationCard(education) {
    return Container(
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 10)),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            education.degreeWithField,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 15),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 5)),
          Text(
            education.institutionName,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 13),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 5)),
          Text(
            education.duration,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletProjectsSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        right: ResponsiveUtils.getResponsiveMargin(context).horizontal / 2,
        left: ResponsiveUtils.getResponsiveIconSize(context, 7),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 14)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 8),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.folder, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 22)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 10)),
              Text(
                'Featured Projects',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),
          Column(
            children: profile.featuredProjects.map((project) {
              return _buildTabletProjectCard(project);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletProjectCard(project) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveIconSize(context, 14)),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 10)),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 15),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 10)),
          Text(
            project.description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 13),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 10)),
          Wrap(
            spacing: ResponsiveUtils.getResponsiveIconSize(context, 8),
            children: project.technologies.map<Widget>((tech) {
              return Chip(
                label: Text(
                  tech,
                  style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 11)),
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

  Widget _buildTabletSocialLinksSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        right: ResponsiveUtils.getResponsiveMargin(context).horizontal / 2,
        left: ResponsiveUtils.getResponsiveIconSize(context, 7),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 14)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 8),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.link, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 22)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 10)),
              Text(
                'Connect',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),
          Wrap(
            spacing: ResponsiveUtils.getResponsiveIconSize(context, 14),
            children: profile.socialLinks.map((socialLink) {
              return IconButton(
                onPressed: () => _launchSocialUrl(socialLink.url),
                icon: Icon(
                  socialLink.icon,
                  color: socialLink.color,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 26),
                ),
                tooltip: socialLink.displayName,
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveIconSize(context, 10)),
                constraints: BoxConstraints(
                  minWidth: ResponsiveUtils.getResponsiveIconSize(context, 36),
                  minHeight: ResponsiveUtils.getResponsiveIconSize(context, 36),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletAchievementsSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        right: ResponsiveUtils.getResponsiveMargin(context).horizontal / 2,
        left: ResponsiveUtils.getResponsiveIconSize(context, 7),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 14)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 8),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.workspace_premium, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 22)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 10)),
              Text(
                'Achievements & Certifications',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/achievements'),
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 13),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),
          Column(
            children: profile.achievements.take(2).map((achievement) {
              return _buildTabletAchievementPreviewCard(achievement);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletAchievementPreviewCard(achievement) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveIconSize(context, 10)),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 10)),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveIconSize(context, 8)),
            decoration: BoxDecoration(
              color: achievement.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 8)),
            ),
            child: Icon(
              achievement.icon,
              color: achievement.color,
              size: ResponsiveUtils.getResponsiveIconSize(context, 18),
            ),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 13),
                  ),
                ),
                Text(
                  achievement.issuer,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 11),
                  ),
                ),
              ],
            ),
          ),
          if (achievement.isVerified)
            Icon(
              Icons.verified,
              color: Colors.green,
              size: ResponsiveUtils.getResponsiveIconSize(context, 16),
            ),
        ],
      ),
    );
  }

  Widget _buildTabletTestimonialsSection(Profile profile) {
    return Container(
      margin: EdgeInsets.only(
        right: ResponsiveUtils.getResponsiveMargin(context).horizontal / 2,
        left: ResponsiveUtils.getResponsiveIconSize(context, 7),
      ),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 14)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 8),
            offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 22)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 10)),
              Text(
                'Testimonials',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/testimonials'),
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 13),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 14)),
          Column(
            children: profile.testimonials.take(2).map((testimonial) {
              return _buildTabletTestimonialPreviewCard(testimonial);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletTestimonialPreviewCard(testimonial) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveIconSize(context, 14)),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 10)),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: ResponsiveUtils.getResponsiveIconSize(context, 18),
                backgroundColor: Colors.deepPurple.withOpacity(0.1),
                child: Text(
                  testimonial.name.isNotEmpty ? testimonial.name[0].toUpperCase() : 'U',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 13),
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 13),
                      ),
                    ),
                    Text(
                      testimonial.companyWithPosition,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 11),
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
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 11),
                    ),
                  ),
                  if (testimonial.isVerified)
                    Padding(
                      padding: EdgeInsets.only(left: ResponsiveUtils.getResponsiveIconSize(context, 4)),
                      child: Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: ResponsiveUtils.getResponsiveIconSize(context, 12),
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 8)),
          Text(
            '"${testimonial.message.length > 120 ? testimonial.message.substring(0, 120) + '...' : testimonial.message}"',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 11),
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
                leading: Icon(Icons.share, size: ResponsiveUtils.getResponsiveIconSize(context, 22)),
                title: Text('Share Profile', style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 15))),
                onTap: () {
                  Navigator.pop(context);
                  _shareProfile(profile);
                },
              ),
              ListTile(
                leading: Icon(Icons.file_download, size: ResponsiveUtils.getResponsiveIconSize(context, 22)),
                title: Text('Export as JSON', style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 15))),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement JSON export
                },
              ),
              ListTile(
                leading: Icon(Icons.qr_code, size: ResponsiveUtils.getResponsiveIconSize(context, 22)),
                title: Text('Generate QR Code', style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 15))),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/qr-code');
                },
              ),
              ListTile(
                leading: Icon(Icons.picture_as_pdf, size: ResponsiveUtils.getResponsiveIconSize(context, 22)),
                title: Text('Export as PDF', style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 15))),
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