import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/profile_service.dart';
import '../../../state/user_state.dart';
import '../../../core/utils/token_storage.dart';
import '../../../core/theme/app_colors.dart';

class ProfileController extends ChangeNotifier {
  bool _isUploadingAvatar = false;
  bool get isUploadingAvatar => _isUploadingAvatar;

  Future<void> uploadAvatar(BuildContext context, String imagePath) async {
    _isUploadingAvatar = true;
    notifyListeners(); // Báo cho UI hiện vòng xoay ở chỗ Avatar

    try {
      // 1. Gọi Service đẩy ảnh lên Server
      final updatedUser = await ProfileService.uploadAvatar(imagePath);

      if (!context.mounted) return;

      // 2. Cập nhật vào RAM (UserState) để giao diện đổi ảnh ngay
      context.read<UserState>().updateUser(updatedUser);

      // 3. Cập nhật vào Ổ cứng (TokenStorage) để lần sau mở app vẫn giữ ảnh mới
      final token = await TokenStorage.getAccessToken() ?? '';
      await TokenStorage.saveSession(accessToken: token, user: updatedUser);

      _showNotificationDialog(context, 'Cập nhật ảnh đại diện thành công!');
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      if (context.mounted) _showNotificationDialog(context, errorMsg, isError: true);
    } finally {
      _isUploadingAvatar = false;
      notifyListeners(); // Tắt vòng xoay
    }
  }

  Future<void> updateProfile(
    BuildContext context, {
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final updatedUser = await ProfileService.updateProfile(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
      );

      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // Đóng loading

      context.read<UserState>().updateUser(updatedUser);
      final token = await TokenStorage.getAccessToken() ?? '';
      await TokenStorage.saveSession(accessToken: token, user: updatedUser);

      _showNotificationDialog(context, 'Cập nhật thông tin thành công!');
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Đóng loading
        _showNotificationDialog(context, e.toString().replaceAll('Exception: ', ''), isError: true);
      }
    }
  }

  Future<void> changePassword(
    BuildContext context, {
    required String fullName,
    required String email,
    required String phoneNumber,
    required String newPassword,
  }) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final updatedUser = await ProfileService.updateProfile(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: newPassword,
      );

      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // Đóng loading

      context.read<UserState>().updateUser(updatedUser);
      final token = await TokenStorage.getAccessToken() ?? '';
      await TokenStorage.saveSession(accessToken: token, user: updatedUser);

      _showNotificationDialog(context, 'Đổi mật khẩu thành công!');
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Đóng loading
        _showNotificationDialog(context, e.toString().replaceAll('Exception: ', ''), isError: true);
      }
    }
  }

  void _showNotificationDialog(BuildContext context, String message, {bool isError = false}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isError ? Icons.error_outline_rounded : Icons.check_circle_rounded,
                color: isError ? Colors.redAccent : Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                isError ? 'Thất bại' : 'Thành công!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isError ? Colors.redAccent : AppColors.buttonBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Đóng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
