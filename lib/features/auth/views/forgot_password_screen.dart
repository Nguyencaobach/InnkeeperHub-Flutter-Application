import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared_widgets/custom_text_field.dart';
import '../../../shared_widgets/custom_button.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthController _authController = AuthController();

  @override
  void dispose() {
    _emailController.dispose(); // Tắt ghi dữ liệu khi rời màn hình
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
                    'KHÔI PHỤC MẬT KHẨU',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSubtitle,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- PHẦN 2: MÔ TẢ HƯỚNG DẪN ---
                  const Text(
                    'Nhập địa chỉ email đã đăng ký. Chúng tôi sẽ gửi hướng dẫn đặt lại mật khẩu vào email của bạn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSubtitle,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- PHẦN 3: FORM NHẬP LIỆU ---
                  CustomTextField(
                    label: 'Email',
                    hintText: 'Nhập email đã đăng ký',
                    controller: _emailController,
                  ),

                  const SizedBox(height: 32),

                  // --- PHẦN 4: NÚT GỬI YÊU CẦU ---
                  AnimatedBuilder(
                    animation: _authController,
                    builder: (context, _) {
                      return CustomButton(
                        text: 'Gửi yêu cầu',
                        isLoading: _authController.isLoading,
                        onPressed: _authController.isLoading
                            ? null
                            : () {
                                _authController.forgotPassword(
                                  context: context,
                                  email: _emailController.text,
                                );
                              },
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // --- PHẦN 5: QUAY LẠI ĐĂNG NHẬP ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Đã nhớ mật khẩu? ',
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
