class ApiEndpoints {
  // Base URL ngrok - customer service auth
  static const String baseUrl = 'https://marilee-stichomythic-sharla.ngrok-free.dev/api';

  // --- Customer Auth endpoints ---
  static const String customerAuth = '$baseUrl/customer-auth';
  static const String register    = '$customerAuth/register';
  static const String login       = '$customerAuth/login';
  static const String forgotPassword = '$customerAuth/forgot-password';

  // --- Customer Discover endpoints ---
  static const String discoverRoomTypes = '$baseUrl/discover/room-types';

  // --- Customer Profile endpoints (MỚI) ---
  static const String customerProfile = '$baseUrl/customer/profile';
  static const String uploadAvatar    = '$baseUrl/customer/avatar';
}