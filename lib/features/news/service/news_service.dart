import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/news.dart';

const String apiKey = 'c1a59a21dcbc414ca2477ffc7827f79b';

class NewsService {
  Future<List<News>> fetchNews() async {
    final url = Uri.parse(
      'https://newsapi.org/v2/everything?q=gold&apiKey=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load news');
    }

    final data = json.decode(response.body);
    final List list = data['articles'] as List;

    return list.map((e) => News.fromJson(e)).toList();
  }
}
