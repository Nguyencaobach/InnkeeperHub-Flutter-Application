class ApiEndpoints {
  // Base URL ngrok - customer service auth
  static const String baseUrl = 'https://marilee-stichomythic-sharla.ngrok-free.dev/api';

  // --- Customer Auth endpoints ---
  static const String customerAuth = '$baseUrl/customer-auth';
  static const String register    = '$customerAuth/register';
  static const String login       = '$customerAuth/login';
  static const String forgotPassword = '$customerAuth/forgot-password';
}