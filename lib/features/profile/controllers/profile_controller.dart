import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/profile_service.dart';
import '../../../state/user_state.dart';
import '../../../core/utils/token_storage.dart';

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

      _showSnackBar(context, 'Cập nhật ảnh đại diện thành công!');
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      if (context.mounted) _showSnackBar(context, errorMsg, isError: true);
    } finally {
      _isUploadingAvatar = false;
      notifyListeners(); // Tắt vòng xoay
    }
  }

<<<<<<< HEAD
  // Hàm xử lý cập nhật thông tin cá nhân
  Future<void> updateProfile(
    BuildContext context, {
    required String fullName,
    required int age,
    required String phoneNumber,
  }) async {
    try {
      final profileService = ProfileService();
      final success = await profileService.apiUpdateProfile(
        fullName: fullName,
        age: age,
        phoneNumber: phoneNumber,
      );

      if (success && context.mounted) {
        // TODO: Nếu `UserState` có hàm hỗ trợ update tên/số điện thoại, bạn có thể gọi ở đây để cập nhật UI ngay lập tức
        
        Navigator.pop(context); // Đóng Bottom Sheet sau khi thành công
        _showSnackBar(context, 'Cập nhật thông tin thành công!');
      }
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      if (context.mounted) _showSnackBar(context, errorMsg, isError: true);
    }
  }

  // Hàm xử lý đổi mật khẩu
  Future<void> changePassword(
    BuildContext context, {
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final profileService = ProfileService();
      final success = await profileService.apiChangePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      if (success && context.mounted) {
        Navigator.pop(context); // Đóng Bottom Sheet sau khi thành công
        _showSnackBar(context, 'Thay đổi mật khẩu thành công!');
      }
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      if (context.mounted) _showSnackBar(context, errorMsg, isError: true);
    }
  }

=======
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
