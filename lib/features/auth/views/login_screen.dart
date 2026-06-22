import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared_widgets/custom_text_field.dart';
import '../../../shared_widgets/custom_button.dart';
import '../controllers/auth_controller.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

// Trong giao diện ta dùng các SizedBox để tạo khoảng trống cách nhau

class LoginScreen extends StatefulWidget { // Widget lưu lại trạng thái người dùng nhập
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController(); // Ghi lại dữ liệu nhập vào
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController(); // Controller xử lý logic

  @override
  void dispose() {
    _usernameController.dispose(); // Tắt ghi dữ liệu khi chuyển sang màn hình khác
    _passwordController.dispose();
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold là nền chính của app nơi chứa tất cả mọi thứ
      backgroundColor: AppColors.background,
      body: SafeArea( // SafeArea - Bảo vệ giao diện khỏi các đặc thù che khất mà hình của thiết bị như tai thỏ
        child: Center( // Center và SingleChildScrollView dùng để cho màn hình vẫn lướt lên xuống được khi hiển thị bàn phím ảo
          child: SingleChildScrollView( // Thuộc tính child là để lồng widget này trong widget khác
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0), // Đẩy toàn bộ nội dung của Form đăng nhập vào trái phải cách 24px và cách mép trên và dưới 40px
            child: ConstrainedBox( // Tạo ra container bao bọc tất cả
              constraints: const BoxConstraints(maxWidth: 400), // Giới hạn chiều rộng của form trên các thiết bị khác
              child: Column( // Cho mọi thứ xếp theo dọc
                mainAxisAlignment: MainAxisAlignment.center, // Giúp căn chỉnh cho đối tượng nằm giữa theo trục dọc
                crossAxisAlignment: CrossAxisAlignment.stretch, // Giúp kéo dãn đối tượng ra hai lề màn hình
                children: [ // Dùng để gom nhiều thuộc tính hơn
                  // --- PHẦN 1: LOGO VÀ TIÊU ĐỀ ---
                  RichText( // Richtext cho phép tô nhiều màu chữ bên trong một dòng chữ
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
                  Align( // Dùng để căn lề
                    alignment: Alignment.centerRight, // Căn lề qua phải luôn
                    child: TextButton(
                      onPressed: () {
                        // Chuyển sang màn hình Quên mật khẩu
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
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
                  // AnimatedBuilder lắng nghe isLoading từ controller để cập nhật nút
                  AnimatedBuilder(
                    animation: _authController,
                    builder: (context, _) {
                      return CustomButton(
                        text: 'Đăng nhập',
                        isLoading: _authController.isLoading,
                        onPressed: _authController.isLoading
                            ? null
                            : () {
                                _authController.login(
                                  context: context,
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                );
                              },
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // --- PHẦN 5: CHƯA CÓ TÀI KHOẢN? ĐĂNG KÝ NGAY ---
                  Row( // Dùng để chứa nhiều thuộc tính có thể nằm ngang ví dụ cho dòng chữ CHƯA CÓ TÀI KHOẢN? ĐĂNG KÝ NGAY
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
                          // Chuyển sang màn hình Đăng ký
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
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