import 'dart:io';

import 'package:azkar/app/app.dart';
import 'package:azkar/main.dart' show AzkarRoot;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Azkar screenshots', () {
    testWidgets('capture main tabs', (tester) async {
      SharedPreferences.setMockInitialValues({'location_onboarded': true});

      final deps = await AppBootstrap.init();
      final controller = ScreenshotController();

      await tester.pumpWidget(
        MaterialApp(
          home: AzkarRoot(dep: deps),
        ),
      );
      await tester.pump(const Duration(seconds: 3));

      Future<void> capture(String name) async {
        await tester.pump(const Duration(milliseconds: 800));
        final baseDir = await getExternalStorageDirectory();
        final dir = Directory('/azkar-screenshots');
        await dir.create(recursive: true);
        await controller.captureAndSave(dir.path, fileName: '.png');
      }

      Future<void> tapNav(IconData icon) async {
        final finder = find.byIcon(icon).last;
        await tester.tap(finder);
        await tester.pump(const Duration(seconds: 2));
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
