import 'package:http/http.dart' as http;

const apiKey = '36734116-1c72c0b193012e7687e321172';

class Api {
  static Future<http.Response> fetchImages(String query, int page) async {
    final response = await http.get(Uri.parse(
        'https://pixabay.com/api/?key=$apiKey&q=$query&page=$page&per_page=20'));
    return response;
  }
}