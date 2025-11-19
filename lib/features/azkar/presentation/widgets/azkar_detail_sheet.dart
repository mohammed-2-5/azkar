import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/azkar_item.dart';
import '../../presentation/cubit/azkar_cubit.dart';

Future<void> showAzkarDetailSheet(
  BuildContext context,
  AzkarItem item,
  int remaining,
) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      final viewInsets = MediaQuery.of(context).viewInsets.bottom;
      final padBottom = MediaQuery.of(context).padding.bottom;
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + viewInsets + padBottom,
          top: 8,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SelectableText(
                item.content,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.repeat),
                  const SizedBox(width: 8),
                  Text('Repeat: ${item.repeat}'),
                  const Spacer(),
                  _CounterBadge(remaining: remaining),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.read<AzkarCubit>().decrement(item),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Count 1'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _CounterBadge extends StatelessWidget {
  const _CounterBadge({required this.remaining});
  final int remaining;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Remaining: $remaining',
        style: const TextStyle(color: Colors.green),
      ),
    );
  }
}
