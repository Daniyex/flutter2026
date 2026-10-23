
import 'package:flutter/material.dart';

import 'models/book.dart';
import 'widgets/book_tile.dart';
import 'detail_screen.dart';
import 'add_book_screen.dart';

enum Filter { all, unread, read }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Book> _books = [...seed];
  Filter _filter = Filter.all;

  List<Book> get _visible => switch (_filter) {
        Filter.all => _books,
        Filter.unread => unread(_books),
        Filter.read =>
          _books.where((book) => book.read).toList(),
      };

  Future<void> _openDetails(Book book) async {
    final action = await Navigator.of(context).push<BookAction>(
      MaterialPageRoute(
        builder: (_) => DetailScreen(book: book),
      ),
    );

    if (!mounted) return;

    switch (action) {
      case null:
        break;
      case BookAction.toggleRead:
        setState(() {
          book.read = !book.read;
        });
      case BookAction.delete:
        setState(() {
          _books.remove(book);
        });
    }
  }

  Future<void> _addBook() async {
    final book = await Navigator.of(context).push<Book>(
      MaterialPageRoute(
        builder: (_) => const AddBookScreen(),
      ),
    );

    if (!mounted || book == null) return;

    setState(() {
      _books.add(book);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reading list (${_visible.length})'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        tooltip: 'Add book',
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    _StatColumn(
                      label: 'Books',
                      value: '${_books.length}',
                      style: textTheme,
                    ),
                    _StatColumn(
                      label: 'Pages',
                      value: '${totalPages(_books)}',
                      style: textTheme,
                    ),
                    _StatColumn(
                      label: 'Unread',
                      value: '${unread(_books).length}',
                      style: textTheme,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: Filter.values.map((filter) {
                  final label = switch (filter) {
                    Filter.all => 'All',
                    Filter.unread => 'Unread',
                    Filter.read => 'Read',
                  };

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: _filter == filter,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _filter = filter;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: _visible.isEmpty
                  ? const Center(
                      child: Text('No books in this filter.'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        12, 0, 12, 88,
                      ),
                      itemCount: _visible.length,
                      itemBuilder: (context, index) {
                        final book = _visible[index];

                        return BookTile(
                          book: book,
                          onToggle: () {
                            setState(() {
                              book.read = !book.read;
                            });
                          },
                          onTap: () => _openDetails(book),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.label,
    required this.value,
    required this.style,
  });

  final String label;
  final String value;
  final TextTheme style;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: style.headlineSmall),
          Text(label, style: style.bodySmall),
        ],
      ),
    );
  }
}
