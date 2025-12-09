/// Metadata for custom scenarios
class ScenarioMetadata {
  final String name;
  final String description;
  final String? author;
  final DateTime createdAt;
  final String educationalFocus;
  final List<String> tags;
  final String difficulty;

  const ScenarioMetadata({
    required this.name,
    required this.description,
    this.author,
    required this.createdAt,
    required this.educationalFocus,
    required this.tags,
    required this.difficulty,
  });

  factory ScenarioMetadata.fromJson(Map<String, dynamic> json) {
    return ScenarioMetadata(
      name: json['name'] as String,
      description: json['description'] as String,
      author: json['author'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      educationalFocus: json['educationalFocus'] as String,
      tags: List<String>.from(json['tags']),
      difficulty: json['difficulty'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      if (author != null) 'author': author,
      'createdAt': createdAt.toIso8601String(),
      'educationalFocus': educationalFocus,
      'tags': tags,
      'difficulty': difficulty,
    };
  }
}
