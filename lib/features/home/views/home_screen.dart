// lib/features/home/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/user_state.dart';
import '../../discover/controllers/discover_controller.dart'; // Import để gọi hàm reload

import '../../activity/views/activity_screen.dart';
import '../../discover/views/discover_screen.dart';
import '../../chat/views/chat_screen.dart';
import '../../profile/views/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentIndex = 2; // Mặc định mở trang Home ở giữa

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // --- LOGIC XỬ LÝ NHẤN TAB ĐỂ RELOAD ---
  void _onTabTapped(int index) {
    if (_currentIndex == index) {
      // 1. TRƯỜNG HỢP NHẤN LẠI TAB ĐANG MỞ (Tự động Load lại dữ liệu)
      if (index == 1) { 
        // Index 1 là tab Khám phá -> Kêu Kho chung tải lại API
        context.read<DiscoverController>().fetchRoomTypes();
      }
      // Sau này làm tab Hoạt động (index 0) bạn cũng có thể thêm logic tương tự ở đây
    } else {
      // 2. TRƯỜNG HỢP CHUYỂN SANG TAB KHÁC
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: const [
          ActivityScreen(),
          DiscoverScreen(),
          _HomeTabContent(),
          ChatScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped, // Trỏ vào hàm đã xử lý logic ở trên
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.buttonBlue,
          unselectedItemColor: AppColors.textLight,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.local_activity_outlined), activeIcon: Icon(Icons.local_activity), label: 'Hoạt động'),
            BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Khám phá'),
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'About me'),
          ],
        ),
      ),
    );
  }
}

class _HomeTabContent extends StatelessWidget {
  const _HomeTabContent();
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserState>();
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Trang chủ', style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.waving_hand_rounded, size: 64, color: AppColors.buttonBlue.withOpacity(0.5)),
              const SizedBox(height: 24),
              const Text('Màn hình chính', style: TextStyle(color: AppColors.textMain, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Xin chào, ${user.fullName.isNotEmpty ? user.fullName : user.username}!', style: const TextStyle(color: AppColors.logoLightBlue, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(user.email.isNotEmpty ? user.email : '(Chưa cập nhật email)', style: const TextStyle(color: AppColors.textSubtitle, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}