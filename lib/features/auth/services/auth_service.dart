// lib/features/auth/services/auth_service.dart
import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../models/auth_response_model.dart'; // Gọi cái khuôn Hộp bưu phẩm vào

class AuthService {
  // ─── ĐĂNG KÝ ────────────────────────────────────────────────────────────────
  // Đăng ký chỉ cần biết thành công hay thất bại, không cần trả về dữ liệu nên dùng Future<void>
  static Future<void> register({
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
      requireAuth: false, 
    );

    // Nếu KHÔNG thành công (khác 200 và 201), ném lỗi ngay lập tức
    if (response.statusCode != 200 && response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Đăng ký thất bại');
    }
  }

  // ─── ĐĂNG NHẬP ──────────────────────────────────────────────────────────────
  // Đăng nhập thành công BẮT BUỘC trả về cái AuthResponseModel (Chìa khóa + Thẻ căn cước)
  static Future<AuthResponseModel> login({
    required String username,
    required String password,
  }) async {
    final response = await ApiClient.post(
      Uri.parse(ApiEndpoints.login),
      body: {
        'username': username,
        'password': password,
      },
      requireAuth: false,
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Ép kiểu JSON thẳng vào khuôn AuthResponseModel và gửi về cho Controller
      return AuthResponseModel.fromJson(body['data']);
    } else {
      // Nếu sai pass hoặc user không tồn tại -> Ném lỗi
      throw Exception(body['message'] ?? 'Đăng nhập thất bại');
    }
  }

  // ─── QUÊN MẬT KHẨU ──────────────────────────────────────────────────────────
  static Future<void> forgotPassword({
    required String email,
  }) async {
    final response = await ApiClient.post(
      Uri.parse(ApiEndpoints.forgotPassword),
      body: {'email': email},
      requireAuth: false,
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Lỗi quên mật khẩu');
    }
  }
}