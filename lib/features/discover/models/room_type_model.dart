// lib/features/discover/models/room_type_model.dart
import 'dart:convert';

class RoomTypeModel {
  final String id;
  final String name;
  final int hourlyPrice;
  final int dailyPrice;
  final String floor;
  final int capacity;
  final String bedType;
  final int roomSize;
  final String viewType;
  final String roomImgUrl;
  final List<String> amenities; // Tiện ích (Để dành dùng cho màn hình chi tiết sau này)

  RoomTypeModel({
    required this.id,
    required this.name,
    required this.hourlyPrice,
    required this.dailyPrice,
    required this.floor,
    required this.capacity,
    required this.bedType,
    required this.roomSize,
    required this.viewType,
    required this.roomImgUrl,
    required this.amenities,
  });

  factory RoomTypeModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedAmenities = [];
    final rawAmenities = json['amenities'];
    
    if (rawAmenities != null) {
      if (rawAmenities is List) {
        parsedAmenities = rawAmenities.map((e) => e.toString()).toList();
      } else if (rawAmenities is String) {
        try {
          final decoded = jsonDecode(rawAmenities);
          if (decoded is List) {
            parsedAmenities = decoded.map((e) => e.toString()).toList();
          }
        } catch (_) {}
      }
    }

    return RoomTypeModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '...',
      hourlyPrice: int.tryParse(json['hourly_price']?.toString() ?? '0') ?? 0,
      dailyPrice: int.tryParse(json['daily_price']?.toString() ?? '0') ?? 0,
      floor: json['floor']?.toString() ?? '...',
      capacity: int.tryParse(json['capacity']?.toString() ?? '0') ?? 0,
      bedType: json['bed_type']?.toString() ?? '...',
      roomSize: int.tryParse(json['room_size']?.toString() ?? '0') ?? 0,
      viewType: json['view_type']?.toString() ?? '...',
      roomImgUrl: json['room_img_url']?.toString() ?? '',
      amenities: parsedAmenities,
    );
  }
}