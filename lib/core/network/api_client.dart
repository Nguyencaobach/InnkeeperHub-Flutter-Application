import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  // Cấu hình header mặc định cho toàn bộ ứng dụng
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
    'ngrok-skip-browser-warning': 'true', // Bypass ngrok warning ở đây
  };

  // Hàm GET dùng chung
  static Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final mergedHeaders = {..._defaultHeaders, ...?headers};
    return await http.get(url, headers: mergedHeaders);
  }

  // Hàm POST dùng chung
  static Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body}) async {
    final mergedHeaders = {..._defaultHeaders, ...?headers};
    return await http.post(
      url,
      headers: mergedHeaders,
      body: body != null ? jsonEncode(body) : null,
    );
  }
}