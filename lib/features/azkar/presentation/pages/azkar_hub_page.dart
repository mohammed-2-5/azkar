import 'package:azkar/l10n/app_localizations.dart';
import 'package:azkar/ui/widgets/decorated_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AzkarHubPage extends StatelessWidget {
  const AzkarHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          const DecoratedBackgroundFill(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  Text(
                    l10n.hubTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.hubSubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _HubCard(
                    title: l10n.hubAzkarTitle,
                    description: l10n.hubAzkarDescription,
                    icon: Icons.self_improvement,
                    accent: Colors.tealAccent,
                    onPressed: () => context.push('/azkar/list'),
                    actionLabel: l10n.hubAzkarAction,
                  ),
                  const SizedBox(height: 16),
                  _HubCard(
                    title: l10n.hubHadithTitle,
                    description: l10n.hubHadithDescription,
                    icon: Icons.menu_book,
                    accent: Colors.orangeAccent,
                    onPressed: () => context.push('/azkar/hadith'),
                    actionLabel: l10n.hubHadithAction,
                  ),
                  const SizedBox(height: 16),
                  _HubCard(
                    title: l10n.hubFortyTitle,
                    description: l10n.hubFortyDescription,
                    icon: Icons.collections_bookmark,
                    accent: Colors.purpleAccent,
                    onPressed: () => context.push('/azkar/forties'),
                    actionLabel: l10n.hubFortyAction,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HubCard extends StatelessWidget {
  const _HubCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    required this.onPressed,
    required this.actionLabel,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accent;
  final VoidCallback onPressed;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: accent, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: onPressed, child: Text(actionLabel)),
        ],
      ),
    );
  }
}
