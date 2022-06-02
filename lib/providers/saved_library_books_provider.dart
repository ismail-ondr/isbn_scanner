import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_library/providers/book_repository_provider.dart';

import '../book/book_types.dart';

class SavedLibraryBooksNotifier extends StateNotifier<List<IBook>> {
  final IBookRepository bookRepository;

  SavedLibraryBooksNotifier({required this.bookRepository}) : super([]) {
    loadSavedBooks();
  }

  Future<void> loadSavedBooks() async {
    //state = await bookRepository.getSavedLibraryBooks();
    state = await bookRepository.getSavedLibraryBooksFirebase().first;
    int a = 0;
  }

  Future<void> toggleSavedBook(IBook book) async {
    final isBookmarked = state.any((bookmark) => bookmark.isbn == book.isbn);

    if (isBookmarked) {
      //await bookRepository.removeLibraryBook(book);
      await bookRepository.removeLibraryBookFirebase(book);
    } else {
      //await bookRepository.saveLibraryBook(book);
      await bookRepository.saveLibraryBookFirebase(book);
    }

    await loadSavedBooks();
  }

  Future<void> updateSavedBook(String isbn, IBook book) async {
    print('$isbn: ${book.rating}');
    //await bookRepository.updateLibraryBook(isbn, book);
    await loadSavedBooks();
  }

  int savedBookCount() {
    final count = bookRepository.getSavedBooksFirebase().first;
    return 1;
  }
}

final savedLibraryBooksProvider =
    StateNotifierProvider<SavedLibraryBooksNotifier, List<IBook>>(
  (ref) {
    final bookRepository = ref.read(bookRepositoryProvider);
    return SavedLibraryBooksNotifier(bookRepository: bookRepository);
  },
);
