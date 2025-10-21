import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/ui_state.dart';

void main() {
  group('Language Selection Tests', () {
    test('should start with null language (system default)', () {
      final uiState = UIState();
      expect(uiState.selectedLanguageCode, isNull);
    });

    test('should be able to set language', () {
      final uiState = UIState();

      // Test setting English
      uiState.setLanguage('en');
      expect(uiState.selectedLanguageCode, equals('en'));

      // Test setting German
      uiState.setLanguage('de');
      expect(uiState.selectedLanguageCode, equals('de'));

      // Test setting back to system default
      uiState.setLanguage(null);
      expect(uiState.selectedLanguageCode, isNull);
    });

    test('should notify listeners when language changes', () {
      final uiState = UIState();
      bool notified = false;

      uiState.addListener(() {
        notified = true;
      });

      uiState.setLanguage('fr');
      expect(notified, isTrue);
    });
  });
}
