import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../book/book_repository.dart';

final bookRepositoryProvider = Provider((_) {
  return BookRepository();
});
