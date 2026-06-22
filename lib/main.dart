import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/network/api_client.dart';
import 'features/auth/views/splash_screen.dart';
import 'features/auth/views/login_screen.dart';
import 'state/user_state.dart';

void main() {
  // Điểm khởi chạy của toàn bộ ứng dụng
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Tạo một UserState duy nhất cho toàn bộ app.
      // Mọi màn hình con đều có thể đọc dữ liệu user từ đây.
      create: (_) => UserState(),
      child: MaterialApp(
        title: 'innkeeperHub',
        // Tắt cái chữ "DEBUG" màu đỏ ở góc phải màn hình cho đẹp
        debugShowCheckedModeBanner: false,

        // Key toàn cục để ApiClient điều hướng khi token hết hạn (401)
        navigatorKey: ApiClient.navigatorKey,

        // Áp dụng bộ Theme tổng mà chúng ta đã làm ở Bước 1
        theme: AppTheme.lightTheme,

        // Splash Screen là màn hình đầu tiên khi mở app
        home: const SplashScreen(),

        // Named routes — dùng cho ApiClient điều hướng khi 401
        routes: {
          '/login': (_) => const LoginScreen(),
        },
      ),
    );
  }
}