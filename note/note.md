lib/
├── core/                        # Nhóm các thành phần DÙNG CHUNG cho toàn hệ thống
│   ├── constants/               
│   │   └── api_endpoints.dart   # Nơi chứa TẤT CẢ các đường dẫn URL API
│   ├── theme/                   
│   │   ├── app_colors.dart      # Khai báo tên màu (VD: AppColors.primaryBlue)
│   │   ├── app_text_styles.dart # Khai báo font, kích thước chữ chung
│   │   └── app_theme.dart       # Nơi tổng hợp màu, chữ, hiệu ứng vào ThemeData
│   ├── network/                 # Cấu hình bắt lỗi mạng, interceptors (Dio/HTTP)
│   └── utils/                   # Các hàm tiện ích dùng chung (format ngày tháng, tiền tệ)
│
├── features/                    # Nhóm các CHỨC NĂNG của ứng dụng
│   ├── auth/                    # --- CHỨC NĂNG ĐĂNG NHẬP ---
│   │   ├── models/              # Model nhận dữ liệu user/token trả về
│   │   ├── views/               # Giao diện (LoginScreen, RegisterScreen)
│   │   ├── controllers/         # Nơi xử lý logic (để tách biệt với views)
│   │   └── services/            # File chứa các hàm gọi API riêng cho việc Auth
│   │
│   ├── home/                    # --- CHỨC NĂNG TRANG CHỦ ---
│   │   ├── models/              
│   │   ├── views/               # Giao diện HomeScreen
│   │   ├── controllers/         
│   │   └── widgets/             # Các UI nhỏ chỉ dùng riêng cho màn Home
│   │
│   └── shared/                  # Nếu có các chức năng phụ khác...
│
├── shared_widgets/              # Các nút bấm, input, dialog tự chế dùng chung cho nhiều chức năng
|
|── state
│
└── main.dart                    # Điểm khởi chạy ứng dụng, cấu hình Theme và Route ở đây

# Cách hoạt động của luồng dữ liệu:

1. Người dùng bấm nút trên màn hình (views/).

2. Màn hình gọi hàm xử lý trong (controllers/).

3. Controller gọi (services/) để lấy URL từ (api_endpoints.dart) và kết nối với máy chủ.

4. Máy chủ trả dữ liệu về, dữ liệu được chuyển thành object qua (models/).

5. Controller cập nhật lại trạng thái để màn hình (views/) hiển thị cho người dùng.

# Nguyên tắc chung khi thêm thư mục vào Feature

1. Views & Controllers: Đây là 2 thư mục gần như luôn phải có trong một chức năng để đảm bảo tính tách biệt giữa Giao diện và Xử lý logic.

2. Models: Chỉ tạo khi chức năng đó có cấu trúc dữ liệu trả về từ máy chủ cần phải được đóng gói thành Object. (Ví dụ: Chức năng "Cài đặt" chỉ có bật/tắt âm thanh lưu ngay trên máy thì đôi khi không cần Model).

3. Services: Chỉ tạo khi chức năng đó cần thực hiện các lệnh gọi API cụ thể xuống backend.

4. Widgets: Chỉ tạo khi file View của chức năng đó bắt đầu quá dài (thường vượt quá 200-300 dòng code) và bạn cần cắt nhỏ các khối giao diện cục bộ ra để dễ đọc, dễ bảo trì.

=====================================================
1. flutter pub add http



# Dưới đây là 5 bước của quy trình vận hành:

- Bước 1: Khách hàng order (Từ Giao diện - UI)
Người dùng gõ "admin" vào ô tài khoản, gõ "123456" vào ô mật khẩu trên màn hình login_screen.dart. Khi người dùng bấm nút Đăng nhập, nút này gọi hàm _authController.login(...) và truyền 2 dòng chữ kia cho Controller.

- Bước 2: Quản lý kiểm tra vé xe (Controller Validate)
auth_controller.dart nhận được dữ liệu. Trước khi làm gì tốn sức, nó tự kiểm tra nhanh: "Khách có để trống ô nào không?". 
    Nếu trống: Nó từ chối ngay, hiện bảng màu đỏ "Vui lòng nhập đầy đủ thông tin" và dừng lại luôn, không làm phiền nhà bếp.

    Nếu đầy đủ: Nó lôi cái bảng "Vui lòng đợi..." ra đặt lên bàn khách (bằng lệnh _setLoading(true) làm cái nút xoay vòng vòng).

- Bước 3: Giao việc cho Nhà bếp / Shipper (Gọi Service)
Controller mang gói hàng (username, password) chạy xuống đưa cho lớp auth_service.dart bằng lệnh AuthService.login(...). Nhiệm vụ duy nhất của auth_service.dart là làm shipper. Nó đóng gói dữ liệu thành chuẩn mạng (JSON), gắn địa chỉ giao hàng (ApiEndpoints.login) và dùng xe chở hàng (ApiClient.post) phóng thẳng lên Server (Backend của bạn).

- Bước 4: Server phản hồi và Shipper mang hàng về (Xử lý Response)
Server kiểm tra trong Database xem tài khoản có đúng không, rồi gửi trả lại một bưu kiện. Shipper auth_service.dart nhận bưu kiện đó. Nhỡ Server gửi về một đống lộn xộn, Shipper sẽ dùng hàm _parseResponse để bóc tách, sắp xếp lại gọn gàng thành một cái Hộp (Map) chứa 2 ngăn: Mã trạng thái (statusCode) và Lời nhắn (message). Shipper đưa lại cái Hộp này cho Quản lý (AuthController).

- Bước 5: Quản lý báo cáo khách hàng (Cập nhật UI)
Quản lý (AuthController) cầm cái hộp trên tay. Việc đầu tiên là cất cái bảng "Vui lòng đợi..." đi bằng lệnh _setLoading(false) (nút ngừng xoay và hiện lại chữ Đăng nhập). Tiếp theo, nó mở hộp ra xem Mã trạng thái là bao nhiêu:

    Nếu là 200 (Thành công): Mỉm cười, hiện bảng màu xanh "Đăng nhập thành công". (Sau này bạn sẽ code thêm lệnh mở cửa cho khách vào app ở bước này).

    Nếu là Lỗi (400, 401, 500...): Hiện bảng màu đỏ, đọc đúng cái lời nhắn mà Server gửi về (ví dụ: "Sai mật khẩu" hoặc "Tài khoản không tồn tại").

Tóm lại luồng đi của dữ liệu là:
Màn hình ➔ Controller ➔ Service ➔ [SERVER/INTERNET] ➔ Service ➔ Controller ➔ Màn hình.