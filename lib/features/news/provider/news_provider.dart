import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/news.dart';
import '../service/news_service.dart';

final newsProvider = FutureProvider<List<News>>((ref) async {
  final service = NewsService();
  return service.fetchNews();
});
