import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.example.com'; // API adresinizi buraya yazın

  static Future<http.Response> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.get(url);
  }

  // POST, PUT, DELETE gibi diğer metodlar da eklenebilir
}
