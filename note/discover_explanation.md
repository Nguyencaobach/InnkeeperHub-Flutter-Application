# Giải thích Logic và Giao diện màn hình Discover & Room Type Detail

Tài liệu này giải thích 3 cơ chế chính đã được sử dụng để xây dựng tính năng Khám phá và Chi tiết loại phòng.

---

## 1. Luồng truyền dữ liệu khi bấm vào Card phòng
Làm thế nào mà khi bấm vào một phòng, màn hình chi tiết lại biết chính xác đó là phòng nào mà không cần gọi thêm API?

**Cơ chế:** Truyền Object trực tiếp qua Constructor.

- Ở file `discover_screen.dart`, chúng ta dùng một `ListView.builder` để vẽ danh sách. Tại mỗi vị trí `index`, ta lấy được một object `RoomTypeModel` cụ thể:
  ```dart
  final room = controller.roomTypes[index];
  ```
- Ta bọc cái thẻ `RoomCard` bằng một `GestureDetector` (Bộ phát hiện cử chỉ).
- Khi sự kiện `onTap` (chạm vào) được kích hoạt, ta gọi `Navigator.push` để mở màn hình `RoomTypeDetailScreen`. Điểm mấu chốt là ta **nhét luôn cái object `room` đó vào hàm khởi tạo** của màn hình chi tiết:
  ```dart
  builder: (context) => RoomTypeDetailScreen(roomType: room),
  ```
- Nhờ vậy, màn hình chi tiết nhận được toàn bộ dữ liệu (tên, giá, ảnh, tiện ích...) ngay lập tức trong bộ nhớ RAM mà không cần tốn thời gian gọi lại Backend để hỏi xem "Phòng ID này có dữ liệu gì?".

---

## 2. Hiệu ứng cuộn làm ảnh thu nhỏ lại (Parallax Effect)
Trong màn hình chi tiết, khi bạn vuốt nội dung lên, bức ảnh không bị trôi tuột đi như bình thường mà nó sẽ cuộn chậm hơn, xẹp dần lại rất mượt.

**Cơ chế:** Sử dụng `CustomScrollView` và `SliverAppBar`.

Thay vì dùng `SingleChildScrollView` hay `ListView` thông thường (những thứ cuộn tất cả nội dung cùng một tốc độ), ta dùng kiến trúc **Sliver**:
- `CustomScrollView`: Là khung cuộn đặc biệt cho phép thiết lập các hiệu ứng cuộn phức tạp.
- `SliverAppBar`: Là thanh tiêu đề có khả năng co giãn.
  - `expandedHeight: 380.0`: Định nghĩa chiều cao lúc kéo giãn tối đa của bức ảnh là 380px.
  - `pinned: true`: Giữ cho nút Back (quay lại) luôn ghim ở trên cùng dù ảnh đã bị cuộn khuất.
  - `FlexibleSpaceBar`: Đây chính là Widget làm nên phép thuật. Nó tự động tính toán khoảng cách cuộn của người dùng để tạo ra hiệu ứng thu nhỏ (parallax) bức ảnh nằm bên trong nó khi cuộn lên.

---

## 3. Cách gán chữ đè lên ảnh và giữ cho chữ luôn dễ đọc
Làm sao để đặt chữ "Tên phòng" nằm lọt thỏm ngay ngắn ở góc dưới bức ảnh, và làm sao đảm bảo chữ màu trắng không bị "tàng hình" nếu lỡ bức ảnh phòng đó có màu nền quá sáng?

**Cơ chế:** Sử dụng `Stack`, `Positioned` và `LinearGradient`.

- **`Stack` (Xếp lớp):** Là Widget cho phép xếp các phần tử đè lên nhau (giống như Layer trong Photoshop). Ở đây ta có 3 lớp xếp từ dưới lên trên:
  1. **Lớp dưới cùng (Ảnh):** Thẻ `Image.network` hiển thị hình ảnh phòng.
  2. **Lớp ở giữa (Mặt nạ Gradient đen):** Đây là một kĩ thuật UI cực kỳ phổ biến. Ta phủ một lớp `Container` trong suốt, nhưng đổ màu Gradient từ Đen thui ở dưới cùng (`bottomCenter`) nhạt dần thành Trong suốt ở giữa (`topCenter`).
  3. **Lớp trên cùng (Chữ):** Chữ màu trắng hiển thị Tên phòng.

- **`Positioned` (Định vị):** Ta dùng Widget `Positioned(bottom: 30, left: 20...)` để "gắp" cái Tên phòng và neo nó cách mép dưới cùng của bức ảnh đúng 30 pixel.

**Tác dụng của lớp Gradient đen:** Nó tạo ra một cái bóng râm tối ở mép dưới ảnh. Dù bức ảnh gốc có trắng toát đi chăng nữa, thì Tên phòng (màu trắng) nằm trên cái bóng râm này vẫn luôn cực kỳ nổi bật và sắc nét.
