// lib/features/discover/controllers/discover_controller.dart
import 'package:flutter/material.dart';
import '../models/room_type_model.dart';
import '../services/discover_service.dart';

class DiscoverController extends ChangeNotifier {
  List<RoomTypeModel> _allRoomTypes = [];
  List<RoomTypeModel> _roomTypes = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Filter state
  bool _isFilterApplied = false;
  String _searchQuery = '';
  String _priceType = 'hourly'; // 'hourly' or 'daily'
  double _minPrice = 100000;
  double _maxPrice = 100000;
  int _minCapacity = 1;
  int _maxCapacity = 1;

  List<RoomTypeModel> get roomTypes => _roomTypes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Getters for filters
  bool get isFilterApplied => _isFilterApplied;
  String get searchQuery => _searchQuery;
  String get priceType => _priceType;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  int get minCapacity => _minCapacity;
  int get maxCapacity => _maxCapacity;

  Future<void> fetchRoomTypes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); 

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      _allRoomTypes = await DiscoverService.getAllRoomTypes();
      
      // Reset filter về trạng thái ban đầu khi load lại trang
      _isFilterApplied = false;
      _searchQuery = '';
      _priceType = 'hourly';
      _minPrice = 100000;
      _maxPrice = 100000;
      _minCapacity = 1;
      _maxCapacity = 1;

      _applyFiltersInternal(); 
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    applyFilters();
  }

  void clearFilters() {
    _isFilterApplied = false;
    _priceType = 'hourly';
    _minPrice = 100000;
    _maxPrice = 100000;
    _minCapacity = 1;
    _maxCapacity = 1;
    applyFilters();
  }

  void setFilters({
    required String priceType,
    required double minPrice,
    required double maxPrice,
    required int minCapacity,
    required int maxCapacity,
  }) {
    _isFilterApplied = true;
    _priceType = priceType;
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _minCapacity = minCapacity;
    _maxCapacity = maxCapacity;
    applyFilters();
  }

  Future<void> applyFilters() async {
    _isLoading = true;
    notifyListeners();

    // Giả lập delay để hiển thị Skeleton loading theo yêu cầu
    await Future.delayed(const Duration(milliseconds: 400));
    
    _applyFiltersInternal();
  }

  void _applyFiltersInternal() {
    _roomTypes = _allRoomTypes.where((room) {
      // 1. Lọc theo tên
      final matchName = _searchQuery.isEmpty || 
          room.name.toLowerCase().contains(_searchQuery.toLowerCase());

      // Nếu chưa bao giờ bấm "Áp dụng" bộ lọc, thì chỉ lọc theo tên (search)
      if (!_isFilterApplied) {
        return matchName;
      }

      // 2. Lọc theo giá
      final priceToCompare = _priceType == 'hourly' ? room.hourlyPrice : room.dailyPrice;
      final matchPrice = priceToCompare >= _minPrice && priceToCompare <= _maxPrice;

      // 3. Lọc theo số lượng người
      final matchCapacity = room.capacity >= _minCapacity && room.capacity <= _maxCapacity;

      return matchName && matchPrice && matchCapacity;
    }).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> submitRoomTypeRating(String roomTypeId, int rating) async {
    await DiscoverService.submitRoomTypeRating(roomTypeId, rating);
  }
}