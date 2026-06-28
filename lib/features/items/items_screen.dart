import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/async_state_view.dart';
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
  final _descriptionController = TextEditingController();
  String? _titleError;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool _validateTitle() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _titleError = 'Title is required');
      return false;
    }
    if (title.length > 200) {
      setState(() => _titleError = 'Title must be at most 200 characters');
      return false;
    }
    setState(() => _titleError = null);
    return true;
  }

  Future<void> _addItem() async {
    if (!_validateTitle()) {
      return;
    }

    final description = _descriptionController.text.trim();
    await ref.read(itemRepositoryProvider).create(
      title: _titleController.text.trim(),
      description: description.isEmpty ? null : description,
    );
    _titleController.clear();
    _descriptionController.clear();
    if (mounted) {
      showFToast(context: context, title: const Text('Item added'));
    }
  }

  Future<void> _confirmDelete(int id) async {
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (context, style, animation) => FDialog(
        animation: animation,
        style: style,
        title: const Text('Delete item?'),
        body: const Text('This action cannot be undone.'),
        actions: [
          FButton(
            onPress: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FButton(
            variant: .destructive,
            onPress: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(itemRepositoryProvider).delete(id);
      if (mounted) {
        showFToast(context: context, title: const Text('Item deleted'));
      }
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
          FTextField(
            control: .managed(controller: _titleController),
            hint: 'Title *',
            error: _titleError == null ? null : Text(_titleError!),
            onSubmit: (_) => _addItem(),
          ),
          FTextField(
            control: .managed(controller: _descriptionController),
            hint: 'Description (optional)',
            maxLines: 2,
            onSubmit: (_) => _addItem(),
          ),
          FButton(
            onPress: _addItem,
            suffix: const Icon(FLucideIcons.plus),
            child: const Text('Add item'),
          ),
          Expanded(
            child: AsyncStateView(
              value: itemsAsync,
              onRetry: () => ref.invalidate(itemsStreamProvider),
              empty: () => Center(
                child: Text(
                  'No items yet. Add one above.',
                  style: FTheme.of(context).typography.body.sm.copyWith(
                    color: FTheme.of(context).colors.mutedForeground,
                  ),
                ),
              ),
              data: (items) => ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, _) => const FDivider(),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return FItem(
                    title: Text(item.title),
                    subtitle: Text(
                      item.description?.isNotEmpty == true
                          ? item.description!
                          : item.updatedAt.toLocal().toString(),
                      style: FTheme.of(context).typography.body.xs.copyWith(
                        color: FTheme.of(context).colors.mutedForeground,
                      ),
                    ),
                    onPress: () => context.push(AppRoutes.itemDetail(item.id)),
                    suffix: FButton.icon(
                      variant: .outline,
                      onPress: () => _confirmDelete(item.id),
                      child: const Icon(FLucideIcons.trash2, size: 16),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
