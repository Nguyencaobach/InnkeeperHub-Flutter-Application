// lib/core/utils/token_storage.dart
import 'dart:convert'; // Thư viện dùng để chuyển đổi Map <-> Chuỗi JSON
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart'; // Gọi cái khuôn UserModel vào

class TokenStorage {
  // ─── CHỈ CÒN LẠI 2 CHÌA KHÓA CHÍNH (Thay vì 7 cái như cũ) ───────────────
  static const _keyAccessToken  = 'access_token'; // Ngăn cất chìa khóa
  static const _keyUserData     = 'user_data';    // Ngăn cất Thẻ căn cước (UserModel)

  // ─── LƯU PHIÊN LÀM VIỆC ─────────────────────────────────────────────────
  static Future<void> saveSession({
    required String accessToken,
    required UserModel user, // Nhận vào nguyên 1 cái khuôn UserModel
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Cất chìa khóa
    await prefs.setString(_keyAccessToken, accessToken);
    
    // 2. Cất Thẻ căn cước: 
    // Vì ổ cứng chỉ lưu được "Chữ" (String), nên ta dùng jsonEncode để biến cái UserModel thành 1 chuỗi chữ thô rồi cất đi.
    await prefs.setString(_keyUserData, jsonEncode(user.toJson()));
  }

  // ─── ĐỌC TOKEN ──────────────────────────────────────────────────────────
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  // ─── ĐỌC THÔNG TIN USER ─────────────────────────────────────────────────
  // Thay vì trả về Map, giờ ta trả về luôn đối tượng UserModel xịn sò
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_keyUserData); // Lấy chuỗi chữ thô ra
    
    if (userString != null && userString.isNotEmpty) {
      // Dịch ngược chuỗi chữ thô đó thành Map, rồi ép vào khuôn UserModel
      final userMap = jsonDecode(userString) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    }
    return null; // Nếu chưa đăng nhập thì trả về null
  }

  // ─── KIỂM TRA ĐĂNG NHẬP VÀ ĐĂNG XUẤT ────────────────────────────────────
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyUserData); // Chỉ cần xóa 2 ngăn là sạch bách!
  }
}