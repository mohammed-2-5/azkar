import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleState(locale: Locale('ar')));

  static const _systemCode = 'system';

  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();
    final code = sp.getString('locale_code');
    if (code == null || code.isEmpty) return;
    if (code == _systemCode) {
      emit(const LocaleState());
    } else {
      emit(LocaleState(locale: Locale(code)));
    }
  }

  Future<void> setLocale(Locale? locale) async {
    emit(LocaleState(locale: locale));
    final sp = await SharedPreferences.getInstance();
    if (locale == null) {
      await sp.setString('locale_code', _systemCode);
    } else {
      await sp.setString('locale_code', locale.languageCode);
    }
  }
}
