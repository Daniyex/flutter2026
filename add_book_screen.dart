
import 'package:flutter/material.dart';
import 'models/book.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _pagesController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _pagesController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if ((value ?? '').trim().length < 2) {
      return 'Title must be at least 2 characters';
    }
    return null;
  }

  String? _validateAuthor(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'Author is required';
    }
    return null;
  }

  String? _validatePages(String? value) {
    final n = int.tryParse(value ?? '');

    if (n == null || n <= 0) {
      return 'A whole number above 0';
    }

    return null;
  }

  String? _validateYear(String? value) {
    final text = (value ?? '').trim();

    if (text.isEmpty) {
      return null;
    }

    final year = int.tryParse(text);

    if (year == null ||
        year < 1450 ||
        year > DateTime.now().year) {
      return 'Enter a year from 1450 to ${DateTime.now().year}';
    }

    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final book = Book(
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      pages: int.parse(_pagesController.text.trim()),
      year: int.tryParse(_yearController.text.trim()),
    );

    Navigator.of(context).pop(book);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a book'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validateTitle,
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: 'Author',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validateAuthor,
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pagesController,
                  decoration: const InputDecoration(
                    labelText: 'Pages',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: _validatePages,
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _yearController,
                  decoration: const InputDecoration(
                    labelText: 'Year (optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: _validateYear,
                  onFieldSubmitted: (_) => _save(),
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text('Save book'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
