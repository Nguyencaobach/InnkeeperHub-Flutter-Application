import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

// File này quy định thiết kế của các giao diện trong hệ thống

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Cấu hình màu nền và chữ dùng chung
      primaryColor: AppColors.buttonBlue, 
      scaffoldBackgroundColor: AppColors.background, // Đặt màu nền mặc định cho nền là trắng
      fontFamily: 'Roboto', 
      
      // Cấu hình Nút bấm
      elevatedButtonTheme: ElevatedButtonThemeData( // elevatedButtonTheme - Nút bấm nổi
        style: ElevatedButton.styleFrom( // Hàm styleFrom giúp viết như CSS
          backgroundColor: AppColors.buttonBlue, 
          foregroundColor: Colors.white, // Sử dụng cái này để định nghĩa luôn màu trắng mặc định, còn sài app_text khi cần sài form tùy chỉnh
          textStyle: AppTextStyles.buttonText, 
          minimumSize: const Size(double.infinity, 52), // double.infinity - Phình to hết cỡ theo chiều ngang
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0, // Độ nổi của nút 
        ),
      ),

      // Cấu hình Ô nhập liệu
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white, // Đổ màu nền cho ô nhập liệu
        hintStyle: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.normal), // Chữ mờ hiển thị gợi ý
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Cách chữ ngang dọc trong ô nhập ra 16px
        enabledBorder: OutlineInputBorder( // enabledBorder - Cấu hình đường viền của ô nhập lúc chưa thao tác
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder( // focusedBorder - Cấu hình đường viền lúc đang được chọn
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.buttonBlue, width: 2), 
        ),
      ),
    );
  }
}