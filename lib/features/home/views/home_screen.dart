// lib/features/home/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/user_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lắng nghe thông tin user để hiển thị lên màn hình
    final user = context.watch<UserState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      
      // THÊM THANH TIÊU ĐỀ (APPBAR) VÀ NÚT ĐĂNG XUẤT Ở GÓC PHẢI
      appBar: AppBar(
        title: const Text(
          'Trang chủ',
          style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5, // Tạo một chút bóng mờ đổ xuống cho đẹp
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Đăng xuất',
            onPressed: () async {
              // 1. Gọi hàm logout() trong UserState để đập vỡ Két sắt và xóa RAM
              await context.read<UserState>().logout();
              
              if (!context.mounted) return;
              
              // 2. Đẩy về màn hình Login và xóa sạch lịch sử màn hình cũ
              Navigator.pushNamedAndRemoveUntil(
                context, 
                '/login', // Đường dẫn này ta đã cấu hình sẵn bên file main.dart
                (route) => false,
              );
            },
          ),
        ],
      ),

      // PHẦN THÂN MÀN HÌNH (Hiển thị lời chào)
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ảnh minh họa chào mừng (tùy chọn cho sinh động)
              Icon(Icons.waving_hand_rounded, size: 64, color: AppColors.buttonBlue.withOpacity(0.5)),
              const SizedBox(height: 24),
              
              const Text(
                'Màn hình chính',
                style: TextStyle(
                  color: AppColors.textMain,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Hiển thị tên user từ Két sắt RAM
              Text(
                'Xin chào, ${user.fullName.isNotEmpty ? user.fullName : user.username}!',
                style: const TextStyle(
                  color: AppColors.logoLightBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              
              // Hiển thị Email
              Text(
                user.email.isNotEmpty ? user.email : '(Chưa cập nhật email)',
                style: const TextStyle(
                  color: AppColors.textSubtitle,
                  fontSize: 14,
                ),
              ),
              
              const SizedBox(height: 40),
              const Text(
                '(Các tính năng đang được phát triển...)',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}