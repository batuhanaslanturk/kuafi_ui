import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class CustomerService {
  static Future<http.Response> registerCustomer({
    required String fullName,
    required String phoneNumber,
    required String password,
  }) async {
    final body = jsonEncode({
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'password': password,
    });
    return await http.post(
      Uri.parse('${ApiService.baseUrl}/Customer/register'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  static Future<http.Response> loginCustomer({
    required String phoneNumber,
    required String password,
  }) async {
    final body = jsonEncode({
      'phoneNumber': phoneNumber,
      'password': password,
    });
    return await http.post(
      Uri.parse('${ApiService.baseUrl}/Customer/Login'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  static Future<http.Response> sendCode() async {
    return await ApiService.postRequest('Customer/send-code');
  }

  static Future<http.Response> verifyCode(String code) async {
    return await ApiService.postRequest('Customer/verify/$code');
  }
}
