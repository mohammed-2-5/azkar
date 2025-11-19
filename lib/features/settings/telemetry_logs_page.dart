import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/telemetry/telemetry_cubit.dart';
import '../../core/telemetry/telemetry_service.dart';

class TelemetryLogsPage extends StatefulWidget {
  const TelemetryLogsPage({super.key});

  @override
  State<TelemetryLogsPage> createState() => _TelemetryLogsPageState();
}

class _TelemetryLogsPageState extends State<TelemetryLogsPage> {
  TelemetryEntryType? _filter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final telemetryCubit = context.watch<TelemetryCubit>();
    final logEntries = telemetryCubit.entries;
    final filteredEntries = _filter == null
        ? logEntries
        : logEntries.where((entry) => entry.type == _filter).toList();
    final telemetryEnabled = telemetryCubit.state;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.telemetryTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            tooltip: l10n.telemetrySaveLogs,
            onPressed: logEntries.isEmpty ? null : () => _saveLogs(context),
          ),
          IconButton(
            icon: const Icon(Icons.copy_all),
            tooltip: l10n.telemetryCopyLogs,
            onPressed: logEntries.isEmpty ? null : () => _copyLogs(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: l10n.telemetryClearLogs,
            onPressed: logEntries.isEmpty ? null : () => _confirmClear(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              telemetryEnabled
                  ? l10n.telemetryEnabledBody
                  : l10n.telemetryDisabledBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.telemetryFilterAll),
                  selected: _filter == null,
                  onSelected: (_) => setState(() => _filter = null),
                ),
                ChoiceChip(
                  label: Text(l10n.telemetryFilterEvents),
                  selected: _filter == TelemetryEntryType.event,
                  onSelected: (_) =>
                      setState(() => _filter = TelemetryEntryType.event),
                ),
                ChoiceChip(
                  label: Text(l10n.telemetryFilterErrors),
                  selected: _filter == TelemetryEntryType.error,
                  onSelected: (_) =>
                      setState(() => _filter = TelemetryEntryType.error),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredEntries.isEmpty
                  ? Center(
                      child: Text(
                        logEntries.isEmpty
                            ? l10n.telemetryEmpty
                            : l10n.telemetryEmptyFilter,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredEntries.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final entry = filteredEntries[index];
                        final timestamp = DateFormat.Hm().add_yMd().format(
                          entry.timestamp,
                        );
                        final metadata = _formatData(entry.data);
                        return ListTile(
                          onTap: () => _showDetails(context, entry),
                          leading: Icon(
                            entry.type == TelemetryEntryType.error
                                ? Icons.error_outline
                                : Icons.event_note_outlined,
                            color: entry.type == TelemetryEntryType.error
                                ? Colors.redAccent
                                : Colors.blueAccent,
                          ),
                          title: Text(entry.label),
                          subtitle: Text(
                            metadata == null
                                ? timestamp
                                : '$timestamp • $metadata',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String? _formatData(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return null;
    return data.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join(', ');
  }

  Future<void> _copyLogs(BuildContext context) async {
    final cubit = context.read<TelemetryCubit>();
    final export = cubit.exportLog();
    if (export.isEmpty) return;
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: export));
    messenger.showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.telemetryCopySuccess),
      ),
    );
  }

  Future<void> _saveLogs(BuildContext context) async {
    final cubit = context.read<TelemetryCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    try {
      final path = await cubit.saveLogToFile();
      if (path == null) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.telemetrySaveError)),
        );
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.telemetrySaveSuccess(path))),
      );
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.telemetrySaveError)));
    }
  }

  Future<void> _confirmClear(BuildContext context) async {
    final cubit = context.read<TelemetryCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.telemetryClearConfirmTitle),
            content: Text(l10n.telemetryClearConfirmBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.telemetryClearConfirmCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.telemetryClearConfirmAction),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;
    await cubit.clearLog();
    messenger.showSnackBar(SnackBar(content: Text(l10n.telemetryLogCleared)));
  }

  void _showDetails(BuildContext context, TelemetryEntry entry) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(DateFormat.yMMMd().add_Hms().format(entry.timestamp)),
              const SizedBox(height: 12),
              if (entry.data == null || entry.data!.isEmpty)
                Text(l10n.telemetryNoData, style: theme.textTheme.bodyMedium)
              else
                ...entry.data!.entries.map(
                  (kv) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('${kv.key}: ${kv.value}'),
                  ),
                ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _copySingleEntry(entry);
                  },
                  icon: const Icon(Icons.copy),
                  label: Text(l10n.telemetryCopyLogs),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _copySingleEntry(TelemetryEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final payload = StringBuffer()
      ..writeln(
        '${entry.timestamp.toIso8601String()} [${entry.type.name}] ${entry.label}',
      )
      ..writeln(
        entry.data == null ? l10n.telemetryNoData : entry.data.toString(),
      );
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: payload.toString()));
    messenger.showSnackBar(SnackBar(content: Text(l10n.telemetryEntryCopied)));
  }
}
