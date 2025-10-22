import 'package:flutter/foundation.dart';
import '../models/profile.dart';
import '../models/personal_info.dart';
import '../models/skill.dart';
import '../models/experience.dart';
import '../models/education.dart';
import '../models/project.dart';
import '../models/social_link.dart';
import '../models/achievement.dart';
import '../models/testimonial.dart';
import '../services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  Profile _profile = ProfileService.defaultProfile;
  bool _isLoading = false;

  Profile get profile => _profile;
  bool get isLoading => _isLoading;

  ProfileProvider() {
    loadProfile();
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _profile = await ProfileService.loadProfile();
    } catch (e) {
      debugPrint('Error loading profile: $e');
      _profile = ProfileService.defaultProfile;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      await ProfileService.saveProfile(_profile);
    } catch (e) {
      debugPrint('Error saving profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateProfile(Profile profile) {
    _profile = profile;
    notifyListeners();
  }

  void updatePersonalInfo(PersonalInfo personalInfo) {
    _profile = _profile.copyWith(personalInfo: personalInfo);
    notifyListeners();
  }

  void updateSkills(List<Skill> skills) {
    _profile = _profile.copyWith(skills: skills);
    notifyListeners();
  }

  void updateExperiences(List<Experience> experiences) {
    _profile = _profile.copyWith(experiences: experiences);
    notifyListeners();
  }

  void updateEducation(List<Education> education) {
    _profile = _profile.copyWith(education: education);
    notifyListeners();
  }

  void updateProjects(List<Project> projects) {
    _profile = _profile.copyWith(projects: projects);
    notifyListeners();
  }

  void updateSocialLinks(List<SocialLink> socialLinks) {
    _profile = _profile.copyWith(socialLinks: socialLinks);
    notifyListeners();
  }

  void addSkill(Skill skill) {
    _profile = _profile.copyWith(
      skills: [..._profile.skills, skill],
    );
    notifyListeners();
  }

  void removeSkill(Skill skill) {
    _profile = _profile.copyWith(
      skills: _profile.skills.where((s) => s != skill).toList(),
    );
    notifyListeners();
  }

  void addExperience(Experience experience) {
    _profile = _profile.copyWith(
      experiences: [..._profile.experiences, experience],
    );
    notifyListeners();
  }

  void removeExperience(Experience experience) {
    _profile = _profile.copyWith(
      experiences: _profile.experiences.where((e) => e != experience).toList(),
    );
    notifyListeners();
  }

  void addEducation(Education education) {
    _profile = _profile.copyWith(
      education: [..._profile.education, education],
    );
    notifyListeners();
  }

  void removeEducation(Education education) {
    _profile = _profile.copyWith(
      education: _profile.education.where((e) => e != education).toList(),
    );
    notifyListeners();
  }

  void addProject(Project project) {
    _profile = _profile.copyWith(
      projects: [..._profile.projects, project],
    );
    notifyListeners();
  }

  void removeProject(Project project) {
    _profile = _profile.copyWith(
      projects: _profile.projects.where((p) => p != project).toList(),
    );
    notifyListeners();
  }

  void addSocialLink(SocialLink socialLink) {
    _profile = _profile.copyWith(
      socialLinks: [..._profile.socialLinks, socialLink],
    );
    notifyListeners();
  }

  void removeSocialLink(SocialLink socialLink) {
    _profile = _profile.copyWith(
      socialLinks: _profile.socialLinks.where((s) => s != socialLink).toList(),
    );
    notifyListeners();
  }

  void updateAchievements(List<Achievement> achievements) {
    _profile = _profile.copyWith(achievements: achievements);
    notifyListeners();
  }

  void updateTestimonials(List<Testimonial> testimonials) {
    _profile = _profile.copyWith(testimonials: testimonials);
    notifyListeners();
  }

  void addAchievement(Achievement achievement) {
    _profile = _profile.copyWith(
      achievements: [..._profile.achievements, achievement],
    );
    notifyListeners();
  }

  void removeAchievement(Achievement achievement) {
    _profile = _profile.copyWith(
      achievements: _profile.achievements.where((a) => a != achievement).toList(),
    );
    notifyListeners();
  }

  void addTestimonial(Testimonial testimonial) {
    _profile = _profile.copyWith(
      testimonials: [..._profile.testimonials, testimonial],
    );
    notifyListeners();
  }

  void removeTestimonial(Testimonial testimonial) {
    _profile = _profile.copyWith(
      testimonials: _profile.testimonials.where((t) => t != testimonial).toList(),
    );
    notifyListeners();
  }
}