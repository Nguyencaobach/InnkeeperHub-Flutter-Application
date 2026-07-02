import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_endpoints.dart';
import '../../../core/utils/token_storage.dart';
import '../../../core/models/user_model.dart';

class ProfileService {
<<<<<<< HEAD
  // Hàm gọi API cập nhật thông tin cá nhân
  Future<bool> apiUpdateProfile({required String fullName, required int age, required String phoneNumber}) async {
    // TODO: Thêm logic kết nối HTTP (Dio hoặc Http) thực tế của bạn tại đây
    // Ví dụ: final response = await _dio.put('/api/profile', data: {...});
    
    await Future.delayed(const Duration(seconds: 1)); // Giả lập thời gian chờ API
    return true; // Trả về true nếu thành công
  }

  // Hàm gọi API thay đổi mật khẩu
  Future<bool> apiChangePassword({required String oldPassword, required String newPassword}) async {
    // TODO: Thêm logic kết nối HTTP (Dio hoặc Http) thực tế của bạn tại đây
    await Future.delayed(const Duration(seconds: 1)); // Giả lập thời gian chờ API
    return true; // Trả về true nếu thành công
  }

=======
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
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
<<<<<<< HEAD
      
    }
  }
}
=======
    }
  }
}
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
