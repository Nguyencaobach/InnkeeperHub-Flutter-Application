import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Label cho ô nhập liệu (Ví dụ: "Tên đăng nhập", "Mật khẩu")
  static const TextStyle inputLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700, // In đậm giống với ảnh thiết kế
    color: AppColors.textMain,
  );

  // Chữ bên trong nút bấm (để dự phòng nếu bạn cần gọi lẻ bên ngoài)
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Dòng chữ phụ nhỏ
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSubtitle, 
  );

  // Chữ gợi ý (hint) cho ô nhập liệu
  static const TextStyle hintText = TextStyle(
    fontSize: 14,
    color: AppColors.textLight,
  );

  // Tiêu đề lớn
  static const TextStyle titleLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    fontFamily: 'Arial',
    color: AppColors.textMain,
    letterSpacing: 0.5,
  );
}