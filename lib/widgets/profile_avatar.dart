import 'dart:io';
import 'package:flutter/material.dart';
import '../services/image_service.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imagePath;
  final String name;
  final double radius;
  final bool showGlow;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.imagePath,
    required this.name,
    this.radius = 55,
    this.showGlow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: showGlow ? BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ) : null,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.white,
          backgroundImage: imagePath != null
              ? FileImage(File(imagePath!))
              : null,
          child: imagePath == null
              ? Container(
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
                      ImageService.getAvatarText(name),
                      style: TextStyle(
                        fontSize: radius * 0.47,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}