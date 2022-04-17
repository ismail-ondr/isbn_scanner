import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_library/providers/book_repository_provider.dart';
import 'package:my_library/providers/saved_library_books_provider.dart';

import '../book/book_types.dart';
import 'saved_books_provider.dart';

final bookProvider = FutureProvider.family<IBook, String>((ref, isbn) {
  final repository = ref.watch(bookRepositoryProvider);
  final asyncBook = repository.getBookByIsbn(isbn);

  return asyncBook.then((book) async {
    final savedBooksNotifier = ref.read(savedBooksProvider.notifier);
    await savedBooksNotifier.updateSavedBook(isbn, book);
    return book;
  });
});

final libraryBookProvider = FutureProvider.family<IBook, String>((ref, isbn) {
  final repository = ref.watch(bookRepositoryProvider);
  final asyncBook = repository.getLibraryBookByIsbn(isbn);

  return asyncBook.then((book) async {
    final savedBooksNotifier = ref.read(savedLibraryBooksProvider.notifier);
    await savedBooksNotifier.updateSavedBook(isbn, book);
    return book;
  });
});
