import 'package:flutter/material.dart';
// Thay đổi đường dẫn import này sao cho khớp với tên project của bạn nếu cần
import 'core/theme/app_theme.dart';
import 'features/auth/views/login_screen.dart';

void main() {
  // Điểm khởi chạy của toàn bộ ứng dụng
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'innkeeperHub',
      // Tắt cái chữ "DEBUG" màu đỏ ở góc phải màn hình cho đẹp
      debugShowCheckedModeBanner: false, 
      
      // Áp dụng bộ Theme tổng mà chúng ta đã làm ở Bước 1
      theme: AppTheme.lightTheme,
      
      // Đặt màn hình Đăng nhập làm màn hình chính (home)
      home: const LoginScreen(), 
    );
  }
}