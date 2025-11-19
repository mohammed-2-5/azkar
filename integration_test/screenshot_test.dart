import 'dart:io';

import 'package:azkar/app/app.dart';
import 'package:azkar/main.dart' as app_bootstrap;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Azkar screenshots', () {
    testWidgets('capture main tabs', (tester) async {
      SharedPreferences.setMockInitialValues({'location_onboarded': true});
      Directory('assets/screenshots').createSync(recursive: true);

      final deps = await app_bootstrap.AppBootstrap.init();
      final controller = ScreenshotController();

      await tester.pumpWidget(
        Screenshot(
          controller: controller,
          child: MaterialApp(
            home: AzkarRoot(dep: deps),
          ),
        ),
      );
      await tester.pumpAndSettle();

      Future<void> capture(String name) async {
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
        final path = await controller.captureAndSave(
          'assets/screenshots',
          fileName: '.png',
        );
        debugPrint('Saved screenshot to ');
      }

      Future<void> tapNav(IconData icon) async {
        final finder = find.byIcon(icon).last;
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }

      await capture('prayer_home');
      await tapNav(Icons.explore_outlined);
      await capture('qiblah_tab');
      await tapNav(Icons.menu_book_outlined);
      await capture('quran_tab');
      await tapNav(Icons.favorite_border);
      await capture('azkar_tab');
    });
  });
}
