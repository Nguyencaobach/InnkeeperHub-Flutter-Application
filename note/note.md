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