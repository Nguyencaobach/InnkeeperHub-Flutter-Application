import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared_widgets/custom_text_field.dart';
import '../../../shared_widgets/custom_button.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthController _authController = AuthController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                    'TẠO TÀI KHOẢN MỚI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSubtitle,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- PHẦN 2: FORM NHẬP LIỆU ---
                  CustomTextField(
                    label: 'Họ và tên',
                    hintText: 'Nhập họ và tên của bạn',
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Tên đăng nhập',
                    hintText: 'Nhập username của bạn',
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Email',
                    hintText: 'Nhập email của bạn',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Số điện thoại',
                    hintText: 'Nhập số điện thoại (9–15 chữ số)',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone, // Hiển thị bàn phím số
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Chỉ cho nhập chữ số 0-9
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Mật khẩu',
                    hintText: 'Nhập mật khẩu (tối thiểu 6 ký tự)',
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Xác nhận mật khẩu',
                    hintText: 'Nhập lại mật khẩu',
                    isPassword: true,
                    controller: _confirmPasswordController,
                  ),

                  const SizedBox(height: 32),

                  // --- PHẦN 3: NÚT ĐĂNG KÝ ---
                  AnimatedBuilder(
                    animation: _authController,
                    builder: (context, _) {
                      return CustomButton(
                        text: 'Đăng ký',
                        isLoading: _authController.isLoading,
                        onPressed: _authController.isLoading
                            ? null
                            : () {
                                _authController.register(
                                  context: context,
                                  fullName: _fullNameController.text,
                                  username: _usernameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  confirmPassword: _confirmPasswordController.text,
                                  phoneNumber: _phoneController.text,
                                );
                              },
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // --- PHẦN 4: ĐÃ CÓ TÀI KHOẢN? ĐĂNG NHẬP ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Đã có tài khoản? ',
                        style: TextStyle(
                          color: AppColors.textSubtitle,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Quay lại màn hình đăng nhập
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Đăng nhập ngay',
                          style: TextStyle(
                            color: AppColors.logoLightBlue,
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
