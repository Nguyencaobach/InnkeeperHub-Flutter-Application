# Cơ chế hoạt động của Giao diện Chọn sao Đánh giá (Rating Bottom Sheet)

Tài liệu này giải thích chi tiết về cách component chọn sao (`RatingBottomSheet`) hoạt động trong thư mục `lib/features/discover/widgets/rating_bottom_sheet.dart`. 

---

## 1. Bản chất của Component này là gì?
Component này là một **StatefulWidget**. Nghĩa là nó có một bộ nhớ riêng biệt tên là `State` để lưu trữ dữ liệu có thể thay đổi được trên màn hình, ở đây chính là số lượng sao mà người dùng đang chọn:
```dart
int selectedRating = 5; // Mặc định khi mở lên là 5 sao
```

Khi bạn chạm vào màn hình (ví dụ chọn 3 sao), nó sẽ gán lại `selectedRating = 3` và gọi hàm `setState(() {...})` để vẽ lại màn hình theo giá trị mới này.

## 2. Cách tạo ra 5 Ngôi sao (Vòng lặp)
Thay vì copy/paste 5 đoạn code tạo icon Ngôi sao giống nhau, ta sử dụng hàm `List.generate(5, (index) {...})` để tạo ra một hàng ngang (`Row`) có 5 phần tử.

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: List.generate(5, (index) {
    final ratingValue = index + 1; // index chạy từ 0->4, nên ratingValue là 1->5
    // ... xử lý logic từng sao ...
  }),
),
```

## 3. Cơ chế đổi màu (Vàng / Xám) cực kỳ thông minh
Làm sao để khi chọn 3 sao thì 3 sao đầu sáng lên, 2 sao cuối bị tắt đi? Bí quyết nằm ở câu lệnh kiểm tra logic:

```dart
final isSelected = ratingValue <= selectedRating;
```

**Ví dụ:** Người dùng đang bấm vào ngôi sao thứ 3 (`selectedRating = 3`). Vòng lặp sẽ chạy vẽ lại 5 ngôi sao, kiểm tra từng ngôi sao một:
- Sao số 1: `1 <= 3` (Đúng) -> `isSelected = true` -> Trạng thái: **Sáng (Màu cam/vàng)**
- Sao số 2: `2 <= 3` (Đúng) -> `isSelected = true` -> Trạng thái: **Sáng (Màu cam/vàng)**
- Sao số 3: `3 <= 3` (Đúng) -> `isSelected = true` -> Trạng thái: **Sáng (Màu cam/vàng)**
- Sao số 4: `4 <= 3` (Sai) -> `isSelected = false` -> Trạng thái: **Tắt (Màu xám)**
- Sao số 5: `5 <= 3` (Sai) -> `isSelected = false` -> Trạng thái: **Tắt (Màu xám)**

Đoạn code áp dụng màu:
```dart
Icon(
  isSelected ? Icons.star : Icons.star_border, // Nếu Sáng thì icon sao đặc, Tắt thì viền rỗng
  color: isSelected ? Colors.orangeAccent : Colors.grey[400], // Sáng thì màu Cam, Tắt thì Xám
  size: 40,
)
```

## 4. Cơ chế gửi sự kiện khi chạm (GestureDetector)
Mỗi icon ngôi sao được bọc trong một cái "Cảm biến chạm" gọi là `GestureDetector`.
```dart
GestureDetector(
  onTap: () {
    setState(() {
      selectedRating = ratingValue;
    });
  },
  child: // ... Icon ngôi sao ...
)
```
Mỗi khi bạn chạm ngón tay vào một ngôi sao (ví dụ sao 4), `ratingValue` lúc đó là 4, lập tức cập nhật lại biến state chung và ra lệnh vẽ lại màn hình.

## 5. Trả kết quả về cho màn hình chính (Pop Data)
Sau khi bấm chán chê và ra quyết định gửi, người dùng bấm nút **"Gửi đánh giá"**.
```dart
ElevatedButton(
  onPressed: () {
    Navigator.pop(context, selectedRating);
  },
  // ...
)
```
Lệnh `Navigator.pop` có ý nghĩa là: Hãy tắt/đóng cái Bottom Sheet này đi, đồng thời **mang theo gói hàng** `selectedRating` giao lại cho ai đã mở nó ra (chính là màn hình Detail). Màn hình Detail nhận được cục hàng này (ví dụ số `4`), bèn lấy nó đem gộp với Token và gửi lên Backend API.

## 6. Mối liên hệ giữa các file (Xử lý ở đâu, Gọi ở đâu?)

Để toàn bộ luồng đánh giá hoạt động trơn tru, chúng ta chia công việc ra làm 2 file chính:

**1. File xử lý UI Ngôi sao (Nơi chứa đoạn code giải thích ở trên)**
- **Đường dẫn:** `lib/features/discover/widgets/rating_bottom_sheet.dart`
- **Nhiệm vụ:** Chỉ chịu trách nhiệm vẽ ra 5 ngôi sao, xử lý logic đổi màu khi bấm, và trả về một con số (`1` đến `5`). File này hoàn toàn **không** biết gì về việc gửi API hay Token cả. Cách viết này gọi là *Dumb Component* (Component ngu), giúp nó rất nhẹ và có thể đem đi tái sử dụng ở bất kỳ đâu.

**2. File gọi hiển thị và nhận kết quả**
- **Đường dẫn:** `lib/features/discover/views/room_type_detail_screen.dart`
- **Nhiệm vụ:** Nơi chứa nút "Đánh giá". Khi người dùng bấm nút, nó sẽ gọi lệnh `showModalBottomSheet(builder: (context) => const RatingBottomSheet())` để lôi cái khung chọn sao ở file (1) hiện lên. Sau khi file (1) chọn xong và đóng lại qua lệnh `Navigator.pop`, file này sẽ nhận được con số đó, tự động hiển thị màn hình Loading vòng xoay, rồi gọi hàm API gửi lên Backend thông qua `DiscoverController`.

---

## 7. Luồng dữ liệu (Data Flow) gửi/nhận Đánh giá & Vai trò của Token/UserState

Nhiều người sẽ thắc mắc: *"Vậy UserState chứa thông tin người dùng được sử dụng ở đâu trong quá trình này?"* Câu trả lời là: **Hoàn toàn không sử dụng UserState**.

### A. Quá trình GỬI đánh giá (Gửi Token ngầm)
Luồng đi: `Màn hình Detail` ➔ `DiscoverController` ➔ `DiscoverService` ➔ `ApiClient` ➔ `Backend`.

Sự kỳ diệu nằm ở **`ApiClient`** (`lib/core/network/api_client.dart`):
1. Ở `DiscoverService`, ta gọi `ApiClient.post(..., requireAuth: true)`.
2. Khi `ApiClient` thấy cờ `requireAuth: true`, nó tự động chạy thẳng xuống bộ nhớ thiết bị (ổ cứng) thông qua `TokenStorage.getAccessToken()`.
3. Nó bới lấy cái Token đang được lưu trữ, kẹp vào header `Authorization: Bearer <token>` rồi bắn lên Backend.
👉 **Kết luận:** Quá trình bảo mật này diễn ra ở tầng mạng (Network layer) cực thấp. Giao diện (UI) và `UserState` không cần phải biết hay tốn công moi móc Token truyền vào API. `UserState` chỉ làm nhiệm vụ hiển thị Tên, Avatar của người dùng trên giao diện mà thôi.

### B. Quá trình LẤY dữ liệu sao (Hiển thị thẻ phòng)
Luồng đi: `Màn hình DiscoverScreen` ➔ `DiscoverController.fetchRoomTypes` ➔ `DiscoverService.getAllRoomTypes` ➔ `Backend`.

1. Khác với lúc gửi, việc Tải danh sách phòng là thao tác **công khai** (ai vào app cũng xem được phòng mà không cần đăng nhập).
2. Do đó, API gọi lên Backend thông qua `ApiClient.get(..., requireAuth: false)`.
3. Backend trả về một mảng JSON các loại phòng, trong đó có sẵn 2 trường `average_rating` và `total_reviews`.
4. Model `RoomTypeModel` hứng 2 biến này, Controller bọc chúng lại thành danh sách, rồi ném lên cho giao diện (`RoomCard`) vẽ ra sao vàng lấp lánh.

