// lib/features/discover/widgets/room_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/room_type_model.dart';

class RoomCard extends StatelessWidget {
  final RoomTypeModel room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final String domain = ApiEndpoints.baseUrl.replaceAll('/api', '');
    final String imageUrl = room.roomImgUrl.startsWith('/') 
        ? '$domain${room.roomImgUrl}' 
        : room.roomImgUrl;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              imageUrl,
              width: 120,
              height: 120, // Rút ngắn lại cho vừa với số lượng text ít
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 120,
                height: 120,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TÊN PHÒNG
                  Text(
                    room.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMain),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // SỨC CHỨA
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 16, color: AppColors.logoLightBlue),
                      const SizedBox(width: 4),
                      Text(
                        'Tối đa ${room.capacity} người',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSubtitle),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // GIÁ TIỀN
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${formatCurrency.format(room.dailyPrice)}/ngày',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textMain),
                      ),
                      Text(
                        'hoặc ${formatCurrency.format(room.hourlyPrice)}/giờ',
                        style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}