# Cơ Chế Quản Lý Trạng Thái (State Management) với Provider

Tài liệu này giải thích về đoạn code khai báo Kho dữ liệu chung trong file `main.dart`:
```dart
ChangeNotifierProvider(create: (_) => DiscoverController())
```

## 1. Kiểu cơ chế: Provider / ChangeNotifier
Cơ chế này dựa trên pattern **Observer (Người quan sát)**:
- **DiscoverController** đóng vai trò là "Kho chứa dữ liệu" (State/Model). Nó kế thừa class `ChangeNotifier`.
- Khi bạn đặt `ChangeNotifierProvider` ở file `main.dart` (thường là bọc ngoài `MaterialApp` hoặc ở cấp rất cao), nó sẽ cấp phát **duy nhất một instance (bản sao)** của `DiscoverController` và chia sẻ cho toàn bộ các màn hình/widget nằm bên dưới nó sử dụng chung.

## 2. Cách hoạt động
Luồng dữ liệu hoạt động như sau:
1. **Khởi tạo:** Khi app chạy tới dòng này, nó gọi hàm `create: (_) => DiscoverController()` để tạo ra một Object `DiscoverController` lưu vào bộ nhớ.
2. **Cập nhật dữ liệu:** Bên trong `DiscoverController`, bất cứ khi nào dữ liệu thay đổi (ví dụ: đang tải dữ liệu `_isLoading = true`, hoặc lấy xong danh sách phòng `_roomTypes = ...`), nó sẽ gọi hàm **`notifyListeners()`**.
3. **Lắng nghe & Render lại:** Hàm `notifyListeners()` sẽ phát ra một tín hiệu. Tất cả các Widget (giao diện) nào đang "đăng ký nghe" cái kho `DiscoverController` này sẽ lập tức tự động render (build) lại giao diện bằng dữ liệu mới nhất.

## 3. Cách xài trong các màn hình (Cách gọi và lắng nghe)

Để sử dụng kho dữ liệu này ở bất kỳ màn hình nào (ví dụ màn hình Khám Phá), bạn có 3 cách chính tuỳ theo mục đích:

### Cách 1: Sử dụng `context.watch()`
Khi bạn muốn lấy dữ liệu để hiển thị **và muốn tự động cập nhật UI khi dữ liệu đổi**.
```dart
Widget build(BuildContext context) {
  // Đăng ký "lắng nghe". Mỗi khi DiscoverController gọi notifyListeners(), Widget này sẽ build lại.
  final discoverState = context.watch<DiscoverController>();

  if (discoverState.isLoading) {
    return CircularProgressIndicator(); // Đang load
  }

  return ListView.builder(
    itemCount: discoverState.roomTypes.length,
    itemBuilder: (context, index) {
      final room = discoverState.roomTypes[index];
      return Text(room.name);
    },
  );
}
```

### Cách 2: Sử dụng `context.read()`
Khi bạn chỉ muốn gọi hàm thực thi (**KHÔNG cần lắng nghe thay đổi**). Thường dùng trong các hàm sự kiện như khi bấm nút (`onPressed`):
```dart
ElevatedButton(
  onPressed: () {
    // Chỉ gọi hàm lấy dữ liệu, không cần build lại giao diện nút này
    context.read<DiscoverController>().fetchRoomTypes();
    
    // Hoặc gọi hàm tìm kiếm
    context.read<DiscoverController>().setSearchQuery("Phòng VIP");
  },
  child: Text("Tải lại phòng"),
)
```

### Cách 3: Sử dụng `Consumer`
Cách tối ưu hiệu năng. Thay vì `context.watch()` làm build lại toàn bộ hàm `build()`, bạn bọc `Consumer` ở đúng cái Widget cần thay đổi:
```dart
Consumer<DiscoverController>(
  builder: (context, controller, child) {
    return Text("Số phòng tìm thấy: ${controller.roomTypes.length}");
  },
)
```

## Tóm tắt
Dòng code ở `main.dart` là bước "Khai báo & Mở kho" cấp toàn cục. Bất kì màn hình Khám Phá hay Tìm kiếm nào trong app cũng có thể móc nối vào `DiscoverController` để lấy danh sách phòng chung, lấy bộ lọc dùng chung mà không cần phải truyền dữ liệu thủ công qua lại giữa các màn hình.
