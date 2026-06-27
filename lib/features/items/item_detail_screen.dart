import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import 'items_provider.dart';

class ItemDetailScreen extends ConsumerWidget {
  const ItemDetailScreen({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(itemProvider(id));

    return FScaffold(
      header: FHeader.nested(
        title: const Text('Item Detail'),
        prefixes: [
          FHeaderAction.back(onPress: () => context.pop()),
        ],
      ),
      child: itemAsync.when(
        loading: () => const Center(child: FProgress()),
        error: (error, _) => FAlert(
          title: const Text('Error'),
          subtitle: Text('$error'),
        ),
        data: (item) {
          if (item == null) {
            return const Center(child: Text('Item not found'));
          }

          return Padding(
            padding: const .all(16),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 12,
              children: [
                Text(
                  item.title,
                  style: FTheme.of(context).typography.display.xl2.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FCard(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 8,
                    children: [
                      Text('ID: ${item.id}'),
                      Text('Created: ${item.createdAt.toLocal()}'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
