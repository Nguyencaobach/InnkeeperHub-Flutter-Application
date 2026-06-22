import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/user_state.dart';

// Màn hình chính sau khi đăng nhập thành công
// Hiện tại chưa có nội dung, sẽ được thiết kế sau

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Đọc UserState — lấy thông tin user đang đăng nhập
    // context.watch<UserState>() : lắng nghe thay đổi, rebuild khi có thay đổi
    // context.read<UserState>()  : chỉ đọc 1 lần, KHÔNG rebuild (dùng trong onPressed)
    final user = context.watch<UserState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Màn hình chính',
                style: TextStyle(
                  color: AppColors.textSubtitle,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Demo: hiển thị tên user từ global state
              Text(
                'Xin chào, ${user.fullName.isNotEmpty ? user.fullName : user.username}!',
                style: const TextStyle(
                  color: AppColors.logoLightBlue,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: const TextStyle(
                  color: AppColors.textSubtitle,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '(Đang phát triển...)',
                style: TextStyle(
                  color: AppColors.textSubtitle,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
