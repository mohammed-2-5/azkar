import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/permission_gate.dart';
import 'ui/widgets/animated_splash.dart';

Future<void> main() async {
  final dep = await AppBootstrap.init();
  runApp(AzkarRoot(dep: dep));
}

class AzkarRoot extends StatefulWidget {
  const AzkarRoot({super.key, required this.dep});
  final AppDependencies dep;

  @override
  State<AzkarRoot> createState() => _AzkarRootState();
}

class _AzkarRootState extends State<AzkarRoot> {
  bool _showSplash = true;

  void _finishSplash() {
    if (!mounted) return;
    setState(() => _showSplash = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: _showSplash
          ? AnimatedSplash(key: const ValueKey('splash'), onFinished: _finishSplash)
          : PermissionGate(key: const ValueKey('gate'), dep: widget.dep),
    );
  }
}
