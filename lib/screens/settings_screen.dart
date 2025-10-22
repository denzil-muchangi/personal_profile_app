import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/settings_provider.dart';
import '../providers/profile_provider.dart';
import '../services/pdf_service.dart';
import '../services/backup_service.dart';

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

              // Privacy & Security
              _buildSectionHeader('Privacy & Security'),
              _buildAutoSaveTile(settingsProvider),

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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
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
          title: const Text('Choose Primary Color'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: settingsProvider.primaryColor == color
                              ? Colors.white
                              : Colors.grey,
                          width: 2,
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
                onTap: () {
                  Navigator.pop(context);
                  _exportAsPdf(context);
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Creating backup...')),
      );

      final backupFile = await BackupService.createBackup(profile);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Backup created: ${backupFile.path.split('/').last}'),
          action: SnackBarAction(
            label: 'Share',
            onPressed: () => BackupService.shareBackup(profile),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating backup: $e')),
      );
    }
  }

  void _showRestoreOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restore Backup'),
          content: const Text(
            'To restore a backup:\n\n'
            '1. Share a backup file from another device\n'
            '2. Open the shared file in this app\n'
            '3. The profile will be restored automatically\n\n'
            'Note: This feature requires the backup file to be shared with this app.'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showRestoreConfirmationDialog(String filePath, Map<String, dynamic> backupInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restore Backup'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile: ${backupInfo['profileName']}'),
              Text('Title: ${backupInfo['profileTitle']}'),
              Text('Created: ${BackupService.formatBackupDate(backupInfo['createdDate'])}'),
              const SizedBox(height: 8),
              Text('This will replace your current profile data.'),
              Text('Skills: ${backupInfo['totalSkills']}'),
              Text('Experience: ${backupInfo['totalExperience']}'),
              Text('Projects: ${backupInfo['totalProjects']}'),
              Text('Achievements: ${backupInfo['totalAchievements']}'),
              Text('Testimonials: ${backupInfo['totalTestimonials']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _restoreBackup(filePath);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Restore'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _restoreBackup(String filePath) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Restoring backup...')),
      );

      final restoredProfile = await BackupService.restoreFromBackup(filePath);
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

      profileProvider.updateProfile(restoredProfile);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile restored successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error restoring backup: $e')),
      );
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch URL')),
      );
    }
  }

  Future<void> _exportAsPdf(BuildContext context) async {
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final profile = profileProvider.profile;

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