# Cách hệ thống tải ảnh hoạt động (Multipart/form-data)

**Trên Flutter (App):**
Trong file `profile_service.dart`, chúng ta dùng `http.MultipartRequest` và `http.MultipartFile.fromPath()`. Chức năng này không đọc ảnh thành chữ, mà nó mở một "ống nước" (stream) và bơm trực tiếp các hạt nhị phân (binary bytes) của bức ảnh qua mạng internet.

**Trên Backend (Node.js):**
File `upload.middleware.js` của bạn đang sử dụng thư viện `multer`. Multer sinh ra chính là để "hứng" cái ống nước binary này, và ghi thẳng dòng chảy đó xuống ổ cứng máy chủ thành file `.jpg` hoặc `.png` mà không cần quan tâm đến dữ liệu text.
