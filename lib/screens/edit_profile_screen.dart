import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/profile.dart';
import '../models/personal_info.dart';
import '../models/skill.dart';
import '../models/experience.dart';
import '../models/education.dart';
import '../models/project.dart';
import '../models/social_link.dart';
import '../providers/profile_provider.dart';
import '../services/image_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late Profile _editedProfile;
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _fullNameController = TextEditingController();
  final _titleController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with a default profile first
    _editedProfile = Profile(
      personalInfo: PersonalInfo(
        fullName: '',
        professionalTitle: '',
        bio: '',
        email: '',
        phone: '',
        location: '',
      ),
      skills: [],
      experiences: [],
      education: [],
      projects: [],
      socialLinks: [],
      achievements: [],
      testimonials: [],
      isPersonalInfoVisible: true,
      areSkillsVisible: true,
      areExperiencesVisible: true,
      isEducationVisible: true,
      areProjectsVisible: true,
      areSocialLinksVisible: true,
      areAchievementsVisible: true,
      areTestimonialsVisible: true,
      viewCount: 0,
      viewHistory: const [],
    );

    // Then update with actual data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      _editedProfile = profileProvider.profile;

      // Initialize controllers with current values
      _fullNameController.text = _editedProfile.personalInfo.fullName;
      _titleController.text = _editedProfile.personalInfo.professionalTitle;
      _bioController.text = _editedProfile.personalInfo.bio;
      _emailController.text = _editedProfile.personalInfo.email;
      _phoneController.text = _editedProfile.personalInfo.phone;
      _locationController.text = _editedProfile.personalInfo.location;
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _titleController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              'Save',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profile Picture Section
                _buildProfilePictureSection(),

                const SizedBox(height: 20),

                // Personal Information Section
                _buildSectionCard(
                  title: 'Personal Information',
                  icon: Icons.person,
                  children: [
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Professional Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your professional title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bioController,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a bio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Skills Section
                _buildSkillsSection(),

                const SizedBox(height: 20),

                // Experience Section
                _buildExperienceSection(),

                const SizedBox(height: 20),

                // Education Section
                _buildEducationSection(),

                const SizedBox(height: 20),

                // Projects Section
                _buildProjectsSection(),

                const SizedBox(height: 20),

                // Social Links Section
                _buildSocialLinksSection(),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return _buildSectionCard(
      title: 'Skills',
      icon: Icons.star,
      children: [
        ..._editedProfile.skills.asMap().entries.map((entry) {
          final skill = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(skill.name),
                ),
                DropdownButton<SkillLevel>(
              value: skill.level,
              onChanged: (SkillLevel? newLevel) {
                if (newLevel != null) {
                  setState(() {
                    _editedProfile = _editedProfile.copyWith(
                      skills: _editedProfile.skills.map((s) {
                        if (s == skill) {
                          return skill.copyWith(level: newLevel);
                        }
                        return s;
                      }).toList(),
                    );
                  });
                }
              },
              items: SkillLevel.values.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(_getSkillLevelText(level)),
                );
              }).toList(),
            ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _editedProfile = _editedProfile.copyWith(
                        skills: _editedProfile.skills.where((s) => s != skill).toList(),
                      );
                    });
                  },
                ),
              ],
            ),
          );
        }),
        ElevatedButton.icon(
          onPressed: _addNewSkill,
          icon: const Icon(Icons.add),
          label: const Text('Add Skill'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceSection() {
    return _buildSectionCard(
      title: 'Experience',
      icon: Icons.work,
      children: [
        ..._editedProfile.experiences.asMap().entries.map((entry) {
          final experience = entry.value;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          experience.position,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _editedProfile = _editedProfile.copyWith(
                              experiences: _editedProfile.experiences.where((e) => e != experience).toList(),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  Text(experience.companyName),
                  const SizedBox(height: 8),
                  Text(experience.description),
                ],
              ),
            ),
          );
        }),
        ElevatedButton.icon(
          onPressed: _addNewExperience,
          icon: const Icon(Icons.add),
          label: const Text('Add Experience'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildEducationSection() {
    return _buildSectionCard(
      title: 'Education',
      icon: Icons.school,
      children: [
        ..._editedProfile.education.asMap().entries.map((entry) {
          final education = entry.value;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          education.degreeWithField,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _editedProfile = _editedProfile.copyWith(
                              education: _editedProfile.education.where((e) => e != education).toList(),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  Text(education.institutionName),
                  Text(education.duration),
                ],
              ),
            ),
          );
        }),
        ElevatedButton.icon(
          onPressed: _addNewEducation,
          icon: const Icon(Icons.add),
          label: const Text('Add Education'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectsSection() {
    return _buildSectionCard(
      title: 'Projects',
      icon: Icons.folder,
      children: [
        ..._editedProfile.projects.asMap().entries.map((entry) {
          final project = entry.value;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          project.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _editedProfile = _editedProfile.copyWith(
                              projects: _editedProfile.projects.where((p) => p != project).toList(),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  Text(project.description),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: project.technologies.map((tech) {
                      return Chip(
                        label: Text(tech),
                        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        }),
        ElevatedButton.icon(
          onPressed: _addNewProject,
          icon: const Icon(Icons.add),
          label: const Text('Add Project'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLinksSection() {
    return _buildSectionCard(
      title: 'Social Links',
      icon: Icons.link,
      children: [
        ..._editedProfile.socialLinks.asMap().entries.map((entry) {
          final socialLink = entry.value;
          return ListTile(
            leading: Icon(socialLink.icon, color: socialLink.color),
            title: Text(socialLink.displayName),
            subtitle: Text(socialLink.url),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  _editedProfile = _editedProfile.copyWith(
                    socialLinks: _editedProfile.socialLinks.where((s) => s != socialLink).toList(),
                  );
                });
              },
            ),
          );
        }),
        ElevatedButton.icon(
          onPressed: _addNewSocialLink,
          icon: const Icon(Icons.add),
          label: const Text('Add Social Link'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Update personal info
      final updatedPersonalInfo = _editedProfile.personalInfo.copyWith(
        fullName: _fullNameController.text,
        professionalTitle: _titleController.text,
        bio: _bioController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        location: _locationController.text,
      );

      final updatedProfile = _editedProfile.copyWith(
        personalInfo: updatedPersonalInfo,
      );

      Provider.of<ProfileProvider>(context, listen: false).updateProfile(updatedProfile);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      Navigator.pop(context);
    }
  }

  void _addNewSkill() {
    _showAddSkillDialog();
  }

  void _showAddSkillDialog() {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    SkillLevel selectedLevel = SkillLevel.beginner;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Skill'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Skill Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<SkillLevel>(
                value: selectedLevel,
                decoration: const InputDecoration(
                  labelText: 'Skill Level',
                  border: OutlineInputBorder(),
                ),
                items: SkillLevel.values.map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(_getSkillLevelText(level)),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedLevel = value!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && categoryController.text.isNotEmpty) {
                  final newSkill = Skill(
                    name: nameController.text,
                    level: selectedLevel,
                    category: categoryController.text,
                  );
                  setState(() {
                    _editedProfile = _editedProfile.copyWith(
                      skills: [..._editedProfile.skills, newSkill],
                    );
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Skill added successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addNewExperience() {
    _showAddExperienceDialog();
  }

  void _showAddExperienceDialog() {
    final companyController = TextEditingController();
    final positionController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    final achievementsController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Experience'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: positionController,
                  decoration: const InputDecoration(
                    labelText: 'Position',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      startDate = picked;
                    }
                  },
                  child: Text(startDate == null ? 'Select Start Date' : 'Start: ${startDate!.toLocal().toString().split(' ')[0]}'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      endDate = picked;
                    }
                  },
                  child: Text(endDate == null ? 'Select End Date (Optional)' : 'End: ${endDate!.toLocal().toString().split(' ')[0]}'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: achievementsController,
                  decoration: const InputDecoration(
                    labelText: 'Achievements (comma separated)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (companyController.text.isNotEmpty &&
                    positionController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    locationController.text.isNotEmpty &&
                    startDate != null) {
                  final achievements = achievementsController.text.isNotEmpty
                      ? achievementsController.text.split(',').map((s) => s.trim()).toList()
                      : <String>[];
                  final newExperience = Experience(
                    companyName: companyController.text,
                    position: positionController.text,
                    description: descriptionController.text,
                    startDate: startDate!,
                    endDate: endDate,
                    location: locationController.text,
                    achievements: achievements,
                  );
                  setState(() {
                    _editedProfile = _editedProfile.copyWith(
                      experiences: [..._editedProfile.experiences, newExperience],
                    );
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Experience added successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all required fields')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addNewEducation() {
    _showAddEducationDialog();
  }

  void _showAddEducationDialog() {
    final institutionController = TextEditingController();
    final degreeController = TextEditingController();
    final fieldController = TextEditingController();
    final locationController = TextEditingController();
    final gpaController = TextEditingController();
    final achievementsController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Education'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: institutionController,
                  decoration: const InputDecoration(
                    labelText: 'Institution Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: degreeController,
                  decoration: const InputDecoration(
                    labelText: 'Degree',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: fieldController,
                  decoration: const InputDecoration(
                    labelText: 'Field of Study',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: gpaController,
                  decoration: const InputDecoration(
                    labelText: 'GPA (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      startDate = picked;
                    }
                  },
                  child: Text(startDate == null ? 'Select Start Date' : 'Start: ${startDate!.toLocal().toString().split(' ')[0]}'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      endDate = picked;
                    }
                  },
                  child: Text(endDate == null ? 'Select End Date (Optional)' : 'End: ${endDate!.toLocal().toString().split(' ')[0]}'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: achievementsController,
                  decoration: const InputDecoration(
                    labelText: 'Achievements (comma separated)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (institutionController.text.isNotEmpty &&
                    degreeController.text.isNotEmpty &&
                    fieldController.text.isNotEmpty &&
                    locationController.text.isNotEmpty &&
                    startDate != null) {
                  final achievements = achievementsController.text.isNotEmpty
                      ? achievementsController.text.split(',').map((s) => s.trim()).toList()
                      : <String>[];
                  final gpa = gpaController.text.isNotEmpty ? double.tryParse(gpaController.text) : null;
                  final newEducation = Education(
                    institutionName: institutionController.text,
                    degree: degreeController.text,
                    fieldOfStudy: fieldController.text,
                    startDate: startDate!,
                    endDate: endDate,
                    location: locationController.text,
                    gpa: gpa,
                    achievements: achievements,
                  );
                  setState(() {
                    _editedProfile = _editedProfile.copyWith(
                      education: [..._editedProfile.education, newEducation],
                    );
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Education added successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all required fields')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addNewProject() {
    _showAddProjectDialog();
  }

  void _showAddProjectDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final technologiesController = TextEditingController();
    final githubUrlController = TextEditingController();
    final projectUrlController = TextEditingController();
    bool isFeatured = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Project'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: technologiesController,
                  decoration: const InputDecoration(
                    labelText: 'Technologies (comma separated)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: githubUrlController,
                  decoration: const InputDecoration(
                    labelText: 'GitHub URL (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: projectUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Project URL (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Featured Project'),
                  value: isFeatured,
                  onChanged: (value) {
                    isFeatured = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    technologiesController.text.isNotEmpty) {
                  final technologies = technologiesController.text.split(',').map((s) => s.trim()).toList();
                  final newProject = Project(
                    name: nameController.text,
                    description: descriptionController.text,
                    technologies: technologies,
                    images: [],
                    createdAt: DateTime.now(),
                    isFeatured: isFeatured,
                    githubUrl: githubUrlController.text.isNotEmpty ? githubUrlController.text : null,
                    projectUrl: projectUrlController.text.isNotEmpty ? projectUrlController.text : null,
                  );
                  setState(() {
                    _editedProfile = _editedProfile.copyWith(
                      projects: [..._editedProfile.projects, newProject],
                    );
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Project added successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all required fields')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addNewSocialLink() {
    _showAddSocialLinkDialog();
  }

  void _showAddSocialLinkDialog() {
    final urlController = TextEditingController();
    final customNameController = TextEditingController();
    SocialPlatform selectedPlatform = SocialPlatform.website;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Social Link'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<SocialPlatform>(
                  value: selectedPlatform,
                  decoration: const InputDecoration(
                    labelText: 'Platform',
                    border: OutlineInputBorder(),
                  ),
                  items: SocialPlatform.values.map((platform) {
                    return DropdownMenuItem(
                      value: platform,
                      child: Text(platform.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedPlatform = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: customNameController,
                  decoration: const InputDecoration(
                    labelText: 'Custom Name (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (urlController.text.isNotEmpty) {
                  final newSocialLink = SocialLink(
                    url: urlController.text,
                    platform: selectedPlatform,
                    customName: customNameController.text.isNotEmpty ? customNameController.text : null,
                  );
                  setState(() {
                    _editedProfile = _editedProfile.copyWith(
                      socialLinks: [..._editedProfile.socialLinks, newSocialLink],
                    );
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Social link added successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a URL')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  String _getSkillLevelText(SkillLevel level) {
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

  Widget _buildProfilePictureSection() {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final profile = profileProvider.profile;
        final currentImagePath = profile.personalInfo.profileImagePath;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.photo_camera, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    const Text(
                      'Profile Picture',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
                        backgroundImage: currentImagePath != null
                            ? FileImage(File(currentImagePath))
                            : null,
                        child: currentImagePath == null
                            ? Text(
                                ImageService.getAvatarText(profile.personalInfo.fullName),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: ImageService.getAvatarColor(profile.personalInfo.fullName),
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: InkWell(
                            onTap: () => _changeProfilePicture(context, profileProvider),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _changeProfilePicture(context, profileProvider),
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Change Picture'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    if (currentImagePath != null) ...[
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => _removeProfilePicture(context, profileProvider),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text(
                          'Remove',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _changeProfilePicture(BuildContext context, ProfileProvider profileProvider) async {
    try {
      final File? imageFile = await ImageService.showImagePickerOptions(context);

      if (imageFile != null) {
        final updatedPersonalInfo = profileProvider.profile.personalInfo.copyWith(
          profileImagePath: imageFile.path,
        );

        profileProvider.updatePersonalInfo(updatedPersonalInfo);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile picture: $e')),
      );
    }
  }

  Future<void> _removeProfilePicture(BuildContext context, ProfileProvider profileProvider) async {
    try {
      final currentImagePath = profileProvider.profile.personalInfo.profileImagePath;

      if (currentImagePath != null) {
        await ImageService.deleteImage(currentImagePath);
      }

      final updatedPersonalInfo = profileProvider.profile.personalInfo.copyWith(
        profileImagePath: null,
      );

      profileProvider.updatePersonalInfo(updatedPersonalInfo);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture removed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing profile picture: $e')),
      );
    }
  }
}