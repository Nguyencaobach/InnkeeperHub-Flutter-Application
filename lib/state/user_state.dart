import 'package:flutter/material.dart';
import '../core/utils/token_storage.dart';

/// Global state lưu thông tin user đang đăng nhập trong RAM.
/// Mọi màn hình đều có thể đọc/lắng nghe thay đổi thông qua Provider.
///
/// Sơ đồ luồng dữ liệu:
///   Backend JSON ──► AuthController.login()
///                        ├── TokenStorage.saveSession()  (lưu disk - dùng khi mở lại app)
///                        └── UserState.setUser()         (lưu RAM  - dùng trong phiên hiện tại)
class UserState extends ChangeNotifier {
  // ─── DỮ LIỆU USER ───────────────────────────────────────────────────────────
  String _accessToken = '';
  String _customerId  = '';
  String _username    = '';
  String _fullName    = '';
  String _email       = '';
  String _phoneNumber = '';
  String _avatarUrl   = '';

  // ─── GETTERS (các màn hình đọc qua đây) ─────────────────────────────────────
  String get accessToken => _accessToken;
  String get customerId  => _customerId;
  String get username    => _username;
  String get fullName    => _fullName;
  String get email       => _email;
  String get phoneNumber => _phoneNumber;
  String get avatarUrl   => _avatarUrl;

  /// Trả về true nếu user đang đăng nhập (có token trong RAM).
  bool get isLoggedIn => _accessToken.isNotEmpty;

  // ─── CẬP NHẬT SAU KHI ĐĂNG NHẬP ────────────────────────────────────────────
  /// Gọi bởi AuthController sau khi login thành công.
  void setUser({
    required String accessToken,
    required Map<String, dynamic> customer,
  }) {
    _accessToken = accessToken;
    _customerId  = customer['customer_id']  as String? ?? '';
    _username    = customer['username']     as String? ?? '';
    _fullName    = customer['full_name']    as String? ?? '';
    _email       = customer['email']        as String? ?? '';
    _phoneNumber = customer['phone_number'] as String? ?? '';
    _avatarUrl   = customer['avatar_url']   as String? ?? '';
    notifyListeners(); // Thông báo cho tất cả màn hình đang lắng nghe
  }

  // ─── KHÔI PHỤC KHI MỞ LẠI APP ──────────────────────────────────────────────
  /// Đọc lại từ TokenStorage (disk) khi app khởi động.
  /// Gọi trong SplashScreen hoặc main() để tự động đăng nhập lại.
  Future<void> loadFromStorage() async {
    final token    = await TokenStorage.getAccessToken();
    final userInfo = await TokenStorage.getUserInfo();
    if (token != null && token.isNotEmpty) {
      _accessToken = token;
      _customerId  = userInfo['customer_id']  ?? '';
      _username    = userInfo['username']     ?? '';
      _fullName    = userInfo['full_name']    ?? '';
      _email       = userInfo['email']        ?? '';
      _phoneNumber = userInfo['phone_number'] ?? '';
      _avatarUrl   = userInfo['avatar_url']   ?? '';
      notifyListeners();
    }
  }

  // ─── ĐĂNG XUẤT ──────────────────────────────────────────────────────────────
  /// Xóa dữ liệu khỏi RAM và disk. Gọi khi user bấm Đăng xuất.
  Future<void> logout() async {
    await TokenStorage.clearSession();
    _accessToken = '';
    _customerId  = '';
    _username    = '';
    _fullName    = '';
    _email       = '';
    _phoneNumber = '';
    _avatarUrl   = '';
    notifyListeners();
  }
}
