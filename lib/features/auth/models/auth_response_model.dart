// lib/features/auth/models/auth_response_model.dart

import '../../../core/models/user_model.dart'; // Mượn cái khuôn UserModel ở trên vào đây

class AuthResponseModel {
  // --- 1. KHAI BÁO 2 MÓN ĐỒ BÊN TRONG HỘP BƯU PHẨM ---
  final String accessToken; // Món 1: Chìa khóa để đi lại trong App
  final UserModel user;     // Món 2: Cái thẻ căn cước (chứa tên, tuổi, email...)

  // --- 2. CONSTRUCTOR (ĐÓNG GÓI HỘP BƯU PHẨM) ---
  AuthResponseModel({
    required this.accessToken,
    required this.user,
  });

  // --- 3. HÀM MỞ HỘP (TỪ JSON SANG MODEL) ---
  // Khi Backend trả kết quả Đăng nhập thành công về, ta gọi hàm này để lấy chìa khóa và thẻ ra
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      // Lấy chìa khóa ra (nếu không có thì gán rỗng)
      accessToken: json['accessToken'] as String? ?? '', 
      
      // Lấy cục dữ liệu 'customer' ra, rồi gọi hàm UserModel.fromJson() để đúc nó thành cái thẻ căn cước
      user: UserModel.fromJson(json['customer'] as Map<String, dynamic>? ?? {}),
    );
  }
}