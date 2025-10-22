import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<SearchResult> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _performSearch();
    });
  }

  void _performSearch() {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final profile = profileProvider.profile;

    _searchResults.clear();

    if (_searchQuery.isEmpty) return;

    final query = _searchQuery.toLowerCase();

    // Search in personal info
    if (profile.personalInfo.fullName.toLowerCase().contains(query)) {
      _searchResults.add(SearchResult(
        type: SearchResultType.personalInfo,
        title: 'Personal Information',
        subtitle: profile.personalInfo.fullName,
        data: profile.personalInfo,
      ));
    }

    if (profile.personalInfo.professionalTitle.toLowerCase().contains(query)) {
      _searchResults.add(SearchResult(
        type: SearchResultType.personalInfo,
        title: 'Professional Title',
        subtitle: profile.personalInfo.professionalTitle,
        data: profile.personalInfo,
      ));
    }

    if (profile.personalInfo.bio.toLowerCase().contains(query)) {
      _searchResults.add(SearchResult(
        type: SearchResultType.personalInfo,
        title: 'Bio',
        subtitle: profile.personalInfo.bio,
        data: profile.personalInfo,
      ));
    }

    // Search in skills
    for (final skill in profile.skills) {
      if (skill.name.toLowerCase().contains(query) ||
          skill.category.toLowerCase().contains(query)) {
        _searchResults.add(SearchResult(
          type: SearchResultType.skill,
          title: skill.name,
          subtitle: '${skill.category} • ${skill.levelText}',
          data: skill,
        ));
      }
    }

    // Search in experience
    for (final experience in profile.experiences) {
      if (experience.position.toLowerCase().contains(query) ||
          experience.companyName.toLowerCase().contains(query) ||
          experience.description.toLowerCase().contains(query)) {
        _searchResults.add(SearchResult(
          type: SearchResultType.experience,
          title: experience.position,
          subtitle: '${experience.companyName} • ${experience.duration}',
          data: experience,
        ));
      }
    }

    // Search in education
    for (final education in profile.education) {
      if (education.institutionName.toLowerCase().contains(query) ||
          education.degreeWithField.toLowerCase().contains(query)) {
        _searchResults.add(SearchResult(
          type: SearchResultType.education,
          title: education.degreeWithField,
          subtitle: '${education.institutionName} • ${education.duration}',
          data: education,
        ));
      }
    }

    // Search in projects
    for (final project in profile.projects) {
      if (project.name.toLowerCase().contains(query) ||
          project.description.toLowerCase().contains(query) ||
          project.technologies.any((tech) => tech.toLowerCase().contains(query))) {
        _searchResults.add(SearchResult(
          type: SearchResultType.project,
          title: project.name,
          subtitle: project.description,
          data: project,
        ));
      }
    }

    // Search in achievements
    for (final achievement in profile.achievements) {
      if (achievement.title.toLowerCase().contains(query) ||
          achievement.description.toLowerCase().contains(query) ||
          achievement.issuer.toLowerCase().contains(query)) {
        _searchResults.add(SearchResult(
          type: SearchResultType.achievement,
          title: achievement.title,
          subtitle: '${achievement.issuer} • ${achievement.type.name}',
          data: achievement,
        ));
      }
    }

    // Search in testimonials
    for (final testimonial in profile.testimonials) {
      if (testimonial.name.toLowerCase().contains(query) ||
          testimonial.company.toLowerCase().contains(query) ||
          testimonial.message.toLowerCase().contains(query)) {
        _searchResults.add(SearchResult(
          type: SearchResultType.testimonial,
          title: testimonial.name,
          subtitle: '${testimonial.companyWithPosition} • ${testimonial.ratingText}',
          data: testimonial,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search profile...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          autofocus: true,
        ),
        actions: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults.clear();
                });
              },
            ),
        ],
      ),
      body: _searchQuery.isEmpty
          ? _buildEmptyState()
          : _searchResults.isEmpty
              ? _buildNoResultsState()
              : _buildSearchResults(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Search your profile',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find skills, experiences, projects, and more',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for skills, experiences, or projects',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return _buildSearchResultTile(result);
      },
    );
  }

  Widget _buildSearchResultTile(SearchResult result) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getResultColor(result.type).withValues(alpha: 0.1),
        child: Icon(
          _getResultIcon(result.type),
          color: _getResultColor(result.type),
        ),
      ),
      title: Text(
        result.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(result.subtitle),
      onTap: () => _navigateToResult(result),
    );
  }

  void _navigateToResult(SearchResult result) {
    switch (result.type) {
      case SearchResultType.personalInfo:
        // Scroll to personal info section
        break;
      case SearchResultType.skill:
        // Navigate to skills section or highlight skill
        break;
      case SearchResultType.experience:
        // Navigate to experience section
        break;
      case SearchResultType.education:
        // Navigate to education section
        break;
      case SearchResultType.project:
        // Navigate to projects section
        break;
      case SearchResultType.achievement:
        Navigator.pushNamed(context, '/achievements');
        break;
      case SearchResultType.testimonial:
        Navigator.pushNamed(context, '/testimonials');
        break;
    }
  }

  IconData _getResultIcon(SearchResultType type) {
    switch (type) {
      case SearchResultType.personalInfo:
        return Icons.person;
      case SearchResultType.skill:
        return Icons.star;
      case SearchResultType.experience:
        return Icons.work;
      case SearchResultType.education:
        return Icons.school;
      case SearchResultType.project:
        return Icons.folder;
      case SearchResultType.achievement:
        return Icons.workspace_premium;
      case SearchResultType.testimonial:
        return Icons.people;
    }
  }

  Color _getResultColor(SearchResultType type) {
    switch (type) {
      case SearchResultType.personalInfo:
        return Colors.blue;
      case SearchResultType.skill:
        return Colors.amber;
      case SearchResultType.experience:
        return Colors.green;
      case SearchResultType.education:
        return Colors.purple;
      case SearchResultType.project:
        return Colors.orange;
      case SearchResultType.achievement:
        return Colors.indigo;
      case SearchResultType.testimonial:
        return Colors.teal;
    }
  }
}

class SearchResult {
  final SearchResultType type;
  final String title;
  final String subtitle;
  final dynamic data;

  SearchResult({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.data,
  });
}

enum SearchResultType {
  personalInfo,
  skill,
  experience,
  education,
  project,
  achievement,
  testimonial,
}