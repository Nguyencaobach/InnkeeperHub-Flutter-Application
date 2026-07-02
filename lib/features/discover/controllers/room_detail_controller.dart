import 'package:flutter/material.dart';
import '../models/room_detail_model.dart';
import '../services/discover_service.dart';

class RoomDetailController extends ChangeNotifier {
  List<RoomDetailModel> _roomDetails = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _statusFilter = 'ALL'; // Trạng thái mặc định là Tất cả

  List<RoomDetailModel> get roomDetails {
    List<RoomDetailModel> filtered = _roomDetails;

    // Lọc theo trạng thái trước
    if (_statusFilter != 'ALL') {
      filtered = filtered.where((room) => room.status.toUpperCase() == _statusFilter).toList();
    }

    if (_searchQuery.isEmpty) return filtered;
    
    // Hàm con để chuẩn hóa chữ (bỏ dấu tiếng Việt, đưa về chữ thường)
    String normalizeText(String text) {
      return text.toLowerCase()
          .replaceAll(RegExp(r'[áàạảãâấầậẩẫăắằặẳẵ]'), 'a')
          .replaceAll(RegExp(r'[éèẹẻẽêếềệểễ]'), 'e')
          .replaceAll(RegExp(r'[íìịỉĩ]'), 'i')
          .replaceAll(RegExp(r'[óòọỏõôốồộổỗơớờợởỡ]'), 'o')
          .replaceAll(RegExp(r'[úùụủũưứừựửữ]'), 'u')
          .replaceAll(RegExp(r'[ýỳỵỷỹ]'), 'y')
          .replaceAll(RegExp(r'[đ]'), 'd')
          .trim();
    }

    // Chuẩn hóa từ khóa người dùng nhập (VD: "Phòng 104" -> "phong 104")
    final query = normalizeText(_searchQuery);
    
    // Cắt chữ "phong" ra để lấy cốt lõi (VD: "phong 104" -> "104")
    final queryWithoutPhong = query.replaceAll('phong', '').trim();

    return filtered.where((room) {
      // Chuẩn hóa tên phòng thực tế (VD: "104" -> "104", "A1" -> "a1")
      final roomNum = normalizeText(room.roomNumber);
      
      return roomNum.contains(query) ||               // Tìm chính xác (VD: gõ "104" -> tìm "104")
             'phong $roomNum'.contains(query) ||      // Gõ "phong 104" -> tìm chữ "phong " ghép với "104"
             (queryWithoutPhong.isNotEmpty && roomNum.contains(queryWithoutPhong)); // Lọc bỏ chữ phòng đi để tìm
    }).toList();
  }
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get statusFilter => _statusFilter;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners();
  }

  Future<void> fetchRoomDetails(String roomTypeId) async {
    // Reset state mỗi lần gọi
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); 

    // Giả lập thời gian chờ để kịp vẽ Skeleton cho đẹp
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      _roomDetails = await DiscoverService.getRoomDetailsByTypeId(roomTypeId);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}