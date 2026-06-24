// lib/features/auth/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../../home/views/home_screen.dart';
import '../../../core/utils/token_storage.dart';
import '../../../state/user_state.dart';

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
    if (username.trim().isEmpty || password.trim().isEmpty) {
      _showSnackBar(context, 'Vui lòng nhập đầy đủ thông tin.', isError: true);
      return;
    }

    _setLoading(true);
    try {
      // 1. Chỉ việc ngửa tay xin cái AuthResponseModel từ Service
      final authResponse = await AuthService.login(
        username: username.trim(),
        password: password.trim(),
      );

      // 2. Ném model cho Két sắt (Ổ cứng) cất
      await TokenStorage.saveSession(
        accessToken: authResponse.accessToken, 
        user: authResponse.user,
      );

      if (!context.mounted) return;
      
      // 3. Ném model cho UserState (RAM) đeo lên cổ
      context.read<UserState>().setUser(
        accessToken: authResponse.accessToken, 
        user: authResponse.user,
      );

      _showSnackBar(context, 'Đăng nhập thành công! Chào mừng bạn trở lại.');

      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      // Nếu Service ném lỗi (vd: Sai pass), nhảy ngay vào catch này để báo lỗi cho UI
      if (context.mounted) {
        // e.toString() thường có chữ "Exception: " ở đầu, ta cắt bỏ nó đi cho đẹp
        final errorMsg = e.toString().replaceAll('Exception: ', '');
        _showSnackBar(context, errorMsg, isError: true);
      }
    } finally {
      _setLoading(false); // Dù thành công hay lỗi thì cũng phải tắt vòng xoay
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
    if (fullName.trim().isEmpty || username.trim().isEmpty || email.trim().isEmpty ||
        password.trim().isEmpty || phoneNumber.trim().isEmpty) {
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
    final phoneRegex = RegExp(r'^[0-9]{9,15}$');
    if (!phoneRegex.hasMatch(phoneNumber.trim())) {
      _showSnackBar(context, 'Số điện thoại chỉ gồm 9–15 chữ số.', isError: true);
      return;
    }

    _setLoading(true);
    try {
      await AuthService.register(
        fullName: fullName.trim(),
        username: username.trim(),
        email: email.trim(),
        password: password.trim(),
        phoneNumber: phoneNumber.trim(),
      );
      
      if (!context.mounted) return;
      _showSnackBar(context, 'Đăng ký thành công! Vui lòng đăng nhập.');
      Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        final errorMsg = e.toString().replaceAll('Exception: ', '');
        _showSnackBar(context, errorMsg, isError: true);
      }
    } finally {
      _setLoading(false);
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
    try {
      await AuthService.forgotPassword(email: email.trim());
      
      if (!context.mounted) return;
      // Khúc này mình giữ nguyên thiết kế Dialog tuyệt đẹp của bạn nhé
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
                child: const Text('Đăng nhập ngay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (context.mounted) {
        final errorMsg = e.toString().replaceAll('Exception: ', '');
        _showSnackBar(context, errorMsg, isError: true);
      }
    } finally {
      _setLoading(false);
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