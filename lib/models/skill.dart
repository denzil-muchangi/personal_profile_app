enum SkillLevel { beginner, intermediate, advanced, expert }

class Skill {
  String name;
  SkillLevel level;
  String category; // e.g., "Programming", "Design", "Language"

  Skill({
    required this.name,
    required this.level,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level.index,
      'category': category,
    };
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] ?? '',
      level: SkillLevel.values[json['level'] ?? 0],
      category: json['category'] ?? '',
    );
  }

  String get levelText {
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

  double get levelPercentage {
    switch (level) {
      case SkillLevel.beginner:
        return 0.25;
      case SkillLevel.intermediate:
        return 0.5;
      case SkillLevel.advanced:
        return 0.75;
      case SkillLevel.expert:
        return 1.0;
    }
  }

  Skill copyWith({
    String? name,
    SkillLevel? level,
    String? category,
  }) {
    return Skill(
      name: name ?? this.name,
      level: level ?? this.level,
      category: category ?? this.category,
    );
  }
}