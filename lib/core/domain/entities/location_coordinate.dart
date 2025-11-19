import 'package:equatable/equatable.dart';

class LocationCoordinate extends Equatable {
  const LocationCoordinate({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  List<Object> get props => [latitude, longitude];
}
