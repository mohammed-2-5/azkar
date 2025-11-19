import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({super.key});

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  final _controller = TextEditingController();
  bool _loading = false;
  List<geocoding.Location> _results = [];
  List<String> _labels = [];

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    setState(() {
      _loading = true;
      _results = [];
      _labels = [];
    });
    try {
      final locs = await geocoding.locationFromAddress(query);
      final labels = <String>[];
      for (final l in locs.take(10)) {
        try {
          final pm = await geocoding.placemarkFromCoordinates(
            l.latitude,
            l.longitude,
          );
          final place = pm.isNotEmpty ? pm.first : null;
          final label = [
            place?.locality,
            place?.administrativeArea,
            place?.country,
          ].where((e) => (e ?? '').isNotEmpty).join(', ');
          labels.add(
            label.isEmpty
                ? '${l.latitude.toStringAsFixed(3)}, ${l.longitude.toStringAsFixed(3)}'
                : label,
          );
        } catch (_) {
          labels.add(
            '${l.latitude.toStringAsFixed(3)}, ${l.longitude.toStringAsFixed(3)}',
          );
        }
      }
      setState(() {
        _results = locs.take(10).toList();
        _labels = labels;
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose City')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search city',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _controller.clear()),
                      )
                    : null,
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _search,
                icon: const Icon(Icons.search),
                label: const Text('Search'),
              ),
            ),
            const SizedBox(height: 12),
            if (_loading) const LinearProgressIndicator(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, i) {
                  final l = _results[i];
                  final label = _labels.elementAt(i);
                  return ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(label),
                    subtitle: Text(
                      '${l.latitude.toStringAsFixed(4)}, ${l.longitude.toStringAsFixed(4)}',
                    ),
                    onTap: () => Navigator.pop(context, {
                      'lat': l.latitude,
                      'lng': l.longitude,
                      'label': label,
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
