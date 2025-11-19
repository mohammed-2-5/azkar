# Flutter/Dart code lives in libapp.so and is already tree-shaken.
# Keep default rules minimal to allow R8/resource shrinking.

# Retain the Flutter embedding entry point.
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.app.** { *; }

# Retain any generated registrant classes.
-keep class **GeneratedPluginRegistrant { *; }

# Retain JSON models referenced via reflection (none currently).
