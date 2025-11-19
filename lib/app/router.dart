import 'dart:ui';

import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/theme_tokens.dart';
import '../features/azkar/presentation/pages/azkar_hub_page.dart';
import '../features/azkar/presentation/pages/azkar_page.dart';
import '../features/forties/presentation/pages/forties_collections_page.dart';
import '../features/forties/presentation/pages/forties_reader_page.dart';
import '../features/hadith/presentation/pages/hadith_collections_page.dart';
import '../features/hadith/presentation/pages/hadith_reader_page.dart';
import '../features/prayer_times/presentation/pages/notifications_page.dart';
import '../features/prayer_times/presentation/pages/prayer_times_page.dart';
import '../features/qiblah/presentation/pages/qiblah_page.dart';
import '../features/quran/presentation/pages/quran_page.dart';
import '../features/quran/presentation/pages/quran_reader_page.dart';
import '../features/settings/appearance_page.dart';
import '../features/settings/language_page.dart';
import '../features/shared/models/text_collection_summary.dart';

class AppRouter {
  static GoRouter build() {
    return GoRouter(
      initialLocation: '/prayer',
      routes: [
        ShellRoute(
          builder: (context, state, child) => _NavScaffold(child: child),
          routes: [
            GoRoute(
              path: '/prayer',
              name: 'prayer',
              pageBuilder: (ctx, st) =>
                  const NoTransitionPage(child: PrayerTimesPage()),
            ),
            GoRoute(
              path: '/appearance',
              name: 'appearance',
              pageBuilder: (ctx, st) =>
                  const NoTransitionPage(child: AppearancePage()),
            ),
            GoRoute(
              path: '/language',
              name: 'language',
              pageBuilder: (ctx, st) =>
                  const NoTransitionPage(child: LanguagePage()),
            ),
            GoRoute(
              path: '/notifications',
              name: 'notifications',
              pageBuilder: (ctx, st) =>
                  const NoTransitionPage(child: NotificationsPage()),
            ),
            GoRoute(
              path: '/qiblah',
              name: 'qiblah',
              pageBuilder: (ctx, st) =>
                  const NoTransitionPage(child: QiblahPage()),
            ),
            GoRoute(
              path: '/quran',
              name: 'quran',
              pageBuilder: (ctx, st) =>
                  const NoTransitionPage(child: QuranPage()),
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'quran-reader',
                  pageBuilder: (ctx, st) {
                    final id =
                        int.tryParse(st.pathParameters['id'] ?? '1') ?? 1;
                    final ayah = int.tryParse(
                      st.uri.queryParameters['ayah'] ?? '0',
                    );
                    return NoTransitionPage(
                      child: QuranReaderPage(
                        id: id,
                        initialAyah: ayah == 0 ? null : ayah,
                      ),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/azkar',
              name: 'azkar',
              pageBuilder: (ctx, st) =>
                  const NoTransitionPage(child: AzkarHubPage()),
              routes: [
                GoRoute(
                  path: 'list',
                  name: 'azkar-list',
                  pageBuilder: (ctx, st) =>
                      const NoTransitionPage(child: AzkarPage()),
                ),
                GoRoute(
                  path: 'hadith',
                  name: 'hadith-collections',
                  pageBuilder: (ctx, st) =>
                      const NoTransitionPage(child: HadithCollectionsPage()),
                  routes: [
                    GoRoute(
                      path: ':id',
                      name: 'hadith-reader',
                      pageBuilder: (ctx, st) {
                        final id = st.pathParameters['id'] ?? '';
                        final summary = st.extra as TextCollectionSummary?;
                        return NoTransitionPage(
                          child: HadithReaderPage(
                            collectionId: id,
                            initialSummary: summary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'forties',
                  name: 'forties-collections',
                  pageBuilder: (ctx, st) =>
                      const NoTransitionPage(child: FortiesCollectionsPage()),
                  routes: [
                    GoRoute(
                      path: ':id',
                      name: 'forties-reader',
                      pageBuilder: (ctx, st) {
                        final id = st.pathParameters['id'] ?? '';
                        final summary = st.extra as TextCollectionSummary?;
                        return NoTransitionPage(
                          child: FortiesReaderPage(
                            collectionId: id,
                            initialSummary: summary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _NavScaffold extends StatelessWidget {
  const _NavScaffold({required this.child});
  final Widget child;

  int _indexForLocation(String location) {
    if (location.startsWith('/qiblah')) return 1;
    if (location.startsWith('/quran')) return 2;
    if (location.startsWith('/azkar')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    final index = _indexForLocation(loc);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final navBar = NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: ThemeTokens.jade.withValues(alpha: 0.18),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 64,
        labelTextStyle: WidgetStateProperty.all(
          theme.textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/prayer');
              break;
            case 1:
              context.go('/qiblah');
              break;
            case 2:
              context.go('/quran');
              break;
            case 3:
              context.go('/azkar');
              break;
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.access_time_outlined),
            selectedIcon: const Icon(Icons.access_time_filled),
            label: l10n.navPrayer,
          ),
          NavigationDestination(
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore),
            label: l10n.navQiblah,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l10n.navQuran,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_border),
            selectedIcon: const Icon(Icons.favorite),
            label: l10n.navAzkar,
          ),
        ],
      ),
    );
    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                ThemeTokens.borderRadiusLarge,
              ),
              gradient: ThemeTokens.glassGradient,
              boxShadow: ThemeTokens.elevatedShadow,
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                ThemeTokens.borderRadiusLarge,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: navBar,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
