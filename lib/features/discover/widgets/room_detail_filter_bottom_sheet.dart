import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/room_detail_controller.dart';

class RoomDetailFilterBottomSheet extends StatefulWidget {
  const RoomDetailFilterBottomSheet({super.key});

  @override
  State<RoomDetailFilterBottomSheet> createState() => _RoomDetailFilterBottomSheetState();
}

class _RoomDetailFilterBottomSheetState extends State<RoomDetailFilterBottomSheet> {
  late String _statusFilter;

  @override
  void initState() {
    super.initState();
    // Lấy trạng thái bộ lọc hiện tại từ controller
    _statusFilter = context.read<RoomDetailController>().statusFilter;
  }

  void _applyFilter(String status) {
    setState(() {
      _statusFilter = status;
    });
    context.read<RoomDetailController>().setStatusFilter(status);
    Navigator.pop(context);
  }

  Widget _buildFilterOption(String title, String value) {
    final isSelected = _statusFilter == value;
    return GestureDetector(
      onTap: () => _applyFilter(value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.buttonBlue : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.buttonBlue : Colors.transparent,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textMain,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Lọc theo trạng thái', style: AppTextStyles.titleLarge),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMain),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildFilterOption('Tất cả', 'ALL'),
            const SizedBox(height: 12),
            _buildFilterOption('Phòng trống', 'AVAILABLE'),
            const SizedBox(height: 12),
            _buildFilterOption('Đang thuê', 'OCCUPIED'),
            const SizedBox(height: 12),
            _buildFilterOption('Bảo trì', 'MAINTENANCE'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
