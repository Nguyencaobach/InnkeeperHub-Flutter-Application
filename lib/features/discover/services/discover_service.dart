// lib/features/discover/services/discover_service.dart
import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../models/room_type_model.dart';

class DiscoverService {
  static Future<List<RoomTypeModel>> getAllRoomTypes() async {
    // QUAN TRỌNG: Thêm tham số thời gian (?t=...) vào đuôi URL
    // Mỗi mili-giây link sẽ khác nhau -> Ép mạng phải lấy dữ liệu mới nhất
    final urlString = '${ApiEndpoints.discoverRoomTypes}?t=${DateTime.now().millisecondsSinceEpoch}';
    
    final response = await ApiClient.get(
      Uri.parse(urlString),
      requireAuth: false, 
    );
    
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      final List<dynamic> dataList = body['data'] ?? [];
      return dataList.map((item) => RoomTypeModel.fromJson(item)).toList();
    } else {
      throw Exception(body['message'] ?? 'Không thể tải danh sách phòng');
    }
  }

  static Future<bool> submitRoomTypeRating(String roomTypeId, int rating) async {
    final urlString = '${ApiEndpoints.discoverRoomTypes}/$roomTypeId/rate';
    
    final response = await ApiClient.post(
      Uri.parse(urlString),
      body: {'rating': rating},
      requireAuth: true,
    );
    
    final body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300 && body['success'] == true) {
      return true;
    } else {
      throw Exception(body['message'] ?? 'Không thể gửi đánh giá');
    }
  }
}