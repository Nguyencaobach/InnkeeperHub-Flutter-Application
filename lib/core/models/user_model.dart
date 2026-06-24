// lib/core/models/user_model.dart

class UserModel {
  // --- 1. KHAI BÁO CÁC THUỘC TÍNH (THÔNG TIN TRÊN THẺ CĂN CƯỚC) ---
  final String customerId; // Mã khách hàng
  final String username;   // Tên đăng nhập
  final String fullName;   // Họ và tên
  final String email;      // Địa chỉ email
  final String phoneNumber;// Số điện thoại
  final String avatarUrl;  // Link ảnh đại diện (Có thể rỗng nên ta không bắt buộc)

  // --- 2. CONSTRUCTOR (HÀM KHỞI TẠO ĐỂ ĐÚC RA CÁI THẺ NÀY) ---
  UserModel({
    required this.customerId,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.avatarUrl = '', // Nếu backend không trả về ảnh, ta tự động gán là chuỗi rỗng
  });

  // --- 3. HÀM TỪ JSON SANG MODEL (DỊCH TIẾNG BACKEND SANG TIẾNG FLUTTER) ---
  // Khi Backend gửi về cục dữ liệu Map (JSON), ta dùng hàm này để nhét nó vào khuôn UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Dùng dấu ?? '' để đề phòng Backend gửi thiếu trường nào thì ta gán chuỗi rỗng luôn, không bị crash App
      customerId: json['customer_id'] as String? ?? '', 
      username: json['username'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
    );
  }

  // --- 4. HÀM TỪ MODEL SANG JSON (DỊCH TIẾNG FLUTTER THÀNH TIẾNG ĐỂ LƯU Ổ CỨNG) ---
  // Hàm này rất hữu ích khi bạn muốn đem cái UserModel này cất vào TokenStorage (SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'username': username,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
    };
  }
}