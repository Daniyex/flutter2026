
import 'package:flutter/material.dart';
import 'models/book.dart';

enum BookAction { toggleRead, delete }

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.book,
  });

  final Book book;

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm deletion'),
          content: Text("Delete '${book.title}'?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return;

    if (confirmed == true) {
      Navigator.of(context).pop(BookAction.delete);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Icon(
            Icons.menu_book,
            size: 72,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            book.title,
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Author'),
            subtitle: Text(book.author),
          ),
          ListTile(
            leading: const Icon(Icons.auto_stories),
            title: const Text('Pages'),
            subtitle: Text('${book.pages}'),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Year'),
            subtitle: Text('${book.year ?? 'Year unknown'}'),
          ),
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text('Status'),
            subtitle: Text(book.read ? 'Read' : 'Unread'),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop(BookAction.toggleRead);
            },
            icon: const Icon(Icons.check),
            label: Text(
              book.read ? 'Mark as unread' : 'Mark as read',
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _delete(context),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
