import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/profile.dart';
import '../../../models/skill.dart';
import '../../../providers/profile_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../services/sharing_service.dart';
import '../../../services/pdf_service.dart';
import '../../../shared/utils/responsive_utils.dart';

class MobileProfileScreen extends StatefulWidget {
  const MobileProfileScreen({super.key});

  @override
  State<MobileProfileScreen> createState() => _MobileProfileScreenState();
}

class _MobileProfileScreenState extends State<MobileProfileScreen>
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
              // Mobile-optimized App Bar
              SliverAppBar(
                expandedHeight: ResponsiveUtils.getResponsiveAppBarHeight(context, 140),
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
                      child: _buildMobileProfileHeader(profile),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 20),
                    ),
                    onPressed: () => _navigateToSearch(context),
                    tooltip: 'Search Profile',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 20),
                    ),
                    onPressed: () => _showShareOptions(context, profile),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 20),
                    ),
                    onPressed: () => _navigateToSettings(context),
                  ),
                ],
              ),

              // Mobile-optimized Profile content sections
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),

                      // Personal Information Section
                      if (profile.isPersonalInfoVisible)
                        _buildMobilePersonalInfoSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),

                      // Skills Section
                      if (profile.areSkillsVisible && profile.skills.isNotEmpty)
                        _buildMobileSkillsSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),

                      // Experience Section
                      if (profile.areExperiencesVisible && profile.experiences.isNotEmpty)
                        _buildMobileExperienceSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),

                      // Education Section
                      if (profile.isEducationVisible && profile.education.isNotEmpty)
                        _buildMobileEducationSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),

                      // Projects Section
                      if (profile.areProjectsVisible && profile.projects.isNotEmpty)
                        _buildMobileProjectsSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),

                      // Social Links Section
                      if (profile.areSocialLinksVisible && profile.socialLinks.isNotEmpty)
                        _buildMobileSocialLinksSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),

                      // Achievements Section
                      if (profile.areAchievementsVisible && profile.achievements.isNotEmpty)
                        _buildMobileAchievementsSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),

                      // Testimonials Section
                      if (profile.areTestimonialsVisible && profile.testimonials.isNotEmpty)
                        _buildMobileTestimonialsSection(profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveAppBarHeight(context, 70)), // Space for FAB
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Mobile-optimized Floating Action Button
          floatingActionButton: ScaleTransition(
            scale: _fabAnimation,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 12),
                    spreadRadius: 0,
                    offset: Offset(0, ResponsiveUtils.getResponsiveIconSize(context, 4)),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: () => _navigateToEditProfile(context),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
                ),
                icon: Icon(
                  Icons.edit_rounded,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 14),
                ),
                label: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileProfileHeader(Profile profile) {
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
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: ResponsiveUtils.getResponsiveIconSize(context, 8),
                  spreadRadius: ResponsiveUtils.getResponsiveIconSize(context, 2),
                ),
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
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
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 8)),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
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
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 6)),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
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

  Widget _buildMobilePersonalInfoSection(Profile profile) {
    return Container(
      margin: ResponsiveUtils.getResponsiveMargin(context),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 16)),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
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
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 8)),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
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
          _buildMobileContactInfo(profile),
        ],
      ),
    );
  }

  Widget _buildMobileContactInfo(Profile profile) {
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

  Widget _buildMobileSkillsSection(Profile profile) {
    return Container(
      margin: ResponsiveUtils.getResponsiveMargin(context),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 16)),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                      Theme.of(context).primaryColor.withOpacity(0.1),
                      Theme.of(context).primaryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 16)),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                        color: _getSkillLevelColor(skill.level).withOpacity(0.2),
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

  // Mobile-optimized Experience Section
  Widget _buildMobileExperienceSection(Profile profile) {
    return Container(
      margin: ResponsiveUtils.getResponsiveMargin(context),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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

  Widget _buildMobileExperienceCard(experience) {
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

  // Mobile-optimized Education Section
  Widget _buildMobileEducationSection(Profile profile) {
    return Container(
      margin: ResponsiveUtils.getResponsiveMargin(context),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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

  Widget _buildMobileEducationCard(education) {
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

  // Mobile-optimized Projects Section
  Widget _buildMobileProjectsSection(Profile profile) {
    return Container(
      margin: ResponsiveUtils.getResponsiveMargin(context),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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

  Widget _buildMobileProjectCard(project) {
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

  // Mobile-optimized Social Links Section
  Widget _buildMobileSocialLinksSection(Profile profile) {
    return Container(
      margin: ResponsiveUtils.getResponsiveMargin(context),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              Icon(Icons.link, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 20)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 8)),
              Text(
                'Connect',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),
          Wrap(
            spacing: ResponsiveUtils.getResponsiveIconSize(context, 12),
            children: profile.socialLinks.map((socialLink) {
              return IconButton(
                onPressed: () => _launchSocialUrl(socialLink.url),
                icon: Icon(
                  socialLink.icon,
                  color: socialLink.color,
                  size: ResponsiveUtils.getResponsiveIconSize(context, 24),
                ),
                tooltip: socialLink.displayName,
                padding: EdgeInsets.all(ResponsiveUtils.getResponsiveIconSize(context, 8)),
                constraints: BoxConstraints(
                  minWidth: ResponsiveUtils.getResponsiveIconSize(context, 32),
                  minHeight: ResponsiveUtils.getResponsiveIconSize(context, 32),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Mobile-optimized Achievements Section
  Widget _buildMobileAchievementsSection(Profile profile) {
    return Container(
      margin: ResponsiveUtils.getResponsiveMargin(context),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              Icon(Icons.workspace_premium, color: Colors.deepPurple, size: ResponsiveUtils.getResponsiveIconSize(context, 20)),
              SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 8)),
              Text(
                'Achievements & Certifications',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/achievements'),
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
            children: profile.achievements.take(2).map((achievement) {
              return _buildMobileAchievementPreviewCard(achievement);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAchievementPreviewCard(achievement) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.getResponsiveIconSize(context, 8)),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 8)),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveIconSize(context, 6)),
            decoration: BoxDecoration(
              color: achievement.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 6)),
            ),
            child: Icon(
              achievement.icon,
              color: achievement.color,
              size: ResponsiveUtils.getResponsiveIconSize(context, 16),
            ),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveIconSize(context, 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                  ),
                ),
                Text(
                  achievement.issuer,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 10),
                  ),
                ),
              ],
            ),
          ),
          if (achievement.isVerified)
            Icon(
              Icons.verified,
              color: Colors.green,
              size: ResponsiveUtils.getResponsiveIconSize(context, 14),
            ),
        ],
      ),
    );
  }

  // Mobile-optimized Testimonials Section
  Widget _buildMobileTestimonialsSection(Profile profile) {
    return Container(
      margin: ResponsiveUtils.getResponsiveMargin(context),
      padding: ResponsiveUtils.getResponsiveCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveIconSize(context, 12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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

  Widget _buildMobileTestimonialPreviewCard(testimonial) {
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
                backgroundColor: Colors.deepPurple.withOpacity(0.1),
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
            '"${testimonial.message.length > 100 ? testimonial.message.substring(0, 100) + '...' : testimonial.message}"',
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
                leading: Icon(Icons.share, size: ResponsiveUtils.getResponsiveIconSize(context, 20)),
                title: Text('Share Profile', style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14))),
                onTap: () {
                  Navigator.pop(context);
                  _shareProfile(profile);
                },
              ),
              ListTile(
                leading: Icon(Icons.file_download, size: ResponsiveUtils.getResponsiveIconSize(context, 20)),
                title: Text('Export as JSON', style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14))),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement JSON export
                },
              ),
              ListTile(
                leading: Icon(Icons.qr_code, size: ResponsiveUtils.getResponsiveIconSize(context, 20)),
                title: Text('Generate QR Code', style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14))),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/qr-code');
                },
              ),
              ListTile(
                leading: Icon(Icons.picture_as_pdf, size: ResponsiveUtils.getResponsiveIconSize(context, 20)),
                title: Text('Export as PDF', style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14))),
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