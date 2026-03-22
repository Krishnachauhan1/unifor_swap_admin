import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'apis.dart';

class ApiService {
  static const String _tokenKey = "token";
  static const String _userIdKey = "user_id";

  // Save token and userId after login
  static Future<void> saveAuthData(
      {required String token, required String userId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, userId);
  }

  // Get saved token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get saved userId
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Clear auth data (logout)
  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }

  // Build headers with token
  static Future<Map<String, String>> _headers() async {
    final token = await getToken();
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": 'Bearer $token',
    };
  }

  // GET request
  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
    );
    return _handleResponse(response);
  }

  // POST request
  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }
  static Future<dynamic> patch(String url, Map<String, dynamic> body) async {
    final response = await http.patch(
      Uri.parse(baseUrl+url),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "API Error ${response.statusCode}: ${response.body}");
    }
  }
  // PUT request
  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // DELETE request
  static Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
    );
    return _handleResponse(response);
  }

  // Multipart POST for image upload
  static Future<dynamic> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
  }) async {
    final uri = Uri.parse("$baseUrl$endpoint");
    final request = http.MultipartRequest("POST", uri);
    request.fields.addAll(fields);
    request.files.addAll(files);

    final token = await getToken();
    request.headers.addAll({
      "Accept": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": 'Bearer $token',
    });

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode >= 200 &&
        streamedResponse.statusCode < 300) {
      return jsonDecode(responseBody);
    } else {
      throw Exception(
          "API Error ${streamedResponse.statusCode}: $responseBody");
    }
  }

  // Helper to create image multipart file
  static Future<http.MultipartFile> imageFile(String field, String path) async {
    final mimeType = lookupMimeType(path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      throw Exception("Invalid image file: $path");
    }
    return http.MultipartFile.fromPath(
      field,
      path,
      contentType: MediaType.parse(mimeType),
    );
  }

  // Handle API response
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 401) {
      clearAuth();
      throw Exception("Unauthorized / Session expired");
    }
    throw Exception("API Error ${response.statusCode}: ${response.body}");
  }
}
