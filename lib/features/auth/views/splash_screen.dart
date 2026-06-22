import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // AnimationController để điều khiển hiệu ứng fade-in
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Cài đặt hiệu ứng fade-in cho logo (xuất hiện dần trong 1 giây)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Bắt đầu hiệu ứng ngay khi màn hình được tạo
    _animationController.forward();

    // Sau 2.5 giây thì tự chuyển sang màn hình Đăng nhập
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pushReplacement( // pushReplacement để không thể bấm back về Splash
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Nền trắng
      body: Center(
        child: FadeTransition( // Bọc logo trong hiệu ứng fade-in
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- LOGO CHÍNH ---
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 42,
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
              // --- TAGLINE ---
              const Text(
                'Nâng tầm trải nghiệm',
                style: TextStyle(
                  color: AppColors.textSubtitle,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
