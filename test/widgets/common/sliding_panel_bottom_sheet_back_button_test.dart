import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/shared/widgets/layouts/sliding_panel_bottom_sheet.dart';
import 'package:provider/provider.dart';

void main() {
  group('SlidingPanelBottomSheet Back Button Features', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    tearDown(() {
      appState.dispose();
    });

    Widget createTestWidget({VoidCallback? onInteraction}) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: Scaffold(
            body: SlidingPanelBottomSheet(onInteraction: onInteraction),
          ),
        ),
      );
    }

    group('Static Methods', () {
      testWidgets('isExpanded should return false when no instance exists', (
        tester,
      ) async {
        // Test without any widget rendered to ensure no instance exists
        expect(SlidingPanelBottomSheet.isExpanded, false);
      });

      testWidgets('closePanel should return false when no instance exists', (
        tester,
      ) async {
        // Test without any widget rendered to ensure no instance exists
        expect(SlidingPanelBottomSheet.closePanel(), false);
      });

      testWidgets('isExpanded should reflect initial sheet state', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Initial position is at minimum (0.15), so should be false initially
        // (Would need to expand the panel to make it true)
        expect(SlidingPanelBottomSheet.isExpanded, false);
      });

      testWidgets('closePanel should work when instance exists', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // closePanel should return true when instance exists
        expect(SlidingPanelBottomSheet.closePanel(), true);
        await tester.pumpAndSettle();
      });

      testWidgets('closePanel should call onInteraction callback', (
        tester,
      ) async {
        bool interactionCalled = false;

        await tester.pumpWidget(
          createTestWidget(
            onInteraction: () {
              interactionCalled = true;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Reset flag
        interactionCalled = false;

        // Close panel should trigger interaction callback
        SlidingPanelBottomSheet.closePanel();
        await tester.pumpAndSettle();

        expect(interactionCalled, true);
      });
    });

    group('Position Management', () {
      testWidgets('should track position changes correctly', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Get initial position
        final initialPosition = SlidingPanelBottomSheet.sheetPosition.value;
        expect(initialPosition, greaterThan(0.0));

        // Position should be accessible through the static getter
        expect(SlidingPanelBottomSheet.sheetPosition, isNotNull);
      });

      testWidgets('refreshPosition should work without error', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should not throw an error
        expect(
          () => SlidingPanelBottomSheet.refreshPosition(),
          returnsNormally,
        );
      });
    });

    group('Instance Management', () {
      testWidgets('should handle widget disposal gracefully', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify it works initially
        expect(SlidingPanelBottomSheet.closePanel(), true);

        // Remove the widget
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: SizedBox())),
        );
        await tester.pumpAndSettle();

        // Methods should handle absence of instance gracefully
        expect(SlidingPanelBottomSheet.isExpanded, false);
        expect(SlidingPanelBottomSheet.closePanel(), false);
      });

      testWidgets('should maintain singleton pattern', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final position1 = SlidingPanelBottomSheet.sheetPosition;

        // Rebuild widget
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final position2 = SlidingPanelBottomSheet.sheetPosition;

        // Should be the same ValueNotifier instance
        expect(identical(position1, position2), true);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle rapid method calls', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Rapid calls should not cause errors
        for (int i = 0; i < 5; i++) {
          SlidingPanelBottomSheet.closePanel();
          SlidingPanelBottomSheet.refreshPosition();
          expect(SlidingPanelBottomSheet.isExpanded, false);
        }

        await tester.pumpAndSettle();
      });

      testWidgets('should handle multiple widget builds', (tester) async {
        // Build and dispose multiple times
        for (int i = 0; i < 3; i++) {
          await tester.pumpWidget(createTestWidget());
          await tester.pumpAndSettle();

          expect(SlidingPanelBottomSheet.closePanel(), true);

          await tester.pumpWidget(
            const MaterialApp(home: Scaffold(body: SizedBox())),
          );
          await tester.pumpAndSettle();
        }

        // Final state should be clean
        expect(SlidingPanelBottomSheet.isExpanded, false);
        expect(SlidingPanelBottomSheet.closePanel(), false);
      });
    });
  });
}
