import 'package:equatable/equatable.dart';

enum QiblahStatus { initial, loading, ready, error }

class QiblahState extends Equatable {
  final QiblahStatus status;
  final double? bearing;
  final bool hasSensor;
  final String? error;

  const QiblahState({
    this.status = QiblahStatus.initial,
    this.bearing,
    this.hasSensor = true,
    this.error,
  });

  QiblahState copyWith({
    QiblahStatus? status,
    double? bearing,
    bool? hasSensor,
    String? error,
  }) {
    return QiblahState(
      status: status ?? this.status,
      bearing: bearing ?? this.bearing,
      hasSensor: hasSensor ?? this.hasSensor,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, bearing, hasSensor, error];
}
