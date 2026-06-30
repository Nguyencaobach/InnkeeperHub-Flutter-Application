import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: Center(child: Text('Màn hình Khám phá')),
    );
  }
}