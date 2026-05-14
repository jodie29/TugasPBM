import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'https://task.itprojects.web.id/api';
  final _storage = const FlutterSecureStorage();

  // Helper method to get the stored token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // 1. Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        String token = data['data']['token'];
        await _storage.write(key: 'auth_token', value: token);
        return {'success': true, 'message': data['message'] ?? 'Login successful'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  // Logout
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  // 2. Get Products
  Future<List<Product>> getProducts() async {
    final url = Uri.parse('$baseUrl/products');
    final token = await getToken();

    if (token == null) throw Exception('No token found');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data']['products'] != null) {
        List<dynamic> productsJson = data['data']['products'];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      }
    }
    throw Exception('Failed to load products');
  }

  // 3. Save Product (Draft)
  Future<Map<String, dynamic>> saveProduct(Product product) async {
    final url = Uri.parse('$baseUrl/products');
    final token = await getToken();

    if (token == null) throw Exception('No token found');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': product.name,
        'price': product.price.toInt(),
        'description': product.description,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'message': data['message'] ?? 'Product saved successfully'};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Failed to save product'};
    }
  }

  // 4. Submit Task
  Future<Map<String, dynamic>> submitTask(String name, int price, String description, String githubUrl) async {
    final url = Uri.parse('$baseUrl/products/submit');
    final token = await getToken();

    if (token == null) throw Exception('No token found');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
        'github_url': githubUrl,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'message': data['message'] ?? 'Task submitted successfully'};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Failed to submit task'};
    }
  }

  // 5. Delete Product (Soft Delete)
  Future<Map<String, dynamic>> deleteProduct(int id) async {
    final url = Uri.parse('$baseUrl/products/$id');
    final token = await getToken();

    if (token == null) throw Exception('No token found');

    final response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return {'success': true, 'message': data['message'] ?? 'Product deleted'};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Failed to delete product'};
    }
  }
}
