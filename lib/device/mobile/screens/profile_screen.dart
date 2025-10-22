import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/profile.dart';
import '../../../providers/profile_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../services/sharing_service.dart';
import '../../../services/pdf_service.dart';
import '../../../shared/utils/responsive_utils.dart';
import '../widgets/mobile_profile_header.dart';
import '../widgets/mobile_personal_info_section.dart';
import '../widgets/mobile_skills_section.dart';
import '../widgets/mobile_experience_section.dart';
import '../widgets/mobile_education_section.dart';
import '../widgets/mobile_projects_section.dart';
import '../widgets/mobile_social_links_section.dart';
import '../widgets/mobile_achievements_section.dart';
import '../widgets/mobile_testimonials_section.dart';

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
                      child: MobileProfileHeader(profile: profile),
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
                        MobilePersonalInfoSection(profile: profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),

                      // Skills Section
                      if (profile.areSkillsVisible && profile.skills.isNotEmpty)
                        MobileSkillsSection(profile: profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),

                      // Experience Section
                      if (profile.areExperiencesVisible && profile.experiences.isNotEmpty)
                        MobileExperienceSection(profile: profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),

                      // Education Section
                      if (profile.isEducationVisible && profile.education.isNotEmpty)
                        MobileEducationSection(profile: profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),

                      // Projects Section
                      if (profile.areProjectsVisible && profile.projects.isNotEmpty)
                        MobileProjectsSection(profile: profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),

                      // Social Links Section
                      if (profile.areSocialLinksVisible && profile.socialLinks.isNotEmpty)
                        MobileSocialLinksSection(profile: profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),

                      // Achievements Section
                      if (profile.areAchievementsVisible && profile.achievements.isNotEmpty)
                        MobileAchievementsSection(profile: profile),

                      SizedBox(height: ResponsiveUtils.getResponsiveIconSize(context, 12)),

                      // Testimonials Section
                      if (profile.areTestimonialsVisible && profile.testimonials.isNotEmpty)
                        MobileTestimonialsSection(profile: profile),

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
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
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