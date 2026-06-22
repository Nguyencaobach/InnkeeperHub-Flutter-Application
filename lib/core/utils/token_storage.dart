import 'package:shared_preferences/shared_preferences.dart';

/// Tiện ích lưu trữ token JWT và thông tin user vào bộ nhớ cục bộ của thiết bị.
/// Sử dụng SharedPreferences — hoạt động tốt trên cả thiết bị thật lẫn máy ảo.
class TokenStorage {
  // ─── KEYS ───────────────────────────────────────────────────────────────────
  static const _keyAccessToken  = 'access_token';
  static const _keyCustomerId   = 'customer_id';
  static const _keyUsername     = 'username';
  static const _keyFullName     = 'full_name';
  static const _keyEmail        = 'email';
  static const _keyPhoneNumber  = 'phone_number';
  static const _keyAvatarUrl    = 'avatar_url';

  // ─── LƯU TOKEN + THÔNG TIN USER ─────────────────────────────────────────────
  /// Gọi sau khi đăng nhập thành công để lưu toàn bộ thông tin phiên làm việc.
  static Future<void> saveSession({
    required String accessToken,
    required Map<String, dynamic> customer,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyCustomerId,  customer['customer_id']  ?? '');
    await prefs.setString(_keyUsername,    customer['username']      ?? '');
    await prefs.setString(_keyFullName,    customer['full_name']     ?? '');
    await prefs.setString(_keyEmail,       customer['email']         ?? '');
    await prefs.setString(_keyPhoneNumber, customer['phone_number']  ?? '');
    await prefs.setString(_keyAvatarUrl,   customer['avatar_url']    ?? '');
  }

  // ─── ĐỌC TOKEN ──────────────────────────────────────────────────────────────
  /// Lấy access token đang lưu (null nếu chưa đăng nhập).
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  // ─── ĐỌC THÔNG TIN USER ─────────────────────────────────────────────────────
  /// Lấy toàn bộ thông tin user đang lưu dưới dạng Map.
  static Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'customer_id':   prefs.getString(_keyCustomerId),
      'username':      prefs.getString(_keyUsername),
      'full_name':     prefs.getString(_keyFullName),
      'email':         prefs.getString(_keyEmail),
      'phone_number':  prefs.getString(_keyPhoneNumber),
      'avatar_url':    prefs.getString(_keyAvatarUrl),
    };
  }

  // ─── KIỂM TRA ĐÃ ĐĂNG NHẬP CHƯA ────────────────────────────────────────────
  /// Trả về true nếu có token hợp lệ đang được lưu.
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ─── XÓA TOKEN (ĐĂNG XUẤT) ──────────────────────────────────────────────────
  /// Xóa toàn bộ dữ liệu phiên làm việc. Gọi khi user đăng xuất.
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyCustomerId);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyFullName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPhoneNumber);
    await prefs.remove(_keyAvatarUrl);
  }
}
