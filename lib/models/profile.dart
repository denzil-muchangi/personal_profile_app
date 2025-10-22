import 'personal_info.dart';
import 'skill.dart';
import 'experience.dart';
import 'education.dart';
import 'project.dart';
import 'social_link.dart';
import 'achievement.dart';
import 'testimonial.dart';

class Profile {
  PersonalInfo personalInfo;
  List<Skill> skills;
  List<Experience> experiences;
  List<Education> education;
  List<Project> projects;
  List<SocialLink> socialLinks;
  List<Achievement> achievements;
  List<Testimonial> testimonials;
  String theme; // 'light', 'dark', 'system'
  String primaryColor;

  Profile({
    required this.personalInfo,
    required this.skills,
    required this.experiences,
    required this.education,
    required this.projects,
    required this.socialLinks,
    required this.achievements,
    required this.testimonials,
    this.theme = 'system',
    this.primaryColor = 'deepPurple',
  });

  Map<String, dynamic> toJson() {
    return {
      'personalInfo': personalInfo.toJson(),
      'skills': skills.map((skill) => skill.toJson()).toList(),
      'experiences': experiences.map((exp) => exp.toJson()).toList(),
      'education': education.map((edu) => edu.toJson()).toList(),
      'projects': projects.map((project) => project.toJson()).toList(),
      'socialLinks': socialLinks.map((link) => link.toJson()).toList(),
      'achievements': achievements.map((achievement) => achievement.toJson()).toList(),
      'testimonials': testimonials.map((testimonial) => testimonial.toJson()).toList(),
      'theme': theme,
      'primaryColor': primaryColor,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      personalInfo: PersonalInfo.fromJson(json['personalInfo'] ?? {}),
      skills: (json['skills'] as List<dynamic>?)
              ?.map((skill) => Skill.fromJson(skill))
              .toList() ??
          [],
      experiences: (json['experiences'] as List<dynamic>?)
              ?.map((exp) => Experience.fromJson(exp))
              .toList() ??
          [],
      education: (json['education'] as List<dynamic>?)
              ?.map((edu) => Education.fromJson(edu))
              .toList() ??
          [],
      projects: (json['projects'] as List<dynamic>?)
              ?.map((project) => Project.fromJson(project))
              .toList() ??
          [],
      socialLinks: (json['socialLinks'] as List<dynamic>?)
              ?.map((link) => SocialLink.fromJson(link))
              .toList() ??
          [],
      achievements: (json['achievements'] as List<dynamic>?)
              ?.map((achievement) => Achievement.fromJson(achievement))
              .toList() ??
          [],
      testimonials: (json['testimonials'] as List<dynamic>?)
              ?.map((testimonial) => Testimonial.fromJson(testimonial))
              .toList() ??
          [],
      theme: json['theme'] ?? 'system',
      primaryColor: json['primaryColor'] ?? 'deepPurple',
    );
  }

  Profile copyWith({
    PersonalInfo? personalInfo,
    List<Skill>? skills,
    List<Experience>? experiences,
    List<Education>? education,
    List<Project>? projects,
    List<SocialLink>? socialLinks,
    List<Achievement>? achievements,
    List<Testimonial>? testimonials,
    String? theme,
    String? primaryColor,
  }) {
    return Profile(
      personalInfo: personalInfo ?? this.personalInfo,
      skills: skills ?? this.skills,
      experiences: experiences ?? this.experiences,
      education: education ?? this.education,
      projects: projects ?? this.projects,
      socialLinks: socialLinks ?? this.socialLinks,
      achievements: achievements ?? this.achievements,
      testimonials: testimonials ?? this.testimonials,
      theme: theme ?? this.theme,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }

  // Helper methods for easy access
  List<Project> get featuredProjects =>
      projects.where((project) => project.isFeatured).toList();

  List<Skill> getSkillsByCategory(String category) =>
      skills.where((skill) => skill.category == category).toList();

  Experience? get currentExperience =>
      experiences.where((exp) => exp.isCurrentPosition).cast<Experience?>().firstOrNull;

  Map<String, List<Skill>> get skillsByCategory {
    final map = <String, List<Skill>>{};
    for (final skill in skills) {
      if (map.containsKey(skill.category)) {
        map[skill.category]!.add(skill);
      } else {
        map[skill.category] = [skill];
      }
    }
    return map;
  }
}