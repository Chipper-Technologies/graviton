import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graviton/models/changelog_entry.dart';
import '../enums/changelog_category.dart';

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

    // Handle both Timestamp and String date formats
    DateTime releaseDate;
    final releaseDateData = data['releaseDate'];
    if (releaseDateData is Timestamp) {
      releaseDate = releaseDateData.toDate();
    } else if (releaseDateData is String) {
      releaseDate = DateTime.tryParse(releaseDateData) ?? DateTime.now();
    } else {
      releaseDate = DateTime.now();
    }

    // Handle both single entry and array of entries
    List<ChangelogEntry> entries = [];
    final entriesData = data['entries'];
    if (entriesData is List<dynamic>) {
      // Array format (correct format)
      entries = entriesData
          .map((e) => ChangelogEntry.fromMap(e as Map<String, dynamic>))
          .toList();
    } else if (entriesData is Map<String, dynamic>) {
      // Single object format (fix for current data)
      entries = [ChangelogEntry.fromMap(entriesData)];
    }

    return ChangelogVersion(
      version: doc.id,
      releaseDate: releaseDate,
      title: data['title'] as String? ?? 'Version ${doc.id}',
      entries: entries,
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
  List<ChangelogEntry> getEntriesByCategory(ChangelogCategory category) {
    return entries.where((entry) => entry.category == category).toList();
  }

  /// Get all added features
  List<ChangelogEntry> get addedFeatures =>
      getEntriesByCategory(ChangelogCategory.added);

  /// Get all improvements
  List<ChangelogEntry> get improvements =>
      getEntriesByCategory(ChangelogCategory.improved);

  /// Get all fixes
  List<ChangelogEntry> get fixes =>
      getEntriesByCategory(ChangelogCategory.fixed);

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
