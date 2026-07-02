import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../models/room_type_model.dart';
import '../models/room_detail_model.dart'; // Import Model mới tạo ở Bước 1

class DiscoverService {
  // Lấy danh sách Loại phòng
  static Future<List<RoomTypeModel>> getAllRoomTypes() async {
    final urlString = '${ApiEndpoints.discoverRooms}?t=${DateTime.now().millisecondsSinceEpoch}';
    
    final response = await ApiClient.get(
      Uri.parse(urlString),
      requireAuth: false, 
    );
    
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      final List<dynamic> dataList = body['data'] ?? [];
      return dataList.map((item) => RoomTypeModel.fromJson(item)).toList();
    } else {
      throw Exception(body['message'] ?? 'Không thể tải danh sách loại phòng');
    }
  }

  // Đánh giá loại phòng
  static Future<bool> submitRoomTypeRating(String roomTypeId, int rating) async {
    final urlString = '${ApiEndpoints.discoverRooms}/$roomTypeId/rate';
    
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

  // THÊM MỚI: Lấy danh sách Phòng chi tiết theo Loại phòng
  static Future<List<RoomDetailModel>> getRoomDetailsByTypeId(String roomTypeId) async {
    final urlString = '${ApiEndpoints.discoverRooms}/$roomTypeId/rooms?t=${DateTime.now().millisecondsSinceEpoch}';
    
    final response = await ApiClient.get(
      Uri.parse(urlString),
      requireAuth: false, // Để false nếu ai cũng xem được DS phòng trống
    );
    
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      final List<dynamic> dataList = body['data'] ?? [];
      return dataList.map((item) => RoomDetailModel.fromJson(item)).toList();
    } else {
      throw Exception(body['message'] ?? 'Không thể tải danh sách phòng chi tiết');
    }
  }
}