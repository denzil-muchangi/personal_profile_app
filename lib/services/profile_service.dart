import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';
import '../models/personal_info.dart';
import '../models/skill.dart';
import '../models/experience.dart';
import '../models/education.dart';
import '../models/project.dart';
import '../models/social_link.dart';
import '../models/achievement.dart';
import '../models/testimonial.dart';

class ProfileService {
  static const String _profileKey = 'profile_data';

  // Default profile data for first-time users
  static Profile get defaultProfile {
    return Profile(
      personalInfo: PersonalInfo(
        fullName: 'John Doe',
        professionalTitle: 'Software Developer',
        bio: 'Passionate software developer with expertise in mobile and web development. Love creating innovative solutions and learning new technologies.',
        email: 'john.doe@example.com',
        phone: '+1 (555) 123-4567',
        location: 'San Francisco, CA',
        dateOfBirth: DateTime(1990, 1, 1),
      ),
      skills: [
        Skill(name: 'Flutter', level: SkillLevel.expert, category: 'Mobile Development'),
        Skill(name: 'Dart', level: SkillLevel.expert, category: 'Programming'),
        Skill(name: 'React', level: SkillLevel.advanced, category: 'Web Development'),
        Skill(name: 'JavaScript', level: SkillLevel.advanced, category: 'Programming'),
        Skill(name: 'Python', level: SkillLevel.intermediate, category: 'Programming'),
        Skill(name: 'UI/UX Design', level: SkillLevel.intermediate, category: 'Design'),
      ],
      experiences: [
        Experience(
          companyName: 'Tech Solutions Inc.',
          position: 'Senior Flutter Developer',
          description: 'Lead mobile app development using Flutter. Mentored junior developers and implemented best practices.',
          startDate: DateTime(2022, 1, 1),
          location: 'San Francisco, CA',
          achievements: [
            'Developed 5+ production apps with 100k+ downloads',
            'Reduced app loading time by 40%',
            'Led team of 3 developers',
          ],
        ),
        Experience(
          companyName: 'StartupXYZ',
          position: 'Mobile Developer',
          description: 'Developed cross-platform mobile applications using React Native and Flutter.',
          startDate: DateTime(2020, 6, 1),
          endDate: DateTime(2021, 12, 31),
          location: 'Remote',
          achievements: [
            'Built MVP in 3 months',
            'Implemented push notifications',
            'Integrated payment systems',
          ],
        ),
      ],
      education: [
        Education(
          institutionName: 'University of California',
          degree: 'Bachelor of Science',
          fieldOfStudy: 'Computer Science',
          startDate: DateTime(2016, 9, 1),
          endDate: DateTime(2020, 5, 15),
          location: 'Berkeley, CA',
          gpa: 3.8,
          achievements: [
            'Dean\'s List for 3 semesters',
            'President of Computer Science Club',
            'Teaching Assistant for Data Structures',
          ],
        ),
      ],
      projects: [
        Project(
          name: 'Personal Profile App',
          description: 'A comprehensive personal profile application built with Flutter featuring multiple sections and modern design.',
          technologies: ['Flutter', 'Dart', 'Material Design', 'Provider'],
          images: [],
          createdAt: DateTime.now(),
          isFeatured: true,
        ),
        Project(
          name: 'E-commerce Mobile App',
          description: 'Full-featured e-commerce application with payment integration, user authentication, and admin panel.',
          technologies: ['Flutter', 'Firebase', 'Stripe', 'Provider'],
          images: [],
          createdAt: DateTime(2023, 8, 1),
          isFeatured: true,
        ),
      ],
      socialLinks: [
        SocialLink(
          url: 'https://github.com/johndoe',
          platform: SocialPlatform.github,
        ),
        SocialLink(
          url: 'https://linkedin.com/in/johndoe',
          platform: SocialPlatform.linkedin,
        ),
        SocialLink(
          url: 'https://johndoe.dev',
          platform: SocialPlatform.website,
        ),
      ],
      achievements: [
        Achievement(
          id: '1',
          title: 'Flutter Developer Certification',
          description: 'Certified Flutter mobile app developer with expertise in Dart and Firebase',
          issuer: 'Google Developers',
          dateEarned: DateTime(2023, 6, 15),
          type: AchievementType.certification,
          isVerified: true,
        ),
        Achievement(
          id: '2',
          title: 'Best Mobile App Award',
          description: 'Winner of Best Mobile App at TechCrunch Disrupt 2023',
          issuer: 'TechCrunch',
          dateEarned: DateTime(2023, 9, 20),
          type: AchievementType.award,
          isVerified: true,
        ),
      ],
      testimonials: [
        Testimonial(
          id: '1',
          name: 'Sarah Johnson',
          position: 'Product Manager',
          company: 'TechCorp Inc.',
          message: 'John is an exceptional developer who consistently delivers high-quality mobile applications. His expertise in Flutter and attention to detail make him a valuable team member.',
          dateGiven: DateTime(2023, 8, 15),
          rating: 5,
          isVerified: true,
        ),
        Testimonial(
          id: '2',
          name: 'Mike Chen',
          position: 'CTO',
          company: 'StartupXYZ',
          message: 'Working with John was a pleasure. He not only delivered the project on time but also suggested improvements that enhanced the user experience significantly.',
          dateGiven: DateTime(2023, 7, 22),
          rating: 5,
          isVerified: true,
        ),
      ],
    );
  }

  // Save profile to local storage
  static Future<void> saveProfile(Profile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = jsonEncode(profile.toJson());
      await prefs.setString(_profileKey, profileJson);
    } catch (e) {
      throw Exception('Failed to save profile: $e');
    }
  }

  // Load profile from local storage
  static Future<Profile> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);

      if (profileJson == null || profileJson.isEmpty) {
        // Return default profile for first-time users
        await saveProfile(defaultProfile);
        return defaultProfile;
      }

      final profileMap = jsonDecode(profileJson);
      return Profile.fromJson(profileMap);
    } catch (e) {
      // If loading fails, return default profile
      await saveProfile(defaultProfile);
      return defaultProfile;
    }
  }

  // Clear all profile data
  static Future<void> clearProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
    } catch (e) {
      throw Exception('Failed to clear profile: $e');
    }
  }

  // Export profile as JSON string
  static Future<String> exportProfile(Profile profile) async {
    try {
      return jsonEncode(profile.toJson());
    } catch (e) {
      throw Exception('Failed to export profile: $e');
    }
  }

  // Import profile from JSON string
  static Profile importProfile(String profileJson) {
    try {
      final profileMap = jsonDecode(profileJson);
      return Profile.fromJson(profileMap);
    } catch (e) {
      throw Exception('Failed to import profile: $e');
    }
  }
}