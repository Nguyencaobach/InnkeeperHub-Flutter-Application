import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

/// Lớp chịu trách nhiệm giao tiếp với backend API cho phần auth khách hàng.
class AuthService {
  // ─── ĐĂNG KÝ ────────────────────────────────────────────────────────────────
  /// Gọi POST /api/customer-auth/register
  /// Body gửi lên: { full_name, username, email, password }
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    final response = await ApiClient.post(
      Uri.parse(ApiEndpoints.register),
      body: {
        'full_name': fullName,
        'username': username,
        'email': email,
        'password': password,
        'phone_number': phoneNumber,
      },
      requireAuth: false, // Endpoint công khai, không cần token
    );
    return _parseResponse(response.statusCode, response.body);
  }

  // ─── ĐĂNG NHẬP ──────────────────────────────────────────────────────────────
  /// Gọi POST /api/customer-auth/login
  /// Body gửi lên: { username, password }
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await ApiClient.post(
      Uri.parse(ApiEndpoints.login),
      body: {
        'username': username,
        'password': password,
      },
      requireAuth: false, // Endpoint công khai, không cần token
    );
    return _parseResponse(response.statusCode, response.body);
  }

  // ─── QUÊN MẬT KHẨU ──────────────────────────────────────────────────────────
  /// Gọi POST /api/customer-auth/forgot-password
  /// Body gửi lên: { email }
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final response = await ApiClient.post(
      Uri.parse(ApiEndpoints.forgotPassword),
      body: {'email': email},
      requireAuth: false, // Endpoint công khai, không cần token
    );
    return _parseResponse(response.statusCode, response.body);
  }

  // ─── HELPER ─────────────────────────────────────────────────────────────────
  /// Parse response body về Map, kèm statusCode để controller xử lý
  static Map<String, dynamic> _parseResponse(int statusCode, String body) {
    try {
      final data = jsonDecode(body) as Map<String, dynamic>;
      return {'statusCode': statusCode, ...data};
    } catch (_) {
      return {
        'statusCode': statusCode,
        'message': body.isNotEmpty ? body : 'Lỗi không xác định từ server',
      };
    }
  }
}
