import 'dart:convert';
import 'dart:io';

import 'package:bcall/model/book_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class BookService {
  static const String url =
      'https://raw.githubusercontent.com/brownsley/e-books/main/data.json';

  Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load books (Code: ${response.statusCode})');
    }

    final List<dynamic> data = jsonDecode(response.body);
    final books = data.map((item) => Book.fromJson(item)).toList();

    await checkLocalFiles(books);

    return books;
  }

  Future<void> checkLocalFiles(List<Book> books) async {
    final directory = await getApplicationDocumentsDirectory();

    for (final book in books) {
      final path = '${directory.path}/${book.title.replaceAll(' ', '_')}.pdf';

      if (await File(path).exists()) {
        book.localPath = path;
      }
    }
  }

  Future<String> downloadBook(
    Book book, {
    required void Function(double progress) onProgress,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${book.title.replaceAll(' ', '_')}.pdf';

    await Dio().download(
      book.pdfUrl,
      path,
      onReceiveProgress: (received, total) {
        if (total > 0) {
          onProgress(received / total);
        }
      },
    );

    return path;
  }
}
