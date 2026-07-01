# Cơ chế hoạt động của Tính năng Tìm kiếm & Bộ lọc (Search & Filter)

Tài liệu này giải thích cách hoạt động bên trong của tính năng Tìm kiếm (Search) và Bộ lọc (Filter) trong màn hình Khám phá (Discover Screen) của ứng dụng, cũng như cách thức thanh trượt (Slider) được cấu hình và quản lý trạng thái.

---

## 1. Cơ cấu Lọc và Tìm kiếm (Logic trong `DiscoverController`)

Toàn bộ logic xử lý dữ liệu được đặt trong file `discover_controller.dart`. Khái niệm cốt lõi ở đây là: **Lấy tất cả dữ liệu gốc một lần, sau đó chỉ thao tác lọc trên danh sách ảo**.

### a. Lưu trữ dữ liệu gốc
Khi gọi API (`fetchRoomTypes`), danh sách toàn bộ phòng được lưu vào biến `_allRoomTypes`. Biến này đóng vai trò là "Kho chứa gốc" không bao giờ bị thay đổi bởi thao tác lọc. 
Những gì hiển thị trên màn hình được lấy từ biến `_roomTypes` (danh sách đã lọc).

### b. Flag `_isFilterApplied` (Cờ trạng thái Bộ lọc)
Để tránh việc khi vừa vào màn hình, các giá trị mặc định của thanh kéo (giá max 100k, số người max 1) vô tình ẩn đi các phòng có giá trị cao hơn, tôi sử dụng một biến boolean `_isFilterApplied = false;`.
- Khi người dùng **chỉ gõ tìm kiếm chữ**: Khớp tên phòng với chuỗi tìm kiếm (Search Query). Nó bỏ qua hoàn toàn việc kiểm tra mức giá hay số lượng người.
- Khi người dùng **bấm nút Áp dụng trên Bottom Sheet**: Hàm `setFilters` sẽ đổi cờ `_isFilterApplied = true`. Lúc này hệ thống mới bắt đầu nghiêm ngặt đối chiếu giá và sức chứa.

### c. Sự kết hợp các điều kiện (AND Logic)
Trong hàm `_applyFiltersInternal()`, mỗi phòng (room) sẽ trải qua một bài kiểm tra 3 bước:
1. **Lọc tên:** Tên phòng có chứa chữ mà người dùng nhập vào ô tìm kiếm không?
2. **Lọc giá:** Mức giá (theo ngày hoặc theo giờ) có nằm trong khoảng từ `100,000` đến `_maxPrice` không?
3. **Lọc sức chứa:** Số lượng người có nằm trong khoảng từ `1` đến `_maxCapacity` không?

Một phòng chỉ được hiển thị (được giữ lại trong `_roomTypes`) khi thoả mãn **tất cả** các bài kiểm tra trên (`return matchName && matchPrice && matchCapacity;`).

---

## 2. Cơ cấu hoạt động của Thanh Trượt (Slider)

Thanh trượt trên Bottom Sheet (`FilterBottomSheet`) được tạo ra bằng Widget `Slider` có sẵn của Flutter. Để biến nó từ một thanh trượt bình thường thành một thanh trượt hoạt động chính xác với yêu cầu (cố định min, chỉ kéo max), cơ chế như sau:

### a. Quản lý trạng thái nội bộ (Local State)
`FilterBottomSheet` là một `StatefulWidget`. Khi nó vừa được mở lên, hàm `initState` sẽ copy các giá trị hiện tại từ `DiscoverController` (ví dụ `_maxPrice = 100,000`) vào trong State nội bộ của Bottom Sheet.
Điều này giúp việc kéo Slider chỉ làm thay đổi giao diện mượt mà bên trong Bottom Sheet mà chưa tác động ngay ra ngoài danh sách phòng (cho đến khi bấm Áp dụng).

### b. Các thuộc tính của Widget `Slider`
Một thanh Slider xử lý giá tiền được thiết lập như sau:
```dart
Slider(
  value: _maxPrice,       // Vị trí hiện tại của "cục tròn" trên thanh trượt
  min: 100000,            // Điểm bắt đầu (cố định bên trái)
  max: 10000000,          // Điểm kết thúc (cố định bên phải)
  divisions: 99,          // Chia thanh trượt thành 99 nấc (mỗi nấc 100k)
  label: _currencyFormat.format(_maxPrice), // Chữ nổi lên khi đang giữ tay kéo
  onChanged: (double value) {
    // Sự kiện xảy ra liên tục khi tay đang kéo trượt
    setState(() {
      _maxPrice = value;  // Cập nhật vị trí cục tròn theo ngón tay
    });
  },
)
```

**Tại sao lúc mới vào nó nằm ở mốc thấp nhất?**
Do trong Controller, giá trị gốc được set là `_maxPrice = 100000` và `_maxCapacity = 1`. 
Khi Widget `Slider` vẽ lên, thuộc tính `value` của nó (nhận 100k) đang bằng chính xác với thuộc tính `min` (cũng là 100k). Vì vậy, mặc định "cục tròn" sẽ nằm sát về bên trái.

### c. Cập nhật dữ liệu (Nút Áp dụng)
Khi bấm nút "Áp dụng", các con số cuối cùng của thanh trượt sẽ được gửi ngược lại `DiscoverController` thông qua hàm `setFilters`. Controller sẽ bật cờ `_isFilterApplied = true` và bắt đầu lọc lại dữ liệu gốc `_allRoomTypes` dựa trên những con số giới hạn tối đa này. 
Đồng thời, hàm `clearFilters` (khi load lại trang hoặc bấm "Xóa bộ lọc") sẽ chỉ đơn giản là đổi mọi thứ về vị trí xuất phát (`_maxPrice = 100k`, cờ `= false`) và lọc lại danh sách.
