// lib/features/home/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/user_state.dart';

// Import 4 màn hình vừa tạo
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
  // Bộ điều khiển PageView, đặt initialPage = 2 (tức là trang Home ở giữa)
  late PageController _pageController;
  int _currentIndex = 2;

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

  // Hàm chuyển trang khi bấm vào nút dưới thanh điều hướng
  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Hàm cập nhật icon khi người dùng vuốt màn hình
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gán màu nền F8F9FA cho toàn bộ khung bên ngoài
      backgroundColor: AppColors.mainBackground, 
      
      // BODY LÀ PAGEVIEW
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged, // Lắng nghe sự kiện vuốt
        physics: const BouncingScrollPhysics(), // Hiệu ứng nảy nhẹ khi lướt
        children: const [
          ActivityScreen(), // Index 0
          DiscoverScreen(), // Index 1
          _HomeTabContent(),// Index 2 (Trang Home hiện tại của bạn, mình tách thành Widget bên dưới)
          ChatScreen(),     // Index 3
          ProfileScreen(),  // Index 4
        ],
      ),

      // THANH ĐIỀU HƯỚNG BÊN DƯỚI
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
          onTap: _onTabTapped,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed, // fixed để hiển thị đều 5 nút
          selectedItemColor: AppColors.buttonBlue,
          unselectedItemColor: AppColors.textLight,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.local_activity_outlined),
              activeIcon: Icon(Icons.local_activity),
              label: 'Hoạt động',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Khám phá',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'About me',
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// Đây là giao diện Home cũ của bạn, mình bọc lại vào một Widget riêng 
// nằm ngay trong file này để nhét vào vị trí số 3 của PageView
// ----------------------------------------------------------------------
class _HomeTabContent extends StatelessWidget {
  const _HomeTabContent();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserState>();

    return Scaffold(
      backgroundColor: AppColors.mainBackground, // Gán màu nền F8F9FA
      appBar: AppBar(
        title: const Text(
          'Trang chủ',
          style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Đăng xuất',
            onPressed: () async {
              await context.read<UserState>().logout();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.waving_hand_rounded, size: 64, color: AppColors.buttonBlue.withOpacity(0.5)),
              const SizedBox(height: 24),
              const Text(
                'Màn hình chính',
                style: TextStyle(color: AppColors.textMain, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Xin chào, ${user.fullName.isNotEmpty ? user.fullName : user.username}!',
                style: const TextStyle(color: AppColors.logoLightBlue, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                user.email.isNotEmpty ? user.email : '(Chưa cập nhật email)',
                style: const TextStyle(color: AppColors.textSubtitle, fontSize: 14),
              ),
              const SizedBox(height: 40),
              const Text(
                '(Các tính năng đang được phát triển...)',
                style: TextStyle(color: AppColors.textLight, fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}