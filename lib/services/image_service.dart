import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Pick image from camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        return await _saveImageToAppDirectory(image);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image from camera: $e');
    }
  }

  /// Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        return await _saveImageToAppDirectory(image);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }

  /// Save image to app's document directory
  static Future<File> _saveImageToAppDirectory(XFile image) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
      final String filePath = path.join(appDir.path, fileName);

      final File savedImage = File(filePath);
      await savedImage.writeAsBytes(await image.readAsBytes());

      return savedImage;
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  /// Delete image file
  static Future<bool> deleteImage(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  /// Get image file from path
  static File? getImageFile(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;

    final File imageFile = File(imagePath);
    return imageFile.existsSync() ? imageFile : null;
  }

  /// Show image picker options
  static Future<File?> showImagePickerOptions(BuildContext context) async {
    return showModalBottomSheet<File?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Profile Picture',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.pop(context);
                        final File? image = await pickImageFromCamera();
                        if (image != null) {
                          Navigator.pop(context, image);
                        }
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        Navigator.pop(context);
                        final File? image = await pickImageFromGallery();
                        if (image != null) {
                          Navigator.pop(context, image);
                        }
                      },
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Crop image (placeholder for future implementation)
  static Future<File?> cropImage(File imageFile) async {
    // For now, return the original image
    // In a real app, you would integrate an image cropping library
    return imageFile;
  }

  /// Get image dimensions
  static Future<Size> getImageDimensions(File imageFile) async {
    try {
      final Image image = Image.file(imageFile);
      final ImageStream stream = image.image.resolve(ImageConfiguration.empty);
      final Completer<Size> completer = Completer();

      stream.addListener(ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }));

      return await completer.future;
    } catch (e) {
      throw Exception('Failed to get image dimensions: $e');
    }
  }

  /// Compress image if too large
  static Future<File> compressImage(File imageFile, {int maxSizeKB = 500}) async {
    // For now, return the original file
    // In a real app, you would implement image compression
    return imageFile;
  }

  /// Generate avatar text from name
  static String getAvatarText(String name) {
    if (name.isEmpty) return 'U';

    final nameParts = name.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    }

    return 'U';
  }

  /// Get avatar color based on name
  static Color getAvatarColor(String name) {
    if (name.isEmpty) return Colors.grey;

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
      Colors.amber,
      Colors.lime,
    ];

    final hash = name.codeUnits.reduce((a, b) => a + b);
    return colors[hash % colors.length];
  }
}