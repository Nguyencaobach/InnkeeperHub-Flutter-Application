import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.mainBackground, // Gán màu nền ở đây
      body: Center(child: Text('Màn hình Hoạt động')),
    );
  }
}