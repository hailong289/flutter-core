import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/async_state_view.dart';
import '../../domain/entities/item.dart';
import '../../providers/repository_providers.dart';
import 'items_provider.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  const ItemDetailScreen({required this.id, super.key});

  final int id;

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _titleError;
  bool _initialized = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _bindItem(Item item) {
    if (_initialized) {
      return;
    }
    _titleController.text = item.title;
    _descriptionController.text = item.description ?? '';
    _initialized = true;
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

  Future<void> _save(Item item) async {
    if (!_validateTitle()) {
      return;
    }

    final description = _descriptionController.text.trim();
    await ref.read(itemRepositoryProvider).update(
      item.copyWith(
        title: _titleController.text.trim(),
        description: description.isEmpty ? null : description,
      ),
    );
    ref.invalidate(itemProvider(widget.id));
    if (mounted) {
      showFToast(context: context, title: const Text('Item saved'));
    }
  }

  Future<void> _confirmDelete(Item item) async {
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
      await ref.read(itemRepositoryProvider).delete(item.id);
      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemAsync = ref.watch(itemProvider(widget.id));

    return FScaffold(
      header: FHeader.nested(
        title: const Text('Item Detail'),
        prefixes: [
          FHeaderAction.back(onPress: () => context.pop()),
        ],
        suffixes: [
          FHeaderAction(
            icon: const Icon(FLucideIcons.trash2),
            onPress: () {
              final item = itemAsync.valueOrNull;
              if (item != null) {
                _confirmDelete(item);
              }
            },
          ),
        ],
      ),
      child: AsyncStateView<Item?>(
        value: itemAsync,
        onRetry: () => ref.invalidate(itemProvider(widget.id)),
        empty: () => const Center(child: Text('Item not found')),
        data: (item) {
          if (item == null) {
            return const Center(child: Text('Item not found'));
          }

          _bindItem(item);

          return Padding(
            padding: const .all(16),
            child: Column(
              crossAxisAlignment: .stretch,
              spacing: 12,
              children: [
                FTextField(
                  control: .managed(controller: _titleController),
                  label: const Text('Title'),
                  error: _titleError == null ? null : Text(_titleError!),
                ),
                FTextField(
                  control: .managed(controller: _descriptionController),
                  label: const Text('Description'),
                  maxLines: 4,
                ),
                FCard(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 8,
                    children: [
                      Text('ID: ${item.id}'),
                      Text('Created: ${item.createdAt.toLocal()}'),
                      Text('Updated: ${item.updatedAt.toLocal()}'),
                    ],
                  ),
                ),
                FButton(
                  onPress: () => _save(item),
                  suffix: const Icon(FLucideIcons.save),
                  child: const Text('Save changes'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
