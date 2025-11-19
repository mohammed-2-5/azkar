import 'package:equatable/equatable.dart';

import 'location_coordinate.dart';

enum PreferredLocationSource { device, fixed, cached }

class ResolvedLocation extends Equatable {
  const ResolvedLocation({
    required this.coordinate,
    required this.source,
    this.label,
    this.timestamp,
  });

  final LocationCoordinate coordinate;
  final PreferredLocationSource source;
  final String? label;
  final DateTime? timestamp;

  bool get usesDeviceLocation => source == PreferredLocationSource.device;

  @override
  List<Object?> get props => [coordinate, source, label, timestamp];
}
