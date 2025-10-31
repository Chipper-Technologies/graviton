import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graviton/models/changelog_entry.dart';

/// Represents a complete changelog for a version
class ChangelogVersion {
  final String version;
  final DateTime releaseDate;
  final String title;
  final List<ChangelogEntry> entries;

  const ChangelogVersion({
    required this.version,
    required this.releaseDate,
    required this.title,
    required this.entries,
  });

  /// Create from Firestore document
  factory ChangelogVersion.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return ChangelogVersion(
      version: doc.id,
      releaseDate:
          (data['releaseDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      title: data['title'] as String? ?? 'Version ${doc.id}',
      entries:
          (data['entries'] as List<dynamic>?)
              ?.map((e) => ChangelogEntry.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Create from map data
  factory ChangelogVersion.fromMap(Map<String, dynamic> map) {
    return ChangelogVersion(
      version: map['version'] as String? ?? '',
      releaseDate: map['releaseDate'] is Timestamp
          ? (map['releaseDate'] as Timestamp).toDate()
          : DateTime.tryParse(map['releaseDate'] as String? ?? '') ??
                DateTime.now(),
      title: map['title'] as String? ?? '',
      entries:
          (map['entries'] as List<dynamic>?)
              ?.map((e) => ChangelogEntry.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convert to Firestore document data
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'releaseDate': Timestamp.fromDate(releaseDate),
      'entries': entries.map((e) => e.toMap()).toList(),
    };
  }

  /// Get entries by category
  List<ChangelogEntry> getEntriesByCategory(String category) {
    return entries.where((entry) => entry.category == category).toList();
  }

  /// Get all added features
  List<ChangelogEntry> get addedFeatures => getEntriesByCategory('added');

  /// Get all improvements
  List<ChangelogEntry> get improvements => getEntriesByCategory('improved');

  /// Get all fixes
  List<ChangelogEntry> get fixes => getEntriesByCategory('fixed');

  /// Check if this version has any entries
  bool get hasEntries => entries.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChangelogVersion &&
        other.version == version &&
        other.releaseDate == releaseDate &&
        other.title == title &&
        other.entries.length == entries.length &&
        other.entries.every((entry) => entries.contains(entry));
  }

  @override
  int get hashCode =>
      version.hashCode ^
      releaseDate.hashCode ^
      title.hashCode ^
      entries.hashCode;

  @override
  String toString() {
    return 'ChangelogVersion(version: $version, releaseDate: $releaseDate, title: $title, entries: ${entries.length})';
  }
}
