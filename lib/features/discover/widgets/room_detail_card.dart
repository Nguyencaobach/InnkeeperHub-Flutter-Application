// lib/features/discover/widgets/room_detail_card.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/room_detail_model.dart';

class RoomDetailCard extends StatelessWidget {
  final RoomDetailModel room;

  const RoomDetailCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    // Xử lý màu sắc và text theo trạng thái phòng
    Color statusColor;
    String statusText;
    
    switch (room.status) {
      case 'AVAILABLE':
        statusColor = Colors.green;
        statusText = 'Đang trống';
        break;
      case 'OCCUPIED':
        statusColor = Colors.grey;
        statusText = 'Đang có khách';
        break;
      case 'CLEANING':
        statusColor = Colors.orange;
        statusText = 'Đang dọn dẹp';
        break;
      case 'MAINTENANCE':
        statusColor = Colors.redAccent;
        statusText = 'Đang bảo trì';
        break;
      default:
        statusColor = Colors.black;
        statusText = room.status;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.logoLightBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.door_front_door_outlined, color: AppColors.logoLightBlue),
              ),
              const SizedBox(width: 16),
              Text(
                'Phòng ${room.roomNumber}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMain),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withOpacity(0.5)),
            ),
            child: Text(
              statusText,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor),
            ),
          ),
        ],
      ),
    );
  }
}