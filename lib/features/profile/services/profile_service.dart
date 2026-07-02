import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_endpoints.dart';
import '../../../core/utils/token_storage.dart';
import '../../../core/models/user_model.dart';

class ProfileService {
  // Hàm upload ảnh và nhận về thông tin User mới
  static Future<UserModel> uploadAvatar(String imagePath) async {
    final token = await TokenStorage.getAccessToken();
    
    // 1. Tạo request dạng Multipart (Dùng để gửi file)
    var request = http.MultipartRequest('POST', Uri.parse(ApiEndpoints.uploadAvatar));
    
    // 2. Gắn Token vào Header
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['ngrok-skip-browser-warning'] = 'true';
    
    // 3. Đính kèm file ảnh vào key 'avatar' (đúng với tên bên Multer Backend)
    request.files.add(await http.MultipartFile.fromPath('avatar', imagePath));
    
    // 4. Gửi đi và chờ phản hồi
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        // Ép kiểu dữ liệu mới trả về thành UserModel
        return UserModel.fromJson(body['data']);
      } else {
        throw Exception(body['message'] ?? 'Không thể tải ảnh lên');
      }
    } else {
      // Cố gắng decode JSON nếu có, nếu không thì báo lỗi chung chung (tránh lỗi <!DOCTYPE html>)
      try {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Lỗi máy chủ: ${response.statusCode}');
      } catch (e) {
        throw Exception('Lỗi API (${response.statusCode}): Không tìm thấy API (404) hoặc sai Method (POST/PUT/PATCH).');
      }
    }
  }
  // Hàm cập nhật thông tin cá nhân (và mật khẩu)
  static Future<UserModel> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    String? password,
  }) async {
    final token = await TokenStorage.getAccessToken();
    
    final Map<String, dynamic> body = {
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
    };
    
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    final response = await http.put(
      Uri.parse(ApiEndpoints.customerProfile),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonBody = jsonDecode(response.body);
      if (jsonBody['success'] == true) {
        return UserModel.fromJson(jsonBody['data']);
      } else {
        throw Exception(jsonBody['message'] ?? 'Không thể cập nhật thông tin');
      }
    } else {
      try {
        final jsonBody = jsonDecode(response.body);
        throw Exception(jsonBody['message'] ?? 'Lỗi máy chủ: ${response.statusCode}');
      } catch (e) {
        throw Exception('Lỗi API (${response.statusCode})');
      }
    }
  }
}
