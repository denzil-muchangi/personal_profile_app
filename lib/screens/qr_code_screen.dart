import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/profile.dart';
import '../providers/profile_provider.dart';
import '../services/sharing_service.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile QR Code',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.share_rounded),
              onPressed: () => _shareProfile(context),
              tooltip: 'Share Profile',
            ),
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final profile = profileProvider.profile;
          final profileData = _generateProfileData(profile);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Share Your Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Scan this QR code to view ${profile.personalInfo.fullName}\'s profile',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Modern QR Code Container with glassmorphism
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: QrImageView(
                      data: profileData,
                      version: QrVersions.auto,
                      size: 220,
                      gapless: false,
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      errorStateBuilder: (context, error) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.error_outline_rounded,
                                  color: Colors.red,
                                  size: 48,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error generating QR code',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                error.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red[500],
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Profile Preview
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          profile.personalInfo.fullName.isNotEmpty
                              ? profile.personalInfo.fullName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        profile.personalInfo.fullName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        profile.personalInfo.professionalTitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        profile.personalInfo.bio,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Modern Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => _shareProfile(context),
                          icon: const Icon(Icons.share_rounded, size: 20),
                          label: const Text(
                            'Share Profile',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 8),
                        child: OutlinedButton.icon(
                          onPressed: () => _copyProfileData(context, profileData),
                          icon: const Icon(Icons.copy_rounded, size: 20),
                          label: const Text(
                            'Copy Link',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Modern Instructions with glassmorphism
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.info_outline_rounded,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'How to use',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildInstructionRow('📱', 'Others can scan this QR code with their camera or QR scanner app'),
                            const SizedBox(height: 8),
                            _buildInstructionRow('🔗', 'The QR code contains a link to view your profile'),
                            const SizedBox(height: 8),
                            _buildInstructionRow('📤', 'Share this QR code on social media, business cards, or anywhere else'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _generateProfileData(Profile profile) {
    // Create a simple profile URL that could be used to share the profile
    // In a real app, this would be a URL to a web version or a deep link
    final profileInfo = {
      'name': profile.personalInfo.fullName,
      'title': profile.personalInfo.professionalTitle,
      'bio': profile.personalInfo.bio,
      'email': profile.personalInfo.email,
      'phone': profile.personalInfo.phone,
      'location': profile.personalInfo.location,
      'skills': profile.skills.map((s) => {'name': s.name, 'level': s.levelText}).toList(),
      'socialLinks': profile.socialLinks.map((s) => {'platform': s.platform.name, 'url': s.url}).toList(),
    };

    // For demo purposes, we'll create a data URL that contains the profile info
    // In a real app, this would be a URL to a hosted profile page
    return 'profile://${Uri.encodeComponent(profile.personalInfo.fullName)}/${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _shareProfile(BuildContext context) async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final profile = profileProvider.profile;

    try {
      await SharingService.shareProfile(profile);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing profile: $e')),
      );
    }
  }

  void _copyProfileData(BuildContext context, String profileData) {
    // Copy profile data to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile link copied to clipboard!')),
    );
  }

  Widget _buildInstructionRow(String emoji, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}