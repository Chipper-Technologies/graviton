import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graviton/services/auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService Terms & Privacy Acceptance', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService.instance;

      // Reset SharedPreferences for each test
      SharedPreferences.setMockInitialValues({});
    });

    group('saveTermsAcceptance', () {
      test('saves terms acceptance with default version', () async {
        // Act
        await authService.saveTermsAcceptance();

        // Assert
        final hasAccepted = await authService.hasAcceptedTerms();
        expect(hasAccepted, isTrue);

        final version = await authService.getAcceptedTermsVersion();
        expect(version, equals('1.0'));
      });

      test('saves terms acceptance with custom version', () async {
        // Act
        await authService.saveTermsAcceptance(termsVersion: '2.1');

        // Assert
        final hasAccepted = await authService.hasAcceptedTerms();
        expect(hasAccepted, isTrue);

        final version = await authService.getAcceptedTermsVersion();
        expect(version, equals('2.1'));
      });

      test('saves timestamp when accepting terms', () async {
        // Arrange
        final beforeTimestamp = DateTime.now().subtract(
          const Duration(seconds: 1),
        );

        // Act
        await authService.saveTermsAcceptance();

        // Assert
        final afterTimestamp = DateTime.now().add(const Duration(seconds: 1));
        final acceptanceDate = await authService.getTermsAcceptanceDate();

        expect(acceptanceDate, isNotNull);
        expect(acceptanceDate!.isAfter(beforeTimestamp), isTrue);
        expect(acceptanceDate.isBefore(afterTimestamp), isTrue);
      });

      test('can be called multiple times (updates timestamp)', () async {
        // Act
        await authService.saveTermsAcceptance(termsVersion: '1.0');
        await Future.delayed(const Duration(milliseconds: 10));
        await authService.saveTermsAcceptance(termsVersion: '2.0');

        // Assert
        final hasAccepted = await authService.hasAcceptedTerms();
        expect(hasAccepted, isTrue);

        final version = await authService.getAcceptedTermsVersion();
        expect(version, equals('2.0'));
      });
    });

    group('hasAcceptedTerms', () {
      test('returns false when terms have not been accepted', () async {
        // Act
        final hasAccepted = await authService.hasAcceptedTerms();

        // Assert
        expect(hasAccepted, isFalse);
      });

      test('returns true after terms are accepted', () async {
        // Arrange
        await authService.saveTermsAcceptance();

        // Act
        final hasAccepted = await authService.hasAcceptedTerms();

        // Assert
        expect(hasAccepted, isTrue);
      });

      test('returns true even after app restart (persistent)', () async {
        // Arrange - First "session"
        await authService.saveTermsAcceptance();

        // Act - Simulate restart by getting fresh prefs
        final prefs = await SharedPreferences.getInstance();
        final hasKey = prefs.containsKey('terms_acceptance_timestamp');

        // Assert
        expect(hasKey, isTrue);
      });
    });

    group('getTermsAcceptanceDate', () {
      test('returns null when terms have not been accepted', () async {
        // Act
        final date = await authService.getTermsAcceptanceDate();

        // Assert
        expect(date, isNull);
      });

      test('returns DateTime after terms are accepted', () async {
        // Arrange
        await authService.saveTermsAcceptance();

        // Act
        final date = await authService.getTermsAcceptanceDate();

        // Assert
        expect(date, isNotNull);
        expect(date, isA<DateTime>());
      });

      test('returns accurate timestamp', () async {
        // Arrange
        final beforeSave = DateTime.now();
        await authService.saveTermsAcceptance();
        final afterSave = DateTime.now();

        // Act
        final date = await authService.getTermsAcceptanceDate();

        // Assert
        expect(date, isNotNull);
        expect(
          date!.isAfter(beforeSave.subtract(const Duration(seconds: 1))),
          isTrue,
        );
        expect(
          date.isBefore(afterSave.add(const Duration(seconds: 1))),
          isTrue,
        );
      });
    });

    group('getAcceptedTermsVersion', () {
      test('returns null when terms have not been accepted', () async {
        // Act
        final version = await authService.getAcceptedTermsVersion();

        // Assert
        expect(version, isNull);
      });

      test('returns default version 1.0 when not specified', () async {
        // Arrange
        await authService.saveTermsAcceptance();

        // Act
        final version = await authService.getAcceptedTermsVersion();

        // Assert
        expect(version, equals('1.0'));
      });

      test('returns custom version when specified', () async {
        // Arrange
        await authService.saveTermsAcceptance(termsVersion: '3.5');

        // Act
        final version = await authService.getAcceptedTermsVersion();

        // Assert
        expect(version, equals('3.5'));
      });

      test('returns latest version after multiple acceptances', () async {
        // Arrange
        await authService.saveTermsAcceptance(termsVersion: '1.0');
        await authService.saveTermsAcceptance(termsVersion: '2.0');
        await authService.saveTermsAcceptance(termsVersion: '3.0');

        // Act
        final version = await authService.getAcceptedTermsVersion();

        // Assert
        expect(version, equals('3.0'));
      });
    });

    group('clearTermsAcceptance', () {
      test('clears terms acceptance data', () async {
        // Arrange
        await authService.saveTermsAcceptance(termsVersion: '2.0');
        expect(await authService.hasAcceptedTerms(), isTrue);

        // Act
        await authService.clearTermsAcceptance();

        // Assert
        final hasAccepted = await authService.hasAcceptedTerms();
        final date = await authService.getTermsAcceptanceDate();
        final version = await authService.getAcceptedTermsVersion();

        expect(hasAccepted, isFalse);
        expect(date, isNull);
        expect(version, isNull);
      });

      test('can be called multiple times without error', () async {
        // Arrange
        await authService.saveTermsAcceptance();

        // Act & Assert - Should not throw
        await authService.clearTermsAcceptance();
        await authService.clearTermsAcceptance();
        await authService.clearTermsAcceptance();

        expect(await authService.hasAcceptedTerms(), isFalse);
      });

      test('can be called even when terms were never accepted', () async {
        // Act & Assert - Should not throw
        await authService.clearTermsAcceptance();

        final hasAccepted = await authService.hasAcceptedTerms();
        expect(hasAccepted, isFalse);
      });

      test('allows re-accepting after clearing', () async {
        // Arrange
        await authService.saveTermsAcceptance(termsVersion: '1.0');
        await authService.clearTermsAcceptance();

        // Act
        await authService.saveTermsAcceptance(termsVersion: '2.0');

        // Assert
        final hasAccepted = await authService.hasAcceptedTerms();
        final version = await authService.getAcceptedTermsVersion();

        expect(hasAccepted, isTrue);
        expect(version, equals('2.0'));
      });
    });

    group('Terms Acceptance Integration', () {
      test('complete flow: check, accept, verify, clear, verify', () async {
        // Initial state - not accepted
        expect(await authService.hasAcceptedTerms(), isFalse);
        expect(await authService.getTermsAcceptanceDate(), isNull);
        expect(await authService.getAcceptedTermsVersion(), isNull);

        // Accept terms
        await authService.saveTermsAcceptance(termsVersion: '1.5');

        // Verify accepted
        expect(await authService.hasAcceptedTerms(), isTrue);
        expect(await authService.getTermsAcceptanceDate(), isNotNull);
        expect(await authService.getAcceptedTermsVersion(), equals('1.5'));

        // Clear acceptance
        await authService.clearTermsAcceptance();

        // Verify cleared
        expect(await authService.hasAcceptedTerms(), isFalse);
        expect(await authService.getTermsAcceptanceDate(), isNull);
        expect(await authService.getAcceptedTermsVersion(), isNull);
      });

      test(
        'version upgrade flow: accept v1, check, accept v2, verify',
        () async {
          // Accept version 1.0
          await authService.saveTermsAcceptance(termsVersion: '1.0');
          expect(await authService.getAcceptedTermsVersion(), equals('1.0'));
          final firstDate = await authService.getTermsAcceptanceDate();

          // Wait a bit
          await Future.delayed(const Duration(milliseconds: 10));

          // Upgrade to version 2.0
          await authService.saveTermsAcceptance(termsVersion: '2.0');
          expect(await authService.getAcceptedTermsVersion(), equals('2.0'));
          final secondDate = await authService.getTermsAcceptanceDate();

          // Verify timestamp updated
          expect(secondDate, isNotNull);
          expect(firstDate, isNotNull);
          expect(
            secondDate!.isAfter(firstDate!) ||
                secondDate.isAtSameMomentAs(firstDate),
            isTrue,
          );
        },
      );

      test('persistence across SharedPreferences reloads', () async {
        // Save terms acceptance
        await authService.saveTermsAcceptance(termsVersion: '1.0');

        // Verify with fresh SharedPreferences instance
        final prefs = await SharedPreferences.getInstance();
        final timestamp = prefs.getInt('terms_acceptance_timestamp');
        final version = prefs.getString('terms_version_accepted');

        expect(timestamp, isNotNull);
        expect(version, equals('1.0'));
      });
    });
  });
}
