// lib/features/discover/views/room_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/room_detail_controller.dart';
import '../widgets/room_detail_card.dart';
import '../widgets/skeleton_room_detail_card.dart';
import '../../../core/theme/app_text_styles.dart';

class RoomDetailsScreen extends StatefulWidget {
  final String roomTypeId;
  final String roomTypeName;

  const RoomDetailsScreen({
    super.key,
    required this.roomTypeId,
    required this.roomTypeName,
  });

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoomDetailController>().fetchRoomDetails(widget.roomTypeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RoomDetailController>();

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textMain),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Room List',
                          style: AppTextStyles.titleLarge,
                        ),
                        Text(
                          widget.roomTypeName,
                          style: const TextStyle(color: AppColors.textSubtitle, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
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
                        onChanged: (value) => context.read<RoomDetailController>().setSearchQuery(value),
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm phòng...',
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
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Builder(
        builder: (context) {
          if (controller.isLoading) {
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 6,
              itemBuilder: (context, index) => const SkeletonRoomDetailCard(),
            );
          }

          if (controller.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.grey, size: 64),
                  const SizedBox(height: 16),
                  Text(controller.errorMessage!, style: const TextStyle(color: AppColors.textSubtitle)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.fetchRoomDetails(widget.roomTypeId),
                    child: const Text('Thử lại'),
                  )
                ],
              ),
            );
          }

          if (controller.roomDetails.isEmpty) {
            return const Center(
              child: Text('Chưa có phòng nào thuộc loại này.', style: TextStyle(color: AppColors.textSubtitle)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            itemCount: controller.roomDetails.length,
            itemBuilder: (context, index) {
              return RoomDetailCard(room: controller.roomDetails[index]);
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