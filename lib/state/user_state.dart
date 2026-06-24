// lib/state/user_state.dart
import 'package:flutter/material.dart';
import '../core/utils/token_storage.dart';
import '../core/models/user_model.dart'; // Gọi cái khuôn vào

class UserState extends ChangeNotifier {
  // ─── DỮ LIỆU USER (Siêu Gọn Nhẹ) ────────────────────────────────────────
  String _accessToken = '';
  UserModel? _currentUser; // Thay vì 7 biến, ta chỉ cần 1 biến chứa Thẻ căn cước!

  // ─── GETTERS (Bí quyết giữ nguyên file View) ────────────────────────────
  // File HomeScreen đang gọi: user.fullName, user.email...
  // Nên ta làm các hàm get "trung gian", tự động chui vào _currentUser lấy ra cho nó.
  // Dấu '?.' và '??' nghĩa là: Nếu chưa có thẻ thì trả về chuỗi rỗng để app không bị sập.
  
  String get accessToken => _accessToken;
  String get customerId  => _currentUser?.customerId ?? '';
  String get username    => _currentUser?.username ?? '';
  String get fullName    => _currentUser?.fullName ?? '';
  String get email       => _currentUser?.email ?? '';
  String get phoneNumber => _currentUser?.phoneNumber ?? '';
  String get avatarUrl   => _currentUser?.avatarUrl ?? '';

  bool get isLoggedIn => _accessToken.isNotEmpty && _currentUser != null;

  // ─── CẬP NHẬT SAU KHI ĐĂNG NHẬP ─────────────────────────────────────────
  // Giờ hàm này chỉ cần nhận đúng 2 món đồ
  void setUser({
    required String accessToken,
    required UserModel user,
  }) {
    _accessToken = accessToken;
    _currentUser = user; // Đeo thẻ căn cước lên cổ
    notifyListeners(); // Hét lên cho các màn hình vẽ lại
  }

  // ─── KHÔI PHỤC KHI MỞ LẠI APP ───────────────────────────────────────────
  Future<void> loadFromStorage() async {
    final token = await TokenStorage.getAccessToken();
    final user  = await TokenStorage.getUser(); // Gọi hàm getUser mới
    
    if (token != null && user != null) {
      _accessToken = token;
      _currentUser = user;
      notifyListeners();
    }
  }

  // ─── ĐĂNG XUẤT ──────────────────────────────────────────────────────────
  Future<void> logout() async {
    await TokenStorage.clearSession();
    _accessToken = '';
    _currentUser = null; // Lột thẻ căn cước vứt đi
    notifyListeners();
  }
}