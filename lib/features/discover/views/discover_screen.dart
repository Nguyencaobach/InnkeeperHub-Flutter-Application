// lib/features/discover/views/discover_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/discover_controller.dart';
import '../widgets/room_card.dart';
import '../widgets/skeleton_room_card.dart';
import '../widgets/filter_bottom_sheet.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<DiscoverController>();
      // Nếu Kho dữ liệu rỗng thì mới gọi API, có rồi thì dùng luôn
      if (controller.roomTypes.isEmpty) {
        controller.fetchRoomTypes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Theo dõi trạng thái từ Kho chung
    final controller = context.watch<DiscoverController>();

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              const Text(
                'Discover',
                style: AppTextStyles.titleLarge,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) => context.read<DiscoverController>().setSearchQuery(value),
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm loại phòng...',
                          hintStyle: AppTextStyles.hintText,
                          prefixIcon: Icon(Icons.search, color: AppColors.textLight, size: 22),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: AppColors.buttonBlue,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.buttonBlue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: Colors.white),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const FilterBottomSheet(),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child: Builder(
                  builder: (context) {
                    if (controller.isLoading) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) => const SkeletonRoomCard(),
                      );
                    }

                    if (controller.errorMessage != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.wifi_off_rounded, color: Colors.grey, size: 64),
                            const SizedBox(height: 16),
                            Text(
                              controller.errorMessage!,
                              style: const TextStyle(color: AppColors.textSubtitle),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: controller.fetchRoomTypes,
                              child: const Text('Thử lại'),
                            )
                          ],
                        ),
                      );
                    }

                    if (controller.roomTypes.isEmpty) {
                      return const Center(
                        child: Text(
                          'Chưa có loại phòng nào.',
                          style: TextStyle(color: AppColors.textSubtitle),
                        ),
                      );
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: controller.roomTypes.length,
                      itemBuilder: (context, index) {
                        return RoomCard(room: controller.roomTypes[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}