import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../../providers/repository_providers.dart';
import '../../router/routes.dart';
import 'items_provider.dart';

class ItemsScreen extends ConsumerStatefulWidget {
  const ItemsScreen({super.key});

  @override
  ConsumerState<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends ConsumerState<ItemsScreen> {
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _addItem() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      return;
    }

    await ref.read(itemRepositoryProvider).insert(title);
    _titleController.clear();
    if (mounted) {
      showFToast(context: context, title: const Text('Item added'));
    }
  }

  Future<void> _deleteItem(int id) async {
    await ref.read(itemRepositoryProvider).delete(id);
    if (mounted) {
      showFToast(context: context, title: const Text('Item deleted'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(itemsStreamProvider);

    return Padding(
      padding: const .all(16),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: 16,
        children: [
          Text(
            'Items',
            style: FTheme.of(context).typography.display.xl2.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: FTextField(
                  control: .managed(controller: _titleController),
                  hint: 'New item title',
                  onSubmit: (_) => _addItem(),
                ),
              ),
              FButton(
                onPress: _addItem,
                suffix: const Icon(FLucideIcons.plus),
                child: const Text('Add'),
              ),
            ],
          ),
          Expanded(
            child: itemsAsync.when(
              loading: () => const Center(child: FProgress()),
              error: (error, _) => FAlert(
                title: const Text('Error'),
                subtitle: Text('$error'),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'No items yet. Add one above.',
                      style: FTheme.of(context).typography.body.sm.copyWith(
                        color: FTheme.of(context).colors.mutedForeground,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const FDivider(),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return FItem(
                      title: Text(item.title),
                      subtitle: Text(
                        item.createdAt.toLocal().toString(),
                        style: FTheme.of(context).typography.body.xs.copyWith(
                          color: FTheme.of(context).colors.mutedForeground,
                        ),
                      ),
                      onPress: () => context.push(AppRoutes.itemDetail(item.id)),
                      suffix: FButton.icon(
                        variant: .outline,
                        onPress: () => _deleteItem(item.id),
                        child: const Icon(FLucideIcons.trash2, size: 16),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
