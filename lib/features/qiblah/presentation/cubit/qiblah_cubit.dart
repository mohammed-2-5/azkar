import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/usecases/get_qiblah_bearing.dart';
import '../../../../core/domain/usecases/get_preferred_location.dart';
import 'qiblah_state.dart';

class QiblahCubit extends Cubit<QiblahState> {
  QiblahCubit(
    this._getPreferredLocation,
    this._getQiblahBearing,
  ) : super(const QiblahState());

  final GetPreferredLocation _getPreferredLocation;
  final GetQiblahBearing _getQiblahBearing;

  Future<void> start() async {
    emit(state.copyWith(status: QiblahStatus.loading, error: null));
    try {
      final resolved = await _getPreferredLocation();
      if (resolved == null) {
        throw Exception('Set your city to compute Qiblah direction.');
      }
      final bearing = _getQiblahBearing(resolved.coordinate);
      emit(
        state.copyWith(
          status: QiblahStatus.ready,
          bearing: bearing,
          hasSensor: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: QiblahStatus.error, error: e.toString()));
    }
  }

}
