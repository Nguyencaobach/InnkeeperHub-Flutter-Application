// lib/features/discover/controllers/discover_controller.dart
import 'package:flutter/material.dart';
import '../models/room_type_model.dart';
import '../services/discover_service.dart';

class DiscoverController extends ChangeNotifier {
  List<RoomTypeModel> _roomTypes = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<RoomTypeModel> get roomTypes => _roomTypes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRoomTypes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Gọi UI hiện Skeleton loading

    // THÊM: Độ trễ 300ms để bạn kịp nhìn thấy hiệu ứng chớp khung xám (Skeleton)
    // Chứng minh là app CÓ load lại dữ liệu
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      _roomTypes = await DiscoverService.getAllRoomTypes();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners(); // Tắt loading, hiện dữ liệu thật
    }
  }
}