import 'package:flutter/material.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_colors.dart';

class CustomTextField extends StatefulWidget { // StatefulWidget là Widget có thể thay đổi trạng thái, sử dụng cho con mắt ẩn hiển
  final String label;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label, // Chữ in đậm hiển thị trên ô nhập
    required this.hintText, // Chữ mờ trong ô nhập
    this.isPassword = false, // Mặc định là false (không phải mật khẩu)
    this.controller, // Ghi lại giá trị được nhập vào
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // Biến quản lý trạng thái ẩn/hiện chữ
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // Ban đầu, nếu là password thì sẽ ẩn chữ (true)
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column( // Sử dụng Column để xếp dọc các đối tượng từ trên xuống
      crossAxisAlignment: CrossAxisAlignment.start, // Căn trái
      children: [
        // 1. Nhãn (Label) nằm trên
        Text(
          widget.label,
          style: AppTextStyles.inputLabel, // Gọi inputLabel từ app_text sang
        ),
        const SizedBox(height: 8), // Khoảng cách giữa Label và Ô nhập
        
        // 2. Ô nhập liệu (TextField)
        TextField(
          controller: widget.controller,
          obscureText: _obscureText, // Thuộc tính ẩn chữ của Flutter
          decoration: InputDecoration(
            hintText: widget.hintText,
            // Nếu là mật khẩu thì hiển thị icon con mắt (suffixIcon)
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textLight,
                    ),
                    onPressed: () {
                      // Đổi trạng thái khi bấm vào con mắt
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}