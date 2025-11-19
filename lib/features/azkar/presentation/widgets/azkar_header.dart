import 'package:flutter/material.dart';
import 'package:azkar/l10n/app_localizations.dart';
import '../../../../ui/widgets/decorated_header.dart';

class AzkarHeader extends StatelessWidget {
  const AzkarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DecoratedHeader(
      height: 200,
      title: l10n.azkarTitle,
      subtitle: 'Morning • Evening • After Prayer • Sleep',
    );
  }
}

