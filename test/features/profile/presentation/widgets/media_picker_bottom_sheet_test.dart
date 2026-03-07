import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_health_care/features/profile/presentation/widgets/media_picker_bottom_sheet.dart';

void main() {
  group('MediaPickerBottomSheet Widget Tests', () {
    testWidgets('shows camera and gallery options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaPickerBottomSheet(
              onCameraTap: () {},
              onGalleryTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Open Camera'), findsOneWidget);
      expect(find.text('Open Gallery'), findsOneWidget);
      expect(find.byIcon(Icons.camera), findsOneWidget);
      expect(find.byIcon(Icons.browse_gallery), findsOneWidget);
    });

    testWidgets('calls onCameraTap when camera tile is tapped', (tester) async {
      bool cameraTapped = false;
      bool galleryTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaPickerBottomSheet(
              onCameraTap: () {
                cameraTapped = true;
              },
              onGalleryTap: () {
                galleryTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Camera'));
      await tester.pump();

      expect(cameraTapped, true);
      expect(galleryTapped, false);
    });

    testWidgets('calls onGalleryTap when gallery tile is tapped', (tester) async {
      bool cameraTapped = false;
      bool galleryTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaPickerBottomSheet(
              onCameraTap: () {
                cameraTapped = true;
              },
              onGalleryTap: () {
                galleryTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Gallery'));
      await tester.pump();

      expect(cameraTapped, false);
      expect(galleryTapped, true);
    });

    testWidgets('show() displays bottom sheet and handles camera tap', (tester) async {
      bool cameraTapped = false;
      bool galleryTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      MediaPickerBottomSheet.show(
                        context,
                        onCameraTap: () {
                          cameraTapped = true;
                        },
                        onGalleryTap: () {
                          galleryTapped = true;
                        },
                      );
                    },
                    child: const Text('Show Bottom Sheet'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Open Camera'), findsOneWidget);
      expect(find.text('Open Gallery'), findsOneWidget);

      await tester.tap(find.text('Open Camera'));
      await tester.pumpAndSettle();

      expect(cameraTapped, true);
      expect(galleryTapped, false);
      expect(find.text('Open Camera'), findsNothing);
    });

    testWidgets('show() displays bottom sheet and handles gallery tap', (tester) async {
      bool cameraTapped = false;
      bool galleryTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      MediaPickerBottomSheet.show(
                        context,
                        onCameraTap: () {
                          cameraTapped = true;
                        },
                        onGalleryTap: () {
                          galleryTapped = true;
                        },
                      );
                    },
                    child: const Text('Show Bottom Sheet'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Gallery'));
      await tester.pumpAndSettle();

      expect(cameraTapped, false);
      expect(galleryTapped, true);
      expect(find.text('Open Gallery'), findsNothing);
    });
  });
}