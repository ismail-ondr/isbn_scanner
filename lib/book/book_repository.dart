import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'book_model.dart';
import 'book_types.dart';

class BookRepository implements IBookRepository {
  final _http = Dio(
    BaseOptions(baseUrl: 'https://www.goodreads.com'),
  );

  @override
  Future<IBook> getBookByIsbn(String isbn) async {
    ///
    final preferences = await SharedPreferences.getInstance();

    final savedBooks = preferences.getStringList('savedBooks') ?? [];
    final isbns = savedBooks
        .map((e) => Book.fromJson(json.decode(e)))
        .map((e) => e.isbn)
        .toList();
    final bookList = savedBooks
        .map((e) => Book.fromJson(json.decode(e)))
        .where((element) => element.isbn == isbn)
        .toList();

    if (isbns.contains(isbn)) {
      return Book(
        isbn: isbn,
        title: bookList[0].title,
        authors: bookList[0].authors,
        rating: bookList[0].rating,
        description: bookList[0].description,
        coverUrl: bookList[0].coverUrl,
      );
    }

    ///
    final response = await _http.get('/book/isbn/$isbn');
    final document = parse(response.data);

    final title = document.querySelector('h1#bookTitle')?.text.trim();

    final authors = document
        .querySelectorAll('#bookAuthors .authorName__container')
        .where((element) => element.querySelector('.role') == null)
        .map((e) => e.querySelector('[itemprop=name]')!.text.trim())
        .toList();

    final rating = double.parse(
      document.querySelector('#bookMeta [itemprop="ratingValue"]')?.text ?? '0',
    );

    final description = document
        .querySelector('#description [style="display:none"]')
        ?.text
        .trim();

    final coverUrl = document.querySelector('#coverImage')?.attributes['src'];

    if (title == null ||
        authors.isEmpty ||
        description == null ||
        coverUrl == null) {
      throw Exception('Book not found');
    }

    return Book(
      isbn: isbn,
      title: title,
      authors: authors,
      rating: rating,
      description: description,
      coverUrl: coverUrl,
    );
  }

  @override
  Future<void> saveBook(IBook book) async {
    final preferences = await SharedPreferences.getInstance();

    final savedBooks = preferences.getStringList('savedBooks') ?? [];
    final isbns = savedBooks
        .map((e) => Book.fromJson(json.decode(e)))
        .map((e) => e.isbn)
        .toList();

    if (!isbns.contains(book.isbn)) {
      final json = jsonEncode(book.toJson());
      savedBooks.add(json);
      preferences.setStringList('savedBooks', savedBooks);
    }
  }

  @override
  Future<void> removeBook(IBook book) async {
    final preferences = await SharedPreferences.getInstance();

    final savedBooks = preferences.getStringList('savedBooks') ?? [];
    final isbns = savedBooks
        .map((e) => Book.fromJson(json.decode(e)))
        .map((e) => e.isbn)
        .toList();

    if (isbns.contains(book.isbn)) {
      final json = jsonEncode(book.toJson());
      savedBooks.remove(json);
      preferences.setStringList('savedBooks', savedBooks);
    }
  }

  @override
  Future<void> updateBook(String isbn, IBook book) async {
    final preferences = await SharedPreferences.getInstance();
    final savedBooks = preferences.getStringList('savedBooks') ?? [];

    final newSavedBooks = savedBooks.map((savedBookJson) {
      final savedBook = Book.fromJson(json.decode(savedBookJson));
      if (savedBook.isbn == isbn) return json.encode(book.toJson());
      return savedBookJson;
    }).toList();

    preferences.setStringList('savedBooks', newSavedBooks);
  }

  @override
  Future<List<Book>> getSavedBooks() async {
    final preferences = await SharedPreferences.getInstance();

    final savedBooks = preferences.getStringList('savedBooks') ?? [];
    return savedBooks.map((e) => Book.fromJson(json.decode(e))).toList();
  }

  @override
  Future<List<IBook>> getSavedLibraryBooks() async {
    final preferences = await SharedPreferences.getInstance();

    final savedBooks = preferences.getStringList('savedLibraryBooks') ?? [];
    return savedBooks.map((e) => Book.fromJson(json.decode(e))).toList();
  }

  @override
  Future<void> removeLibraryBook(IBook book) async {
    final preferences = await SharedPreferences.getInstance();

    final savedBooks = preferences.getStringList('savedLibraryBooks') ?? [];
    final isbns = savedBooks
        .map((e) => Book.fromJson(json.decode(e)))
        .map((e) => e.isbn)
        .toList();

    if (isbns.contains(book.isbn)) {
      final json = jsonEncode(book.toJson());
      savedBooks.remove(json);
      preferences.setStringList('savedLibraryBooks', savedBooks);
    }
  }

  @override
  Future<void> saveLibraryBook(IBook book) async {
    final preferences = await SharedPreferences.getInstance();

    final savedBooks = preferences.getStringList('savedLibraryBooks') ?? [];
    final isbns = savedBooks
        .map((e) => Book.fromJson(json.decode(e)))
        .map((e) => e.isbn)
        .toList();

    if (!isbns.contains(book.isbn)) {
      final json = jsonEncode(book.toJson());
      savedBooks.add(json);
      preferences.setStringList('savedLibraryBooks', savedBooks);
    }
  }

  @override
  Future<void> updateLibraryBook(String isbn, IBook book) async {
    final preferences = await SharedPreferences.getInstance();
    final savedBooks = preferences.getStringList('savedLibraryBooks') ?? [];

    final newSavedBooks = savedBooks.map((savedBookJson) {
      final savedBook = Book.fromJson(json.decode(savedBookJson));
      if (savedBook.isbn == isbn) return json.encode(book.toJson());
      return savedBookJson;
    }).toList();

    preferences.setStringList('savedLibraryBooks', newSavedBooks);
  }

  @override
  Future<IBook> getLibraryBookByIsbn(String isbn) async {
    final preferences = await SharedPreferences.getInstance();

    final savedBooks = preferences.getStringList('savedLibraryBooks') ?? [];
    final isbns = savedBooks
        .map((e) => Book.fromJson(json.decode(e)))
        .map((e) => e.isbn)
        .toList();
    final bookList = savedBooks
        .map((e) => Book.fromJson(json.decode(e)))
        .where((element) => element.isbn == isbn)
        .toList();

    if (isbns.contains(isbn)) {
      return Book(
        isbn: isbn,
        title: bookList[0].title,
        authors: bookList[0].authors,
        rating: bookList[0].rating,
        description: bookList[0].description,
        coverUrl: bookList[0].coverUrl,
      );
    }

    ///
    final response = await _http.get('/book/isbn/$isbn');
    final document = parse(response.data);

    final title = document.querySelector('h1#bookTitle')?.text.trim();

    final authors = document
        .querySelectorAll('#bookAuthors .authorName__container')
        .where((element) => element.querySelector('.role') == null)
        .map((e) => e.querySelector('[itemprop=name]')!.text.trim())
        .toList();

    final rating = double.parse(
      document.querySelector('#bookMeta [itemprop="ratingValue"]')?.text ?? '0',
    );

    final description = document
        .querySelector('#description [style="display:none"]')
        ?.text
        .trim();

    final coverUrl = document.querySelector('#coverImage')?.attributes['src'];

    if (title == null ||
        authors.isEmpty ||
        description == null ||
        coverUrl == null) {
      throw Exception('Book not found');
    }

    return Book(
      isbn: isbn,
      title: title,
      authors: authors,
      rating: rating,
      description: description,
      coverUrl: coverUrl,
    );
  }
}
