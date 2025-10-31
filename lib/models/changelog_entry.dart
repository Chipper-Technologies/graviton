/// Represents a changelog entry (feature, improvement, or fix)
class ChangelogEntry {
  final String title;
  final String? description;
  final String category; // 'added', 'improved', 'fixed'

  const ChangelogEntry({
    required this.title,
    this.description,
    required this.category,
  });

  /// Create from Firestore document data
  factory ChangelogEntry.fromMap(Map<String, dynamic> map) {
    return ChangelogEntry(
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      category: map['category'] as String? ?? 'added',
    );
  }

  /// Convert to Firestore document data
  Map<String, dynamic> toMap() {
    return {'title': title, 'description': description, 'category': category};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChangelogEntry &&
        other.title == title &&
        other.description == description &&
        other.category == category;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode ^ category.hashCode;

  @override
  String toString() {
    return 'ChangelogEntry(title: $title, description: $description, category: $category)';
  }
}
