# Cơ Chế Xác Thực Token Trong Chức Năng Discover (Khám Phá)

Tài liệu này giải đáp hai câu hỏi liên quan đến việc quản lý UserState và cơ chế đính kèm Token trong màn hình Khám Phá (`DiscoverScreen`).

## 1. Màn hình Discover có sử dụng UserState để tải dữ liệu đăng nhập không?

**Trả lời: KHÔNG.** 
Hiện tại, màn hình `DiscoverScreen` (file `lib/features/discover/views/discover_screen.dart`) hoàn toàn không gọi hay sử dụng `UserState`.

Màn hình này chỉ giao tiếp duy nhất với `DiscoverController` để lấy danh sách phòng và xử lý bộ lọc. Tuy nhiên, `UserState` đã được khởi tạo ở cấp cao nhất của App (trong file `main.dart` qua `MultiProvider`), nên sau này nếu bạn muốn lấy thông tin user ở màn hình `DiscoverScreen` (ví dụ để kiểm tra xem khách đã đăng nhập chưa trước khi cho phép bấm nút "Đặt phòng"), bạn hoàn toàn có thể lấy ra dễ dàng bằng lệnh `context.read<UserState>()`.

## 2. Lúc gửi request đi, Discover gắn Token trong kho ở đoạn nào?

**Trả lời:** Điểm thú vị là ở API Discover này, App của bạn **KHÔNG HỀ GẮN TOKEN**.

Hãy cùng xem lại file `lib/features/discover/services/discover_service.dart`. Ở hàm `getAllRoomTypes`, bạn đang gọi API như sau:

```dart
final response = await ApiClient.get(
  Uri.parse(urlString),
  requireAuth: false, // <--- CHÚ Ý DÒNG NÀY
);
```

Bởi vì bạn truyền `requireAuth: false`, hãy xem chuyện gì xảy ra trong "trái tim" xử lý mạng của bạn là file `lib/core/network/api_client.dart`:

```dart
static Future<Map<String, String>> _buildHeaders({
  Map<String, String>? extra,
  bool requireAuth = true,
}) async {
  final headers = {..._defaultHeaders, ...?extra};
  
  if (requireAuth) { // <--- VÌ REQUIRE_AUTH LÀ FALSE NÊN NÓ SẼ BỎ QUA KHỐI LỆNH NÀY
    final token = await TokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
  }
  return headers;
}
```

Vì `requireAuth` bị đặt là `false`, hàm `_buildHeaders` đã bỏ qua việc móc Token từ ổ cứng (`TokenStorage`) và không hề gắn header `Authorization: Bearer <token>` vào request.

### Tại sao lại thiết kế như vậy?
Điều này là hoàn toàn đúng với thiết kế hệ thống của bạn! Nếu bạn kiểm tra code Backend (file `src/modules/customer-services/discover/room-types/room-types.route.js`), API `GET /api/discover/room-types` là một API Public (không đi qua middleware verifyToken). Việc này cho phép khách hàng vãng lai (chưa cần đăng nhập) vẫn có thể mở App lên và lướt xem các loại phòng.

### Tóm lại
- Nếu một API cần token, bạn chỉ cần bỏ tham số `requireAuth: false` đi (vì mặc định nó là `true`).
- File `ApiClient` của bạn sẽ tự động chui vào `TokenStorage` lấy token và gắn vào Header cho bạn mà không cần bạn phải tự tay viết code gắn token ở từng Service.
- Kiến trúc mạng (Network Architecture) này của bạn đang được tổ chức rất gọn gàng và chuẩn xác!
