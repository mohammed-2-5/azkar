import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationDiagnosticsPage extends StatefulWidget {
  const NotificationDiagnosticsPage({super.key});

  @override
  State<NotificationDiagnosticsPage> createState() =>
      _NotificationDiagnosticsPageState();
}

class _NotificationDiagnosticsPageState
    extends State<NotificationDiagnosticsPage> {
  final List<String> _results = [];
  bool _running = false;

  Future<void> _runDiagnostics() async {
    setState(() {
      _results.clear();
      _running = true;
    });

    _addResult('🔍 Starting Diagnostics...\n');

    // Check 1: Audio files exist
    _addResult('📁 Checking audio files...');
    try {
      await rootBundle.load('assets/audio/adhan1.mp3');
      _addResult('  ✅ adhan1.mp3 found');
    } catch (e) {
      _addResult('  ❌ adhan1.mp3 missing or unreadable');
    }

    try {
      await rootBundle.load('assets/audio/adhan2.mp3');
      _addResult('  ✅ adhan2.mp3 found\n');
    } catch (e) {
      _addResult('  ❌ adhan2.mp3 missing or unreadable\n');
    }

    // Check 2: Get volume levels via platform channel
    _addResult('🔊 Checking volume settings...');
    try {
      const platform = MethodChannel('azkar/diagnostics');
      final notifVolume =
          await platform.invokeMethod<int>('getNotificationVolume');
      final alarmVolume = await platform.invokeMethod<int>('getAlarmVolume');
      final ringerMode = await platform.invokeMethod<String>('getRingerMode');

      _addResult('  Notification volume: ${notifVolume ?? "unknown"}');
      _addResult('  Alarm volume: ${alarmVolume ?? "unknown"}');
      _addResult('  Ringer mode: ${ringerMode ?? "unknown"}');

      if (ringerMode == 'SILENT') {
        _addResult('  ⚠️  Device is in SILENT mode - no sounds will play!');
      } else if (ringerMode == 'VIBRATE') {
        _addResult('  ⚠️  Device is in VIBRATE mode - limited sounds');
      }

      if ((notifVolume ?? 0) == 0 || (alarmVolume ?? 0) == 0) {
        _addResult('  ⚠️  Volume is at 0 - turn up volume!\n');
      } else {
        _addResult('  ✅ Volume levels look good\n');
      }
    } catch (e) {
      _addResult('  ⚠️  Could not check volume (method channel not implemented)\n');
    }

    // Check 3: Notification permission
    _addResult('🔔 Checking notification permission...');
    try {
      const platform = MethodChannel('azkar/diagnostics');
      final enabled =
          await platform.invokeMethod<bool>('areNotificationsEnabled');
      if (enabled == true) {
        _addResult('  ✅ Notifications enabled\n');
      } else {
        _addResult('  ❌ Notifications DISABLED - enable in settings!\n');
      }
    } catch (e) {
      _addResult('  ⚠️  Could not check permission status\n');
    }

    // Check 4: Do Not Disturb
    _addResult('🌙 Checking Do Not Disturb...');
    try {
      const platform = MethodChannel('azkar/diagnostics');
      final dndMode = await platform.invokeMethod<int>('getZenMode');
      if (dndMode == 0) {
        _addResult('  ✅ Do Not Disturb is OFF\n');
      } else {
        _addResult(
            '  ⚠️  Do Not Disturb is ON (mode: $dndMode) - this may block sounds!\n');
      }
    } catch (e) {
      _addResult('  ⚠️  Could not check DND status\n');
    }

    _addResult('✅ Diagnostics complete!');
    _addResult('\n💡 RECOMMENDATIONS:');
    _addResult('1. Test with "Test sound ONLY" button first');
    _addResult('2. If sound plays → notification sound config issue');
    _addResult('3. If no sound → check device volume/DND settings');
    _addResult('4. Try rebooting the device');
    _addResult('5. Check Settings → Apps → Azkar → Notifications');

    setState(() => _running = false);
  }

  void _addResult(String text) {
    setState(() => _results.add(text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Diagnostics')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _running ? null : _runDiagnostics,
              icon: _running
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(_running ? 'Running...' : 'Run Diagnostics'),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _results.isEmpty
                  ? const Center(
                      child: Text(
                        'Tap "Run Diagnostics" to check your notification setup',
                        style: TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            _results[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
