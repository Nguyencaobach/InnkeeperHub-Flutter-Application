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
}