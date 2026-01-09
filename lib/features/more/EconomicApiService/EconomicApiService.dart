import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/economic_event.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class EconomicApiService {
  final String apiKey = "VFWhtAnxeRqREZ8y2VltchktyINjcHeE"; // Replace with your valid FMP API key
  final String baseUrl = "https://financialmodelingprep.com/api/v4/economic_calendar";

  Future<List<EconomicEvent>> fetchEvents({DateTime? fromDate, DateTime? toDate}) async {
    fromDate ??= DateTime.now();
    toDate ??= fromDate.add(const Duration(days: 7));

    final dateFormat = DateFormat('yyyy-MM-dd');
    final String from = dateFormat.format(fromDate);
    final String to = dateFormat.format(toDate);

    final uri = Uri.parse("$baseUrl?from=$from&to=$to&apikey=$apiKey");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => EconomicEvent.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load economic events: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}