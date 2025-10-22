import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../models/profile.dart';
import '../models/skill.dart';
import '../models/experience.dart';
import '../models/education.dart';
import '../models/project.dart';
import '../models/achievement.dart';
import '../models/testimonial.dart';

class PdfService {
  static Future<void> generateAndPrintProfile(Profile profile) async {
    try {
      final pdf = await _generateProfilePdf(profile);
      await Printing.layoutPdf(
        onLayout: (format) => pdf.save(),
      );
    } catch (e) {
      throw Exception('Failed to generate and print PDF: $e');
    }
  }

  static Future<File> generateProfilePdfFile(Profile profile) async {
    try {
      final pdf = await _generateProfilePdf(profile);
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/profile_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());
      return file;
    } catch (e) {
      throw Exception('Failed to generate PDF file: $e');
    }
  }

  static Future<pw.Document> _generateProfilePdf(Profile profile) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _buildHeader(profile),
          pw.SizedBox(height: 20),
          _buildPersonalInfoSection(profile),
          pw.SizedBox(height: 20),
          _buildSkillsSection(profile),
          pw.SizedBox(height: 20),
          _buildExperienceSection(profile),
          pw.SizedBox(height: 20),
          _buildEducationSection(profile),
          pw.SizedBox(height: 20),
          _buildProjectsSection(profile),
          pw.SizedBox(height: 20),
          _buildAchievementsSection(profile),
          pw.SizedBox(height: 20),
          _buildTestimonialsSection(profile),
          pw.SizedBox(height: 20),
          _buildContactSection(profile),
        ],
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader(Profile profile) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.deepPurple,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(
            width: 80,
            height: 80,
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              shape: pw.BoxShape.circle,
            ),
            child: pw.Center(
              child: pw.Text(
                profile.personalInfo.fullName.isNotEmpty
                    ? profile.personalInfo.fullName[0].toUpperCase()
                    : 'U',
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.deepPurple,
                ),
              ),
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Text(
            profile.personalInfo.fullName,
            style: pw.TextStyle(
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            profile.personalInfo.professionalTitle,
            style: pw.TextStyle(
              fontSize: 16,
              color: PdfColors.white,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPersonalInfoSection(Profile profile) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Icon(pw.IconData(0xe491), color: PdfColors.deepPurple, size: 20),
              pw.SizedBox(width: 8),
              pw.Text(
                'About',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.deepPurple,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            profile.personalInfo.bio,
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 10),
          _buildContactInfo(profile),
        ],
      ),
    );
  }

  static pw.Widget _buildContactInfo(Profile profile) {
    return pw.Column(
      children: [
        _buildContactRow(0xe0be, profile.personalInfo.email),
        pw.SizedBox(height: 5),
        _buildContactRow(0xe0cd, profile.personalInfo.phone),
        pw.SizedBox(height: 5),
        _buildContactRow(0xe0c8, profile.personalInfo.location),
      ],
    );
  }

  static pw.Widget _buildContactRow(int iconCode, String text) {
    return pw.Row(
      children: [
        pw.Icon(pw.IconData(iconCode), color: PdfColors.grey600, size: 14),
        pw.SizedBox(width: 8),
        pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey800,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSkillsSection(Profile profile) {
    if (profile.skills.isEmpty) return pw.Container();

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Icon(pw.IconData(0xe838), color: PdfColors.deepPurple, size: 20),
              pw.SizedBox(width: 8),
              pw.Text(
                'Skills & Expertise',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.deepPurple,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Wrap(
            children: profile.skills.map((skill) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(right: 8, bottom: 8),
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: pw.BoxDecoration(
                  color: PdfColors.deepPurple100,
                  borderRadius: pw.BorderRadius.circular(12),
                  border: pw.Border.all(color: PdfColors.deepPurple300),
                ),
                child: pw.Text(
                  '${skill.name} (${_getSkillLevelText(skill.level)})',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.deepPurple,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildExperienceSection(Profile profile) {
    if (profile.experiences.isEmpty) return pw.Container();

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Icon(pw.IconData(0xe8f9), color: PdfColors.deepPurple, size: 20),
              pw.SizedBox(width: 8),
              pw.Text(
                'Experience',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.deepPurple,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          ...profile.experiences.map((experience) {
            return _buildExperienceCard(experience);
          }),
        ],
      ),
    );
  }

  static pw.Widget _buildExperienceCard(Experience experience) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                experience.position,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                experience.duration,
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            experience.companyName,
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            experience.description,
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildEducationSection(Profile profile) {
    if (profile.education.isEmpty) return pw.Container();

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Icon(pw.IconData(0xe80c), color: PdfColors.deepPurple, size: 20),
              pw.SizedBox(width: 8),
              pw.Text(
                'Education',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.deepPurple,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          _buildEducationCard(profile.education.first),
        ],
      ),
    );
  }

  static pw.Widget _buildEducationCard(Education education) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            education.degreeWithField,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            education.institutionName,
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            education.duration,
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildProjectsSection(Profile profile) {
    if (profile.projects.isEmpty) return pw.Container();

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Icon(pw.IconData(0xe2c7), color: PdfColors.deepPurple, size: 20),
              pw.SizedBox(width: 8),
              pw.Text(
                'Featured Projects',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.deepPurple,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          ...profile.featuredProjects.map((project) {
            return _buildProjectCard(project);
          }),
        ],
      ),
    );
  }

  static pw.Widget _buildProjectCard(Project project) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            project.name,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            project.description,
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Wrap(
            children: project.technologies.map((tech) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(right: 4, bottom: 4),
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: pw.BoxDecoration(
                  color: PdfColors.deepPurple50,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(
                  tech,
                  style: pw.TextStyle(
                    fontSize: 8,
                    color: PdfColors.deepPurple,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildAchievementsSection(Profile profile) {
    if (profile.achievements.isEmpty) return pw.Container();

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Icon(pw.IconData(0xe8f4), color: PdfColors.deepPurple, size: 20),
              pw.SizedBox(width: 8),
              pw.Text(
                'Achievements & Certifications',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.deepPurple,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          ...profile.achievements.map((achievement) {
            return _buildAchievementCard(achievement);
          }),
        ],
      ),
    );
  }

  static pw.Widget _buildAchievementCard(Achievement achievement) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Row(
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.all(6),
            decoration: pw.BoxDecoration(
              color: PdfColors.deepPurple100,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Text(
              '🏆',
              style: const pw.TextStyle(fontSize: 12),
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  achievement.title,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  achievement.issuer,
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          if (achievement.isVerified)
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: pw.BoxDecoration(
                color: PdfColors.green100,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(
                'Verified',
                style: pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.green,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget _buildTestimonialsSection(Profile profile) {
    if (profile.testimonials.isEmpty) return pw.Container();

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Icon(pw.IconData(0xe7ef), color: PdfColors.deepPurple, size: 20),
              pw.SizedBox(width: 8),
              pw.Text(
                'Testimonials',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.deepPurple,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          ...profile.testimonials.map((testimonial) {
            return _buildTestimonialCard(testimonial);
          }),
        ],
      ),
    );
  }

  static pw.Widget _buildTestimonialCard(Testimonial testimonial) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 30,
                height: 30,
                decoration: pw.BoxDecoration(
                  color: PdfColors.deepPurple100,
                  shape: pw.BoxShape.circle,
                ),
                child: pw.Center(
                  child: pw.Text(
                    testimonial.name.isNotEmpty ? testimonial.name[0].toUpperCase() : 'U',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.deepPurple,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Text(
                testimonial.name,
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Spacer(),
              pw.Text(
                testimonial.ratingText,
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.amber,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            '"${testimonial.message}"',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey700,
              fontStyle: pw.FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildContactSection(Profile profile) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Icon(pw.IconData(0xe80b), color: PdfColors.deepPurple, size: 20),
              pw.SizedBox(width: 8),
              pw.Text(
                'Connect',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.deepPurple,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          ...profile.socialLinks.map((socialLink) {
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 5),
              child: pw.Row(
                children: [
                  pw.Text(
                    '• ${socialLink.displayName}: ${socialLink.url}',
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  static String _getSkillLevelText(SkillLevel level) {
    switch (level) {
      case SkillLevel.beginner:
        return 'Beginner';
      case SkillLevel.intermediate:
        return 'Intermediate';
      case SkillLevel.advanced:
        return 'Advanced';
      case SkillLevel.expert:
        return 'Expert';
    }
  }
}