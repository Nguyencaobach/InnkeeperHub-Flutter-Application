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

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
