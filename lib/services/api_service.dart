import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://kuafi-api.laurelsoftware.com';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<http.Response> getRequest(String endpoint, {bool withAuth = true}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    Map<String, String> headers = {'Content-Type': 'application/json'};
    if (withAuth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return await http.get(url, headers: headers);
  }

  static Future<http.Response> postRequest(String endpoint, {Object? body, bool withAuth = true}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    Map<String, String> headers = {'Content-Type': 'application/json'};
    if (withAuth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return await http.post(url, headers: headers, body: body);
  }

  static Future<http.Response> putRequest(String endpoint, {Object? body, bool withAuth = true}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    Map<String, String> headers = {'Content-Type': 'application/json'};
    if (withAuth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return await http.put(url, headers: headers, body: body);
  }

  static Future<http.Response> deleteRequest(String endpoint, {bool withAuth = true}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    Map<String, String> headers = {'Content-Type': 'application/json'};
    if (withAuth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return await http.delete(url, headers: headers);
  }
}
