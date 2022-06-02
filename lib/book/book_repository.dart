import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'book_model.dart';
import 'book_types.dart';

class BookRepository implements IBookRepository {
  final _http = Dio(
    BaseOptions(baseUrl: 'https://www.goodreads.com'),
  );
  //final user = FirebaseAuth.instance.currentUser!.uid;

  @override
  Future<void> saveBookFirebase(IBook book) async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final docUser = FirebaseFirestore.instance
        .collection("users")
        .doc(user)
        .collection("toReadBooks")
        .doc(book.isbn);
    // final docUser =
    //     FirebaseFirestore.instance.collection("toReadBooks").doc(book.isbn);
    final json = book.toJson();
    await docUser.set(json);
  }

  @override
  Stream<List<IBook>> getSavedBooksFirebase() {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final a = FirebaseFirestore.instance
        .collection("users")
        .doc(user)
        .collection("toReadBooks")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList());
    return a;
  }
  // Stream<List<IBook>> getSavedBooksFirebase() => FirebaseFirestore.instance
  //     .collection("toReadBooks")
  //     .snapshots()
  //     .map((snapshot) =>
  //         snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList());

  @override
  Future<IBook> getBookByIsbnFirebase(String isbn) async {
    // final findedBook = FirebaseFirestore.instance
    //     .collection("toReadBooks")
    //     .snapshots()
    //     .map((snapshot) => snapshot.docs
    //         .where((element) => element["isbn"] == isbn)
    //         .map((e) => Book.fromJson(e.data()))
    //         .toList());
    final user = FirebaseAuth.instance.currentUser!.uid;
    final findedBook = FirebaseFirestore.instance
        .collection("users")
        .doc(user)
        .collection("toReadBooks")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((element) => element["isbn"] == isbn)
            .map((e) => Book.fromJson(e.data()))
            .toList());

    final a = await findedBook.first;
    if (!a.isEmpty) {
      return Book(
        isbn: isbn,
        title: a[0].title,
        authors: a[0].authors,
        rating: a[0].rating,
        description: a[0].description,
        coverUrl: a[0].coverUrl,
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
  Future<void> removeBookFirebase(IBook book) async {
    // final docUser =
    //     FirebaseFirestore.instance.collection("toReadBooks").doc(book.isbn);
    final user = FirebaseAuth.instance.currentUser!.uid;
    final docUser = FirebaseFirestore.instance
        .collection("users")
        .doc(user)
        .collection("toReadBooks")
        .doc(book.isbn);
    docUser.delete();
  }

  @override
  Future<void> saveLibraryBookFirebase(IBook book) async {
    // final docUser =
    //     FirebaseFirestore.instance.collection("libraryBooks2").doc(book.isbn);
    final user = FirebaseAuth.instance.currentUser!.uid;
    final docUser = FirebaseFirestore.instance
        .collection("users")
        .doc(user)
        .collection("libraryBooks2")
        .doc(book.isbn);
    final json = book.toJson();
    await docUser.set(json);
  }

  @override
  Future<IBook> getLibraryBookByIsbnFirebase(String isbn) async {
    // final findedBook = FirebaseFirestore.instance
    //     .collection("libraryBooks2")
    //     .snapshots()
    //     .map((snapshot) => snapshot.docs
    //         .where((element) => element["isbn"] == isbn)
    //         .map((e) => Book.fromJson(e.data()))
    //         .toList());
    final user = FirebaseAuth.instance.currentUser!.uid;
    final findedBook = FirebaseFirestore.instance
        .collection("users")
        .doc(user)
        .collection("libraryBooks2")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((element) => element["isbn"] == isbn)
            .map((e) => Book.fromJson(e.data()))
            .toList());
    final a = await findedBook.first;
    if (!a.isEmpty) {
      return Book(
        isbn: isbn,
        title: a[0].title,
        authors: a[0].authors,
        rating: a[0].rating,
        description: a[0].description,
        coverUrl: a[0].coverUrl,
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
        coverUrl: coverUrl);
  }

  @override
  // Stream<List<IBook>> getSavedLibraryBooksFirebase() =>
  //     FirebaseFirestore.instance.collection("libraryBooks2").snapshots().map(
  //         (snapshot) =>
  //             snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList());
  Stream<List<IBook>> getSavedLibraryBooksFirebase() {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final a = FirebaseFirestore.instance
        .collection("users")
        .doc(user)
        .collection("libraryBooks2")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList());
    return a;
  }

  @override
  Future<void> removeLibraryBookFirebase(IBook book) async {
    // final docUser =
    //     FirebaseFirestore.instance.collection("libraryBooks2").doc(book.isbn);
    final user = FirebaseAuth.instance.currentUser!.uid;
    final docUser = FirebaseFirestore.instance
        .collection("users")
        .doc(user)
        .collection("libraryBooks2")
        .doc(book.isbn);
    docUser.delete();
  }
}
