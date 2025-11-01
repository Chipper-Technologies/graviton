import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/utils/clipboard_utils.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('ClipboardUtils Tests', () {
    setUp(() {
      // Initialize the test binding to handle platform channels
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    group('copyToClipboard', () {
      testWidgets('should copy text and show snackbar', (
        WidgetTester tester,
      ) async {
        const testText = 'Test clipboard content';

        // Mock the clipboard
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (MethodCall methodCall) async {
            if (methodCall.method == 'Clipboard.setData') {
              return null;
            }
            return null;
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () =>
                      ClipboardUtils.copyToClipboard(context, testText),
                  child: const Text('Copy'),
                ),
              ),
            ),
          ),
        );

        // Tap the button to trigger clipboard copy
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Verify snackbar appears with correct message
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.textContaining(testText), findsOneWidget);
      });

      testWidgets('should handle custom duration', (WidgetTester tester) async {
        const testText = 'Test text';
        const customDuration = Duration(seconds: 5);

        // Mock the clipboard
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (MethodCall methodCall) async {
            if (methodCall.method == 'Clipboard.setData') {
              return null;
            }
            return null;
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () => ClipboardUtils.copyToClipboard(
                    context,
                    testText,
                    duration: customDuration,
                  ),
                  child: const Text('Copy'),
                ),
              ),
            ),
          ),
        );

        // Tap the button to trigger clipboard copy
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Verify snackbar appears
        expect(find.byType(SnackBar), findsOneWidget);
      });
    });

    group('copyToClipboardSilent', () {
      test('should copy text without UI feedback', () async {
        const testText = 'Silent copy test';

        // Mock the clipboard
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, (
              MethodCall methodCall,
            ) async {
              if (methodCall.method == 'Clipboard.setData') {
                expect(methodCall.arguments['text'], equals(testText));
                return null;
              }
              return null;
            });

        // This should complete without throwing
        await ClipboardUtils.copyToClipboardSilent(testText);
      });
    });

    group('getFromClipboard', () {
      test('should retrieve text from clipboard', () async {
        const testText = 'Retrieved text';

        // Mock the clipboard with data
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, (
              MethodCall methodCall,
            ) async {
              if (methodCall.method == 'Clipboard.getData') {
                return {'text': testText};
              }
              return null;
            });

        final result = await ClipboardUtils.getFromClipboard();
        expect(result, equals(testText));
      });

      test('should return null when clipboard is empty', () async {
        // Mock empty clipboard
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, (
              MethodCall methodCall,
            ) async {
              if (methodCall.method == 'Clipboard.getData') {
                return null;
              }
              return null;
            });

        final result = await ClipboardUtils.getFromClipboard();
        expect(result, isNull);
      });
    });

    group('hasText', () {
      test('should return true when clipboard has text', () async {
        const testText = 'Some text';

        // Mock clipboard with text
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, (
              MethodCall methodCall,
            ) async {
              if (methodCall.method == 'Clipboard.getData') {
                return {'text': testText};
              }
              return null;
            });

        final result = await ClipboardUtils.hasText();
        expect(result, isTrue);
      });

      test('should return false when clipboard is empty', () async {
        // Mock empty clipboard
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, (
              MethodCall methodCall,
            ) async {
              if (methodCall.method == 'Clipboard.getData') {
                return {'text': ''};
              }
              return null;
            });

        final result = await ClipboardUtils.hasText();
        expect(result, isFalse);
      });

      test('should handle clipboard errors gracefully', () async {
        // Mock clipboard error
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, (
              MethodCall methodCall,
            ) async {
              if (methodCall.method == 'Clipboard.getData') {
                throw PlatformException(
                  code: 'error',
                  message: 'Clipboard error',
                );
              }
              return null;
            });

        final result = await ClipboardUtils.hasText();
        expect(result, isFalse);
      });
    });

    tearDown(() {
      // Clean up mock handlers
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });
  });
}
