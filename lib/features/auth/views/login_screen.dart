import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared_widgets/custom_text_field.dart';
import '../../../shared_widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Giữ nền trắng sạch sẽ
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- PHẦN 1: LOGO VÀ TIÊU ĐỀ ---
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Arial',
                      ),
                      children: [
                        TextSpan(
                          text: 'innkeeper',
                          style: TextStyle(color: AppColors.logoDarkBlue),
                        ),
                        TextSpan(
                          text: 'Hub',
                          style: TextStyle(color: AppColors.logoLightBlue),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ĐĂNG NHẬP VÀO HỆ THỐNG',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSubtitle,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // --- PHẦN 2: FORM NHẬP LIỆU ---
                  CustomTextField(
                    label: 'Tên đăng nhập',
                    hintText: 'Nhập username của bạn',
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Mật khẩu',
                    hintText: 'Nhập mật khẩu',
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  
                  const SizedBox(height: 8), // Khoảng cách nhỏ giữa Mật khẩu và Quên mật khẩu

                  // --- PHẦN 3: QUÊN MẬT KHẨU (Nằm dưới mật khẩu, lệch phải) ---
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Chuyển trang Quên mật khẩu
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Xoá khoảng viền thừa của nút
                      ),
                      child: const Text(
                        'Quên mật khẩu?',
                        style: TextStyle(
                          color: AppColors.logoLightBlue, // Dùng màu xanh tím đồng bộ với nút đăng nhập
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32), 

                  // --- PHẦN 4: NÚT ĐĂNG NHẬP ---
                  CustomButton(
                    text: 'Đăng nhập',
                    onPressed: () {
                      print('User: ${_usernameController.text}');
                      print('Pass: ${_passwordController.text}');
                    },
                  ),
                  
                  const SizedBox(height: 24),

                  // --- PHẦN 5: CHƯA CÓ TÀI KHOẢN? ĐĂNG KÝ NGAY ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Chưa có tài khoản? ',
                        style: TextStyle(
                          color: AppColors.textSubtitle, // Màu xám nhạt
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Chuyển sang màn hình Đăng ký
                        },
                        child: const Text(
                          'Đăng ký ngay',
                          style: TextStyle(
                            color: AppColors.logoLightBlue, // Nổi bật phần Đăng ký ngay
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}