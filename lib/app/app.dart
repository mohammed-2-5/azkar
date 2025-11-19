import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/domain/usecases/get_preferred_location.dart';
import '../core/domain/usecases/get_qiblah_bearing.dart';
import '../core/services/location_service.dart';
import '../core/services/notification_scheduler.dart';
import '../core/services/notification_service.dart';
import '../core/telemetry/telemetry_cubit.dart';
import '../core/telemetry/telemetry_service.dart';
import '../core/theme/locale_cubit.dart';
import '../core/theme/locale_state.dart';
import '../core/theme/theme_cubit.dart';
import '../core/theme/theme_state.dart';
import '../core/theme/theme_tokens.dart';
import '../features/azkar/data/azkar_repository.dart';
import '../features/azkar/data/azkar_storage.dart';
import '../features/azkar/presentation/cubit/azkar_cubit.dart';
import '../features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import '../features/qiblah/presentation/cubit/qiblah_cubit.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';

class AppBootstrap {
  static Future<AppDependencies> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    final notifications = NotificationService();
    await notifications.init();
    await NotificationScheduler.ensureTZ();
    final locationService = LocationService();
    final telemetry = TelemetryService();
    await telemetry.init();
    return AppDependencies(
      locationService: locationService,
      notificationService: notifications,
      azkarRepository: AzkarRepository(),
      getQiblahBearing: GetQiblahBearing(),
      getPreferredLocation: GetPreferredLocation(locationService),
      telemetryService: telemetry,
    );
  }
}

class AppDependencies {
  final LocationService locationService;
  final NotificationService notificationService;
  final AzkarRepository azkarRepository;
  final GetQiblahBearing getQiblahBearing;
  final GetPreferredLocation getPreferredLocation;
  final TelemetryService telemetryService;
  AzkarStorage get azkarStorage => AzkarStorage();
  NotificationScheduler get scheduler => NotificationScheduler(
    notificationService,
    telemetryService: telemetryService,
  );
  AppDependencies({
    required this.locationService,
    required this.notificationService,
    required this.azkarRepository,
    required this.getQiblahBearing,
    required this.getPreferredLocation,
    required this.telemetryService,
  });
}

class App extends StatelessWidget {
  const App({super.key, required this.dep});
  final AppDependencies dep;

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.build();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: dep.locationService),
        RepositoryProvider.value(value: dep.notificationService),
        RepositoryProvider.value(value: dep.azkarRepository),
        RepositoryProvider.value(value: dep.telemetryService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) =>
                PrayerTimesCubit(dep.getPreferredLocation, dep.scheduler),
          ),
          BlocProvider(
            create: (ctx) =>
                QiblahCubit(dep.getPreferredLocation, dep.getQiblahBearing),
          ),
          BlocProvider(
            create: (ctx) => AzkarCubit(dep.azkarRepository, dep.azkarStorage),
          ),
          BlocProvider(create: (ctx) => ThemeCubit()..init()),
          BlocProvider(create: (ctx) => LocaleCubit()..init()),
          BlocProvider(create: (ctx) => TelemetryCubit(dep.telemetryService)),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            final theme = ThemeTokens.buildLightTheme(themeState.seedColor);
            final dark = ThemeTokens.buildDarkTheme(themeState.seedColor);
            return BlocBuilder<LocaleCubit, LocaleState>(
              builder: (context, locState) {
                return MaterialApp.router(
                  title: 'Azkar',
                  theme: theme,
                  darkTheme: dark,
                  themeMode: context.watch<ThemeCubit>().state.mode,
                  debugShowCheckedModeBanner: false,
                  routerConfig: router,
                  locale: locState.locale,
                  supportedLocales: const [Locale('ar'), Locale('en')],
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  builder: (context, child) {
                    final mediaQuery = MediaQuery.of(context);
                    return MediaQuery(
                      data: mediaQuery.copyWith(
                        textScaleFactor: themeState.textScale,
                      ),
                      child: child ?? const SizedBox.shrink(),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
