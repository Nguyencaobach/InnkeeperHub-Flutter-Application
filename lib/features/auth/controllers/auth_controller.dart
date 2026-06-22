import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// Controller xử lý toàn bộ logic & state cho màn hình Auth.
/// Dùng ChangeNotifier để các màn hình có thể lắng nghe trạng thái isLoading.
class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ─── ĐĂNG NHẬP ──────────────────────────────────────────────────────────────
  Future<void> login({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    // --- Validate đầu vào ---
    if (username.trim().isEmpty || password.trim().isEmpty) {
      _showSnackBar(context, 'Vui lòng nhập đầy đủ thông tin.', isError: true);
      return;
    }

    _setLoading(true);
    late final Map<String, dynamic> result;
    try {
      result = await AuthService.login(
        username: username.trim(),
        password: password.trim(),
      );
    } catch (_) {
      _setLoading(false);
      if (context.mounted) {
        _showSnackBar(context, 'Không thể kết nối đến server. Kiểm tra lại kết nối mạng.', isError: true);
      }
      return;
    }
    _setLoading(false);

    if (!context.mounted) return;
    final statusCode = result['statusCode'] as int;
    final message = result['message']?.toString() ?? '';

    if (statusCode == 200) {
      // TODO: Lưu token nếu có: result['token'] hoặc result['access_token']
      _showSnackBar(context, 'Đăng nhập thành công! Chào mừng bạn trở lại.');
      // TODO: Điều hướng về màn hình chính
      // Navigator.pushReplacementNamed(context, '/home');
    } else {
      final errorMsg = message.isNotEmpty ? message : 'Đăng nhập thất bại ($statusCode).';
      _showSnackBar(context, errorMsg, isError: true);
    }
  }

  // ─── ĐĂNG KÝ ────────────────────────────────────────────────────────────────
  Future<void> register({
    required BuildContext context,
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
  }) async {
    // --- Validate đầu vào ---
    if (fullName.trim().isEmpty ||
        username.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty ||
        phoneNumber.trim().isEmpty) {
      _showSnackBar(context, 'Vui lòng nhập đầy đủ thông tin.', isError: true);
      return;
    }
    if (password != confirmPassword) {
      _showSnackBar(context, 'Mật khẩu xác nhận không khớp.', isError: true);
      return;
    }
    if (!email.contains('@')) {
      _showSnackBar(context, 'Email không hợp lệ.', isError: true);
      return;
    }
    // Validate số điện thoại: chỉ gồm 9-15 chữ số (khớp backend)
    final phoneRegex = RegExp(r'^[0-9]{9,15}$');
    if (!phoneRegex.hasMatch(phoneNumber.trim())) {
      _showSnackBar(context, 'Số điện thoại chỉ gồm 9–15 chữ số.', isError: true);
      return;
    }

    _setLoading(true);
    late final Map<String, dynamic> result;
    try {
      result = await AuthService.register(
        fullName: fullName.trim(),
        username: username.trim(),
        email: email.trim(),
        password: password.trim(),
        phoneNumber: phoneNumber.trim(),
      );
    } catch (_) {
      _setLoading(false);
      if (context.mounted) {
        _showSnackBar(context, 'Không thể kết nối đến server. Kiểm tra lại kết nối mạng.', isError: true);
      }
      return;
    }
    _setLoading(false);

    if (!context.mounted) return;
    final statusCode = result['statusCode'] as int;
    final message = result['message']?.toString() ?? '';

    if (statusCode == 200 || statusCode == 201) {
      _showSnackBar(context, 'Đăng ký thành công! Vui lòng đăng nhập.');
      Navigator.pop(context);
    } else {
      final errorMsg = message.isNotEmpty ? message : 'Đăng ký thất bại ($statusCode).';
      _showSnackBar(context, errorMsg, isError: true);
    }
  }

  // ─── QUÊN MẬT KHẨU ──────────────────────────────────────────────────────────
  Future<void> forgotPassword({
    required BuildContext context,
    required String email,
  }) async {
    if (email.trim().isEmpty || !email.contains('@')) {
      _showSnackBar(context, 'Vui lòng nhập email hợp lệ.', isError: true);
      return;
    }

    _setLoading(true);
    late final Map<String, dynamic> result;
    try {
      result = await AuthService.forgotPassword(email: email.trim());
    } catch (_) {
      _setLoading(false);
      if (context.mounted) {
        _showSnackBar(context, 'Không thể kết nối đến server. Kiểm tra lại kết nối mạng.', isError: true);
      }
      return;
    }
    _setLoading(false);

    if (!context.mounted) return;
    final statusCode = result['statusCode'] as int;
    final message = result['message']?.toString() ?? '';

    if (statusCode == 200) {
      // Hiển thị dialog thông báo thành công, bấm OK → quay về màn hình đăng nhập
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Kiểm tra email của bạn',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text(
            'Mật khẩu tạm thời đã được gửi.\nVui lòng đăng nhập lại.',
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.6, fontSize: 14),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            // Nút gradient giống CustomButton
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2DD4BF), Color(0xFF5A67D8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  if (context.mounted) Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Đăng nhập ngay',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      final errorMsg = message.isNotEmpty ? message : 'Yêu cầu thất bại ($statusCode).';
      _showSnackBar(context, errorMsg, isError: true);
    }
  }

  // ─── HELPER ─────────────────────────────────────────────────────────────────
  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
