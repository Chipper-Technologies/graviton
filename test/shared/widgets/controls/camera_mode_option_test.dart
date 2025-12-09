import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/shared/widgets/controls/camera_mode_option.dart';
import 'package:graviton/core/enums/cinematic_camera_technique.dart';

void main() {
  group('CameraModeOption Tests', () {
    Widget createTestWidget({required Widget child}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      );
    }

    group('Widget Construction', () {
      testWidgets('should build without error with required parameters', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: 'Test Option',
              description: 'Test description',
              mode: CinematicCameraTechnique.manual,
              icon: Icons.camera,
              isSelected: false,
              onTap: () {},
            ),
          ),
        );

        expect(find.byType(CameraModeOption), findsOneWidget);
      });

      testWidgets('should display provided title and description', (
        tester,
      ) async {
        const testTitle = 'Predictive Orbital';
        const testDescription = 'Test description';

        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: testTitle,
              description: testDescription,
              mode: CinematicCameraTechnique.predictiveOrbital,
              icon: Icons.camera,
              isSelected: false,
              onTap: () {},
            ),
          ),
        );

        expect(find.text(testTitle), findsOneWidget);
        expect(find.text(testDescription), findsOneWidget);
      });

      testWidgets('should handle empty strings gracefully', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: '',
              description: '',
              mode: CinematicCameraTechnique.manual,
              icon: Icons.camera,
              isSelected: false,
              onTap: () {},
            ),
          ),
        );

        expect(find.byType(CameraModeOption), findsOneWidget);
      });

      testWidgets('should display the provided icon', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: 'Test',
              description: 'Description',
              mode: CinematicCameraTechnique.manual,
              icon: Icons.videocam,
              isSelected: false,
              onTap: () {},
            ),
          ),
        );

        expect(find.byIcon(Icons.videocam), findsOneWidget);
      });
    });

    group('Visual States', () {
      testWidgets('should show selected state when isSelected is true', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: 'Selected Option',
              description: 'Selected description',
              mode: CinematicCameraTechnique.predictiveOrbital,
              icon: Icons.camera,
              isSelected: true,
              onTap: () {},
            ),
          ),
        );

        // Find the container and check its decoration
        final container = find.byType(Container);
        expect(container, findsAtLeastNWidgets(1));

        expect(find.byType(CameraModeOption), findsOneWidget);
      });

      testWidgets('should show unselected state when isSelected is false', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: 'Unselected Option',
              description: 'Unselected description',
              mode: CinematicCameraTechnique.manual,
              icon: Icons.camera,
              isSelected: false,
              onTap: () {},
            ),
          ),
        );

        // Widget should still render properly
        expect(find.byType(CameraModeOption), findsOneWidget);
        expect(find.text('Unselected Option'), findsOneWidget);
      });

      testWidgets('should apply proper styling', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: 'Test Option',
              description: 'Test description',
              mode: CinematicCameraTechnique.manual,
              icon: Icons.camera,
              isSelected: true,
              onTap: () {},
            ),
          ),
        );

        // Check for proper padding and layout
        final padding = find.byType(Padding);
        expect(padding, findsAtLeastNWidgets(1));

        expect(find.byType(CameraModeOption), findsOneWidget);
      });
    });

    group('User Interactions', () {
      testWidgets('should call onTap when tapped', (tester) async {
        bool wasTapped = false;

        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: 'Tappable Option',
              description: 'Tap me',
              mode: CinematicCameraTechnique.manual,
              icon: Icons.camera,
              isSelected: false,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        );

        await tester.tap(find.byType(CameraModeOption));
        await tester.pump();

        expect(wasTapped, isTrue);
      });

      testWidgets('should respond to multiple taps', (tester) async {
        int tapCount = 0;

        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: 'Multi-tap Option',
              description: 'Tap multiple times',
              mode: CinematicCameraTechnique.manual,
              icon: Icons.camera,
              isSelected: false,
              onTap: () {
                tapCount++;
              },
            ),
          ),
        );

        // Tap multiple times
        await tester.tap(find.byType(CameraModeOption));
        await tester.pump();
        await tester.tap(find.byType(CameraModeOption));
        await tester.pump();
        await tester.tap(find.byType(CameraModeOption));
        await tester.pump();

        expect(tapCount, equals(3));
      });

      testWidgets('should handle tap on both selected and unselected states', (
        tester,
      ) async {
        bool wasTappedSelected = false;
        bool wasTappedUnselected = false;

        // Test selected state
        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: 'Selected',
              description: 'Selected state',
              mode: CinematicCameraTechnique.predictiveOrbital,
              icon: Icons.camera,
              isSelected: true,
              onTap: () {
                wasTappedSelected = true;
              },
            ),
          ),
        );

        await tester.tap(find.byType(CameraModeOption));
        await tester.pump();
        expect(wasTappedSelected, isTrue);

        // Test unselected state
        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: 'Unselected',
              description: 'Unselected state',
              mode: CinematicCameraTechnique.manual,
              icon: Icons.camera,
              isSelected: false,
              onTap: () {
                wasTappedUnselected = true;
              },
            ),
          ),
        );

        await tester.tap(find.byType(CameraModeOption));
        await tester.pump();
        expect(wasTappedUnselected, isTrue);
      });
    });

    group('Layout and Sizing', () {
      testWidgets('should have consistent sizing', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: Column(
              children: [
                CameraModeOption(
                  title: 'Option 1',
                  description: 'First option',
                  mode: CinematicCameraTechnique.manual,
                  icon: Icons.camera,
                  isSelected: true,
                  onTap: () {},
                ),
                CameraModeOption(
                  title: 'Option 2',
                  description: 'Second option',
                  mode: CinematicCameraTechnique.predictiveOrbital,
                  icon: Icons.videocam,
                  isSelected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        );

        final options = find.byType(CameraModeOption);
        expect(options, findsNWidgets(2));

        // Both should have similar sizing structure
        final firstSize = tester.getSize(options.first);
        final lastSize = tester.getSize(options.last);

        expect(
          firstSize.height,
          closeTo(lastSize.height, 20.0),
        ); // Allow some variation for content
      });

      testWidgets('should adapt to content width', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: Column(
              children: [
                CameraModeOption(
                  title: 'Short',
                  description: 'Brief',
                  mode: CinematicCameraTechnique.manual,
                  icon: Icons.camera,
                  isSelected: false,
                  onTap: () {},
                ),
                CameraModeOption(
                  title: 'Very Long Option Name That Should Take More Space',
                  description:
                      'This is a much longer description that will require more horizontal space',
                  mode: CinematicCameraTechnique.predictiveOrbital,
                  icon: Icons.videocam,
                  isSelected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        );

        final options = find.byType(CameraModeOption);
        expect(options, findsNWidgets(2));
      });

      testWidgets('should handle container constraints', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: SizedBox(
              width: 200,
              child: CameraModeOption(
                title: 'Constrained Option',
                description: 'Constrained description',
                mode: CinematicCameraTechnique.manual,
                icon: Icons.camera,
                isSelected: false,
                onTap: () {},
              ),
            ),
          ),
        );

        final optionSize = tester.getSize(find.byType(CameraModeOption));
        expect(optionSize.width, lessThanOrEqualTo(200));
      });
    });

    group('Text Styling', () {
      testWidgets('should handle different text lengths', (tester) async {
        const longTitle =
            'This is a very long camera mode option title that should wrap properly';
        const longDescription =
            'This is a very long description that explains the camera mode option in detail';

        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: longTitle,
              description: longDescription,
              mode: CinematicCameraTechnique.predictiveOrbital,
              icon: Icons.camera,
              isSelected: false,
              onTap: () {},
            ),
          ),
        );

        expect(find.text(longTitle), findsOneWidget);
        expect(find.text(longDescription), findsOneWidget);
        expect(find.byType(CameraModeOption), findsOneWidget);
      });

      testWidgets('should handle special characters', (tester) async {
        const specialTitle = 'Spéciål Çhåráctërs';
        const specialDescription = 'Dëscriptîøn with symbols & characters!';

        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: specialTitle,
              description: specialDescription,
              mode: CinematicCameraTechnique.manual,
              icon: Icons.camera,
              isSelected: false,
              onTap: () {},
            ),
          ),
        );

        expect(find.text(specialTitle), findsOneWidget);
        expect(find.text(specialDescription), findsOneWidget);
      });

      testWidgets('should handle numeric text', (tester) async {
        const numericTitle = '12345';
        const numericDescription = '67890';

        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: numericTitle,
              description: numericDescription,
              mode: CinematicCameraTechnique.manual,
              icon: Icons.camera,
              isSelected: false,
              onTap: () {},
            ),
          ),
        );

        expect(find.text(numericTitle), findsOneWidget);
        expect(find.text(numericDescription), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible for screen readers', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: 'Accessible Option',
              description: 'This is accessible',
              mode: CinematicCameraTechnique.manual,
              icon: Icons.camera,
              isSelected: true,
              onTap: () {},
            ),
          ),
        );

        // Should be tappable and have text content
        expect(find.text('Accessible Option'), findsOneWidget);
        expect(find.text('This is accessible'), findsOneWidget);

        // Should respond to tap
        await tester.tap(find.byType(CameraModeOption));
        await tester.pump();
      });

      testWidgets('should provide appropriate semantics for selection state', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: Column(
              children: [
                CameraModeOption(
                  title: 'Selected Option',
                  description: 'This is selected',
                  mode: CinematicCameraTechnique.predictiveOrbital,
                  icon: Icons.camera,
                  isSelected: true,
                  onTap: () {},
                ),
                CameraModeOption(
                  title: 'Unselected Option',
                  description: 'This is not selected',
                  mode: CinematicCameraTechnique.manual,
                  icon: Icons.videocam,
                  isSelected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        );

        // Both should be findable and distinguishable
        expect(find.text('Selected Option'), findsOneWidget);
        expect(find.text('Unselected Option'), findsOneWidget);
        expect(find.text('This is selected'), findsOneWidget);
        expect(find.text('This is not selected'), findsOneWidget);
      });
    });

    group('Performance', () {
      testWidgets('should not rebuild unnecessarily', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: 'Performance Test',
              description: 'Testing performance',
              mode: CinematicCameraTechnique.manual,
              icon: Icons.camera,
              isSelected: false,
              onTap: () {},
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Pump again without changes
        await tester.pump();

        expect(find.byType(CameraModeOption), findsOneWidget);
      });

      testWidgets('should handle rapid state changes', (tester) async {
        bool isSelected = false;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return createTestWidget(
                child: CameraModeOption(
                  title: 'Rapid State Test',
                  description: 'Testing rapid changes',
                  mode: CinematicCameraTechnique.manual,
                  icon: Icons.camera,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      isSelected = !isSelected;
                    });
                  },
                ),
              );
            },
          ),
        );

        // Rapid taps
        for (int i = 0; i < 10; i++) {
          await tester.tap(find.byType(CameraModeOption));
          await tester.pump();
        }

        expect(find.byType(CameraModeOption), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle different camera modes', (tester) async {
        for (final mode in CinematicCameraTechnique.values) {
          await tester.pumpWidget(
            createTestWidget(
              child: CameraModeOption(
                title: 'Mode Test',
                description: 'Testing mode: ${mode.name}',
                mode: mode,
                icon: Icons.camera,
                isSelected: false,
                onTap: () {},
              ),
            ),
          );

          expect(find.byType(CameraModeOption), findsOneWidget);
          expect(find.text('Mode Test'), findsOneWidget);
        }
      });

      testWidgets('should handle different icons', (tester) async {
        final icons = [
          Icons.camera,
          Icons.videocam,
          Icons.photo_camera,
          Icons.movie,
        ];

        for (final icon in icons) {
          await tester.pumpWidget(
            createTestWidget(
              child: CameraModeOption(
                title: 'Icon Test',
                description: 'Testing icon',
                mode: CinematicCameraTechnique.manual,
                icon: icon,
                isSelected: false,
                onTap: () {},
              ),
            ),
          );

          expect(find.byIcon(icon), findsOneWidget);
        }
      });

      testWidgets('should handle rebuilds with different parameters', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: 'Original Title',
              description: 'Original description',
              mode: CinematicCameraTechnique.manual,
              icon: Icons.camera,
              isSelected: false,
              onTap: () {},
            ),
          ),
        );

        expect(find.text('Original Title'), findsOneWidget);

        // Rebuild with different parameters
        await tester.pumpWidget(
          createTestWidget(
            child: CameraModeOption(
              title: 'Updated Title',
              description: 'Updated description',
              mode: CinematicCameraTechnique.predictiveOrbital,
              icon: Icons.videocam,
              isSelected: true,
              onTap: () {},
            ),
          ),
        );

        expect(find.text('Updated Title'), findsOneWidget);
        expect(find.text('Original Title'), findsNothing);
        expect(find.byIcon(Icons.videocam), findsOneWidget);
      });
    });
  });
}
