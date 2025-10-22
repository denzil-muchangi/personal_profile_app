import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/settings_provider.dart';
import '../providers/profile_provider.dart';
import '../services/pdf_service.dart';
import '../services/backup_service.dart';
import '../models/profile.dart';
import '../shared/utils/responsive_utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return ListView(
            padding: ResponsiveUtils.getResponsivePadding(context),
            children: [
              // Appearance Section
              _buildSectionHeader('Appearance'),
              _buildThemeModeTile(settingsProvider),
              _buildPrimaryColorTile(settingsProvider),

              const Divider(),

              // Profile Section
              _buildSectionHeader('Profile'),
              _buildExportProfileTile(),
              _buildImportProfileTile(),
              _buildBackupTile(),
              _buildRestoreTile(),

              const Divider(),

              // Privacy Section
              _buildSectionHeader('Privacy'),
              _buildPrivacyTile('Personal Information', Icons.person, () => _toggleVisibility('personalInfo')),
              _buildPrivacyTile('Skills', Icons.star, () => _toggleVisibility('skills')),
              _buildPrivacyTile('Experience', Icons.work, () => _toggleVisibility('experience')),
              _buildPrivacyTile('Education', Icons.school, () => _toggleVisibility('education')),
              _buildPrivacyTile('Projects', Icons.folder, () => _toggleVisibility('projects')),
              _buildPrivacyTile('Social Links', Icons.link, () => _toggleVisibility('socialLinks')),
              _buildPrivacyTile('Achievements', Icons.workspace_premium, () => _toggleVisibility('achievements')),
              _buildPrivacyTile('Testimonials', Icons.people, () => _toggleVisibility('testimonials')),

              const Divider(),

              // Analytics Section
              _buildSectionHeader('Analytics'),
              _buildAnalyticsTile(),

              const Divider(),

              // Privacy & Security
              _buildSectionHeader('Privacy & Security'),
              _buildAutoSaveTile(settingsProvider),
              _buildNotificationsTile(settingsProvider),

              const Divider(),

              // About Section
              _buildSectionHeader('About'),
              _buildVersionTile(),
              _buildPrivacyPolicyTile(),
              _buildTermsOfServiceTile(),
              _buildContactSupportTile(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtils.getResponsiveIconSize(context, 12),
        ResponsiveUtils.getResponsiveIconSize(context, 12),
        ResponsiveUtils.getResponsiveIconSize(context, 12),
        ResponsiveUtils.getResponsiveIconSize(context, 6),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
        ),
      ),
    );
  }

  Widget _buildThemeModeTile(SettingsProvider settingsProvider) {
    return ListTile(
      leading: const Icon(Icons.brightness_6),
      title: const Text('Theme Mode'),
      subtitle: Text(_getThemeModeText(settingsProvider.themeMode)),
      trailing: DropdownButton<ThemeMode>(
        value: settingsProvider.themeMode,
        onChanged: (ThemeMode? newValue) {
          if (newValue != null) {
            settingsProvider.setThemeMode(newValue);
          }
        },
        items: const [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text('System'),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text('Light'),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text('Dark'),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryColorTile(SettingsProvider settingsProvider) {
    return ListTile(
      leading: const Icon(Icons.color_lens),
      title: const Text('Primary Color'),
      subtitle: Text(_getColorName(settingsProvider.primaryColor)),
      trailing: CircleAvatar(
        backgroundColor: settingsProvider.primaryColor,
        radius: 14,
      ),
      onTap: () => _showColorPicker(settingsProvider),
    );
  }

  Widget _buildExportProfileTile() {
    return ListTile(
      leading: const Icon(Icons.file_download),
      title: const Text('Export Profile'),
      subtitle: const Text('Save profile data as JSON file'),
      onTap: () => _showExportOptions(),
    );
  }

  Widget _buildImportProfileTile() {
    return ListTile(
      leading: const Icon(Icons.file_upload),
      title: const Text('Import Profile'),
      subtitle: const Text('Load profile data from JSON file'),
      onTap: () => _showImportOptions(),
    );
  }

  Widget _buildBackupTile() {
    return ListTile(
      leading: const Icon(Icons.backup),
      title: const Text('Create Backup'),
      subtitle: const Text('Backup all app data'),
      onTap: () => _createBackup(),
    );
  }

  Widget _buildRestoreTile() {
    return ListTile(
      leading: const Icon(Icons.restore),
      title: const Text('Restore Backup'),
      subtitle: const Text('Restore from previous backup'),
      onTap: () => _showRestoreOptions(),
    );
  }

  Widget _buildAutoSaveTile(SettingsProvider settingsProvider) {
    return SwitchListTile(
      secondary: const Icon(Icons.save),
      title: const Text('Auto-save Changes'),
      subtitle: const Text('Automatically save profile changes'),
      value: settingsProvider.autoSave,
      onChanged: (bool value) {
        settingsProvider.setAutoSave(value);
      },
    );
  }

  Widget _buildNotificationsTile(SettingsProvider settingsProvider) {
    return SwitchListTile(
      secondary: const Icon(Icons.notifications),
      title: const Text('Notifications'),
      subtitle: const Text('Receive notifications for profile views and updates'),
      value: settingsProvider.notifications,
      onChanged: (bool value) {
        settingsProvider.setNotifications(value);
      },
    );
  }

  Widget _buildVersionTile() {
    return ListTile(
      leading: const Icon(Icons.info),
      title: const Text('Version'),
      subtitle: const Text('1.0.0'),
      onTap: () {},
    );
  }

  Widget _buildPrivacyPolicyTile() {
    return ListTile(
      leading: const Icon(Icons.privacy_tip),
      title: const Text('Privacy Policy'),
      onTap: () => _launchURL('https://example.com/privacy'),
    );
  }

  Widget _buildTermsOfServiceTile() {
    return ListTile(
      leading: const Icon(Icons.description),
      title: const Text('Terms of Service'),
      onTap: () => _launchURL('https://example.com/terms'),
    );
  }

  Widget _buildContactSupportTile() {
    return ListTile(
      leading: const Icon(Icons.email),
      title: const Text('Contact Support'),
      onTap: () => _launchURL('mailto:support@example.com'),
    );
  }


  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Follow system setting';
      case ThemeMode.light:
        return 'Always light theme';
      case ThemeMode.dark:
        return 'Always dark theme';
    }
  }

  String _getColorName(Color color) {
    if (color == Colors.deepPurple) return 'Deep Purple';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.green) return 'Green';
    if (color == Colors.orange) return 'Orange';
    if (color == Colors.red) return 'Red';
    return 'Custom';
  }

  void _showColorPicker(SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Choose Primary Color',
            style: TextStyle(fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: ResponsiveUtils.getResponsiveIconSize(context, 6),
                runSpacing: ResponsiveUtils.getResponsiveIconSize(context, 6),
                children: [
                  Colors.deepPurple,
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                  Colors.red,
                  Colors.teal,
                  Colors.indigo,
                  Colors.pink,
                ].map((color) {
                  return InkWell(
                    onTap: () {
                      settingsProvider.setPrimaryColor(color);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: ResponsiveUtils.getResponsiveIconSize(context, 32),
                      height: ResponsiveUtils.getResponsiveIconSize(context, 32),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: settingsProvider.primaryColor == color
                              ? Colors.white
                              : Colors.grey,
                          width: ResponsiveUtils.getResponsiveIconSize(context, 1.5),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showExportOptions() {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: ResponsiveUtils.getResponsiveCardPadding(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share Profile'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement profile sharing
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
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Export as PDF'),
                onTap: () async {
                  Navigator.pop(context);
                  await _exportAsPdf(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImportOptions() {
    // TODO: Implement import options
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import functionality coming soon!')),
    );
  }

  Future<void> _createBackup() async {
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final profile = profileProvider.profile;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Creating backup...')),
        );
      }

      final backupFile = await BackupService.createBackup(profile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Backup created: ${backupFile.path.split('/').last}'),
            action: SnackBarAction(
              label: 'Share',
              onPressed: () => BackupService.shareBackup(profile),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating backup: $e')),
        );
      }
    }
  }

  Future<void> _showRestoreOptions() async {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restore Backup'),
          content: const Text(
            'Select a backup file to restore your profile data.'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _pickAndRestoreBackup();
              },
              child: const Text('Select File'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickAndRestoreBackup() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowedExtensions: ['json'], // Assuming backup is JSON
      );

      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        await _restoreBackup(filePath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting file: $e')),
        );
      }
    }
  }

  Future<void> _restoreBackup(String filePath) async {
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restoring backup...')),
        );
      }

      final restoredProfile = await BackupService.restoreFromBackup(filePath);

      if (mounted) {
        profileProvider.updateProfile(restoredProfile);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile restored successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error restoring backup: $e')),
        );
      }
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch URL')),
        );
      }
    }
  }

  Future<void> _exportAsPdf(BuildContext context) async {
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final profile = profileProvider.profile;

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

  Widget _buildPrivacyTile(String title, IconData icon, VoidCallback onTap) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final profile = profileProvider.profile;
        bool isVisible = _getVisibilityValue(profile, title);

        return SwitchListTile(
          secondary: Icon(icon, color: Theme.of(context).primaryColor),
          title: Text(title),
          subtitle: Text(isVisible ? 'Visible' : 'Hidden'),
          value: isVisible,
          onChanged: (value) {
            _toggleVisibility(title.toLowerCase().replaceAll(' ', ''));
          },
        );
      },
    );
  }

  bool _getVisibilityValue(Profile profile, String title) {
    switch (title) {
      case 'Personal Information':
        return profile.isPersonalInfoVisible;
      case 'Skills':
        return profile.areSkillsVisible;
      case 'Experience':
        return profile.areExperiencesVisible;
      case 'Education':
        return profile.isEducationVisible;
      case 'Projects':
        return profile.areProjectsVisible;
      case 'Social Links':
        return profile.areSocialLinksVisible;
      case 'Achievements':
        return profile.areAchievementsVisible;
      case 'Testimonials':
        return profile.areTestimonialsVisible;
      default:
        return true;
    }
  }

  void _toggleVisibility(String key) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final profile = profileProvider.profile;

    switch (key) {
      case 'personalinformation':
        profileProvider.updateVisibility(isPersonalInfoVisible: !profile.isPersonalInfoVisible);
        break;
      case 'skills':
        profileProvider.updateVisibility(areSkillsVisible: !profile.areSkillsVisible);
        break;
      case 'experience':
        profileProvider.updateVisibility(areExperiencesVisible: !profile.areExperiencesVisible);
        break;
      case 'education':
        profileProvider.updateVisibility(isEducationVisible: !profile.isEducationVisible);
        break;
      case 'projects':
        profileProvider.updateVisibility(areProjectsVisible: !profile.areProjectsVisible);
        break;
      case 'sociallinks':
        profileProvider.updateVisibility(areSocialLinksVisible: !profile.areSocialLinksVisible);
        break;
      case 'achievements':
        profileProvider.updateVisibility(areAchievementsVisible: !profile.areAchievementsVisible);
        break;
      case 'testimonials':
        profileProvider.updateVisibility(areTestimonialsVisible: !profile.areTestimonialsVisible);
        break;
    }
  }

  Widget _buildAnalyticsTile() {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final profile = profileProvider.profile;
        return ListTile(
          leading: const Icon(Icons.analytics, color: Colors.blue),
          title: const Text('Profile Views'),
          subtitle: Text('Total Views: ${profile.viewCount}\nLast View: ${profile.viewHistory.isNotEmpty ? profile.viewHistory.last.toLocal().toString().split(' ')[0] : 'None'}'),
          onTap: () => _showViewHistory(context, profile),
        );
      },
    );
  }

  void _showViewHistory(BuildContext context, Profile profile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('View History'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: profile.viewHistory.length,
              itemBuilder: (context, index) {
                final date = profile.viewHistory[index];
                return ListTile(
                  title: Text('View ${index + 1}'),
                  subtitle: Text(date.toLocal().toString()),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}