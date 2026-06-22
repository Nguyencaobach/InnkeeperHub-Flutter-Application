import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import '../utils/token_storage.dart';

/// ApiClient trung tâm — xử lý toàn bộ HTTP request của app.
///
/// Tính năng:
///   1. Tự động gắn `Authorization: Bearer <token>` vào mọi request
///   2. Phát hiện 401 Unauthorized (token hết hạn) → tự logout + về LoginScreen
class ApiClient {
  // ─── NAVIGATOR KEY ──────────────────────────────────────────────────────────
  /// Key toàn cục để điều hướng mà không cần BuildContext.
  /// Phải gán vào MaterialApp.navigatorKey trong main.dart.
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // ─── HEADERS MẶC ĐỊNH ───────────────────────────────────────────────────────
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
    'ngrok-skip-browser-warning': 'true', // Bypass ngrok warning
  };

  // ─── LẤY HEADERS KÈM TOKEN ──────────────────────────────────────────────────
  /// Đọc token từ bộ nhớ và trả về headers với Authorization.
  static Future<Map<String, String>> _buildHeaders({
    Map<String, String>? extra,
    bool requireAuth = true,
  }) async {
    final headers = {..._defaultHeaders, ...?extra};
    if (requireAuth) {
      final token = await TokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // ─── XỬ LÝ 401 (TOKEN HẾT HẠN) ─────────────────────────────────────────────
  /// Khi nhận 401 → xóa session → điều hướng về LoginScreen.
  /// Dùng navigatorKey để điều hướng mà không cần context.
  static Future<void> _handleUnauthorized() async {
    // 1. Xóa token khỏi disk
    await TokenStorage.clearSession();

    // 2. Điều hướng về LoginScreen, xóa toàn bộ stack
    //    Dùng navigatorKey — không cần BuildContext
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (_) => false,
    );
  }

  // ─── GET ────────────────────────────────────────────────────────────────────
  /// Gửi GET request. Tự gắn token, tự xử lý 401.
  static Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    final mergedHeaders = await _buildHeaders(extra: headers, requireAuth: requireAuth);
    final response = await http.get(url, headers: mergedHeaders);
    if (response.statusCode == 401) await _handleUnauthorized();
    return response;
  }

  // ─── POST ───────────────────────────────────────────────────────────────────
  /// Gửi POST request. Tự gắn token, tự xử lý 401.
  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    bool requireAuth = true,
  }) async {
    final mergedHeaders = await _buildHeaders(extra: headers, requireAuth: requireAuth);
    final response = await http.post(
      url,
      headers: mergedHeaders,
      body: body != null ? jsonEncode(body) : null,
    );
    if (response.statusCode == 401) await _handleUnauthorized();
    return response;
  }

  // ─── PUT ────────────────────────────────────────────────────────────────────
  /// Gửi PUT request. Tự gắn token, tự xử lý 401.
  static Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    bool requireAuth = true,
  }) async {
    final mergedHeaders = await _buildHeaders(extra: headers, requireAuth: requireAuth);
    final response = await http.put(
      url,
      headers: mergedHeaders,
      body: body != null ? jsonEncode(body) : null,
    );
    if (response.statusCode == 401) await _handleUnauthorized();
    return response;
  }

  // ─── DELETE ─────────────────────────────────────────────────────────────────
  /// Gửi DELETE request. Tự gắn token, tự xử lý 401.
  static Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    final mergedHeaders = await _buildHeaders(extra: headers, requireAuth: requireAuth);
    final response = await http.delete(url, headers: mergedHeaders);
    if (response.statusCode == 401) await _handleUnauthorized();
    return response;
  }
}