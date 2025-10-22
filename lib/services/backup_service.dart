import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/profile.dart';

class BackupService {
  static const String _backupExtension = '.profile_backup';
  static const String _backupPrefix = 'profile_backup_';

  /// Create a backup of the current profile
  static Future<File> createBackup(Profile profile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final fileName = '$_backupPrefix$timestamp$_backupExtension';
      final filePath = '${directory.path}/$fileName';

      final backupData = {
        'version': '1.0',
        'timestamp': timestamp,
        'profile': profile.toJson(),
      };

      final backupFile = File(filePath);
      await backupFile.writeAsString(jsonEncode(backupData));

      return backupFile;
    } catch (e) {
      throw Exception('Failed to create backup: $e');
    }
  }

  /// Restore profile from backup file
  static Future<Profile> restoreFromBackup(String filePath) async {
    try {
      final backupFile = File(filePath);
      if (!await backupFile.exists()) {
        throw Exception('Backup file does not exist');
      }

      final backupContent = await backupFile.readAsString();
      final backupData = jsonDecode(backupContent);

      if (backupData['profile'] == null) {
        throw Exception('Invalid backup file format');
      }

      return Profile.fromJson(backupData['profile']);
    } catch (e) {
      throw Exception('Failed to restore from backup: $e');
    }
  }

  /// Share backup file
  static Future<void> shareBackup(Profile profile) async {
    try {
      final backupFile = await createBackup(profile);
      await Share.shareXFiles(
        [XFile(backupFile.path)],
        text: 'Profile Backup - ${profile.personalInfo.fullName}',
        subject: 'Profile Backup File',
      );
    } catch (e) {
      throw Exception('Failed to share backup: $e');
    }
  }

  /// Get all backup files
  static Future<List<File>> getBackupFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync().whereType<File>().where((file) {
        return file.path.endsWith(_backupExtension);
      }).toList();

      // Sort by creation date (newest first)
      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      return files;
    } catch (e) {
      throw Exception('Failed to get backup files: $e');
    }
  }

  /// Delete backup file
  static Future<void> deleteBackup(String filePath) async {
    try {
      final backupFile = File(filePath);
      if (await backupFile.exists()) {
        await backupFile.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete backup: $e');
    }
  }

  /// Get backup file info
  static Future<Map<String, dynamic>> getBackupInfo(String filePath) async {
    try {
      final backupFile = File(filePath);
      if (!await backupFile.exists()) {
        throw Exception('Backup file does not exist');
      }

      final backupContent = await backupFile.readAsString();
      final backupData = jsonDecode(backupContent);

      final profile = Profile.fromJson(backupData['profile']);

      return {
        'fileName': backupFile.path.split('/').last,
        'fileSize': await backupFile.length(),
        'createdDate': backupData['timestamp'],
        'profileName': profile.personalInfo.fullName,
        'profileTitle': profile.personalInfo.professionalTitle,
        'totalSkills': profile.skills.length,
        'totalExperience': profile.experiences.length,
        'totalProjects': profile.projects.length,
        'totalAchievements': profile.achievements.length,
        'totalTestimonials': profile.testimonials.length,
      };
    } catch (e) {
      throw Exception('Failed to get backup info: $e');
    }
  }

  /// Clean old backups (keep only last 10)
  static Future<void> cleanOldBackups() async {
    try {
      final backupFiles = await getBackupFiles();
      if (backupFiles.length > 10) {
        final filesToDelete = backupFiles.skip(10);
        for (final file in filesToDelete) {
          await deleteBackup(file.path);
        }
      }
    } catch (e) {
      throw Exception('Failed to clean old backups: $e');
    }
  }

  /// Export profile as JSON string
  static String exportProfileAsJson(Profile profile) {
    final exportData = {
      'version': '1.0',
      'exportDate': DateTime.now().toIso8601String(),
      'profile': profile.toJson(),
    };

    return jsonEncode(exportData);
  }

  /// Import profile from JSON string
  static Profile importProfileFromJson(String jsonData) {
    try {
      final importData = jsonDecode(jsonData);

      if (importData['profile'] == null) {
        throw Exception('Invalid import file format');
      }

      return Profile.fromJson(importData['profile']);
    } catch (e) {
      throw Exception('Failed to import profile: $e');
    }
  }

  /// Validate backup file
  static Future<bool> validateBackupFile(String filePath) async {
    try {
      final backupFile = File(filePath);
      if (!await backupFile.exists()) {
        return false;
      }

      final backupContent = await backupFile.readAsString();
      final backupData = jsonDecode(backupContent);

      return backupData['profile'] != null && backupData['version'] != null;
    } catch (e) {
      return false;
    }
  }

  /// Get backup file size in human readable format
  static String getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Format date for display
  static String formatBackupDate(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp;
    }
  }
}