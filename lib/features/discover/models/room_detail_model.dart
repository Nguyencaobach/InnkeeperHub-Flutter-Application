// lib/features/discover/models/room_detail_model.dart

class RoomDetailModel {
  final String id;
  final String roomNumber;
  final String status;

  RoomDetailModel({
    required this.id,
    required this.roomNumber,
    required this.status,
  });

  factory RoomDetailModel.fromJson(Map<String, dynamic> json) {
    return RoomDetailModel(
      id: json['id']?.toString() ?? '',
      roomNumber: json['room_number']?.toString() ?? '',
      status: json['status']?.toString() ?? 'AVAILABLE',
    );
  }
}