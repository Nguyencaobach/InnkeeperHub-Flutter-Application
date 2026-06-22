import 'package:flutter/material.dart';

/* Trong việc sử dụng widget riêng lẻ ngoài app_theme thì sẽ sử dụng cơ chế là 
  Kế thừa và Ghi đè (Inheritance & Override), những định dạng nào mới thì nó sẽ ghi đè
  lên chức năng còn không thì nó sẽ kế thừa lại những gì được định nghĩa ở app_theme
*/

class CustomButton extends StatelessWidget { // Widget phụ thuộc vào state được truyền vào
  final String text;
  final VoidCallback? onPressed; // Hành động xảy ra khi người dùng bấm vào nút (nullable để hỗ trợ disable)
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false, // Công tác true/false khi ấn vào nút có vòng tròn loading hiện lên
  });

  @override
  Widget build(BuildContext context) {
    return Container( // Sử dụng một contain để bao bọc cái nút để sử dụng màu gradien vì ElevatedButton mặc định không hỗ trợ màu Gradient
      width: double.infinity, // Chiều rộng hết cỡ màn hình
      height: 52, // Chiều cao của nút
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // Độ bo góc bằng với các ô nhập liệu
        // Cấu hình dải màu Gradient từ ảnh của bạn
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2DD4BF), // Màu xanh ngọc (bên trái)
            Color(0xFF5A67D8), // Màu xanh tím (bên phải)
          ],
          begin: Alignment.centerLeft, // Quy định chuyển hướng màu trong thuộc tính gradient
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton( // Lõi nút bấm được đặt là child của Container
        onPressed: (isLoading || onPressed == null) ? null : onPressed, // Nếu đang load hoặc onPressed null thì vô hiệu hóa nút
        style: ElevatedButton.styleFrom(
          // Làm trong suốt nền và bóng để lộ màu gradient của Container phía dưới
          backgroundColor: Colors.transparent, 
          shadowColor: Colors.transparent,     
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading // Định nghĩa cho loading khi bấm nút
            ? const SizedBox( // Nếu đúng thì xoay loading với định dạng SizedBox
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text( // Nếu sai thì hiện thị với định dạng text
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}