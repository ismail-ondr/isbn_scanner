abstract class IBook {
  String get isbn;
  String get title;
  List<String> get authors;
  double get rating;
  String get description;
  String get coverUrl;
  Map<String, dynamic> toJson();
}

abstract class IBookRepository {
  Future<IBook> getBookByIsbnFirebase(String isbn);
  Future<void> saveBookFirebase(IBook book);
  Future<void> removeBookFirebase(IBook book);
  Stream<List<IBook>> getSavedBooksFirebase();

  Future<IBook> getLibraryBookByIsbnFirebase(String isbn);
  Future<void> saveLibraryBookFirebase(IBook book);
  Future<void> removeLibraryBookFirebase(IBook book);
  Stream<List<IBook>> getSavedLibraryBooksFirebase();
}
