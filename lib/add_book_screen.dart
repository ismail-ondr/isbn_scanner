// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/book/book.dart';
import 'package:my_library/providers/saved_books_provider.dart';
import 'package:my_library/providers/saved_library_books_provider.dart';

import 'providers/saved_books_provider.dart';

class AddBookScreen extends ConsumerStatefulWidget {
  final int page;
  const AddBookScreen({Key? key, required this.page}) : super(key: key);

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends ConsumerState<AddBookScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _saveBook(String isbn, String bookName, String author,
      String description, double rating, String url) async {
    List<String> writers = [author];
    if (rating > 5) rating = 5;

    Book book = new Book(
        isbn: isbn,
        title: bookName,
        authors: writers,
        rating: rating,
        description: description,
        coverUrl: url);
    //SavedBooksNotifier savedBooksNotifier;
    if (widget.page == 0) {
      final notifier = ref.read(savedBooksProvider.notifier);
      await notifier.toggleSavedBook(book);
    }
    if (widget.page == 1) {
      final notifier = ref.read(savedLibraryBooksProvider.notifier);
      await notifier.toggleSavedBook(book);
    }
  }

  Widget deneme() {
    final isbnController = TextEditingController();
    final bookNameController = TextEditingController();
    final authorController = TextEditingController();
    final descriptionController = TextEditingController();
    final ratingController = TextEditingController();
    final urlController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: isbnController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'ISBN',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: bookNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Kitap Adı',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: authorController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Yazar',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Detay',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: ratingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Puan max 5',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: urlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Kapak Url',
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              onPressed: () {
                _saveBook(
                    isbnController.text,
                    bookNameController.text,
                    authorController.text,
                    descriptionController.text,
                    double.parse(ratingController.text),
                    urlController.text);
                Navigator.of(context).pop();
              },
              child: Text('Kaydet'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        title: Text(
          'Manuel Ekleme',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left, size: 32),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: deneme(),
    );
  }
}
