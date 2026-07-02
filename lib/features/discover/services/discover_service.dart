<<<<<<< HEAD
// lib/features/discover/services/discover_service.dart
=======
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../models/room_type_model.dart';
<<<<<<< HEAD

class DiscoverService {
  static Future<List<RoomTypeModel>> getAllRoomTypes() async {
    // QUAN TRỌNG: Thêm tham số thời gian (?t=...) vào đuôi URL
    // Mỗi mili-giây link sẽ khác nhau -> Ép mạng phải lấy dữ liệu mới nhất
    final urlString = '${ApiEndpoints.discoverRoomTypes}?t=${DateTime.now().millisecondsSinceEpoch}';
=======
import '../models/room_detail_model.dart'; // Import Model mới tạo ở Bước 1

class DiscoverService {
  // Lấy danh sách Loại phòng
  static Future<List<RoomTypeModel>> getAllRoomTypes() async {
    final urlString = '${ApiEndpoints.discoverRooms}?t=${DateTime.now().millisecondsSinceEpoch}';
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
    
    final response = await ApiClient.get(
      Uri.parse(urlString),
      requireAuth: false, 
    );
    
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      final List<dynamic> dataList = body['data'] ?? [];
      return dataList.map((item) => RoomTypeModel.fromJson(item)).toList();
    } else {
<<<<<<< HEAD
      throw Exception(body['message'] ?? 'Không thể tải danh sách phòng');
    }
  }

  static Future<bool> submitRoomTypeRating(String roomTypeId, int rating) async {
    final urlString = '${ApiEndpoints.discoverRoomTypes}/$roomTypeId/rate';
=======
      throw Exception(body['message'] ?? 'Không thể tải danh sách loại phòng');
    }
  }

  // Đánh giá loại phòng
  static Future<bool> submitRoomTypeRating(String roomTypeId, int rating) async {
    final urlString = '${ApiEndpoints.discoverRooms}/$roomTypeId/rate';
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
    
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
<<<<<<< HEAD
=======

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
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
}