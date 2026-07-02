import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class InformationAndTermsBottomSheet extends StatelessWidget {
  const InformationAndTermsBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.mainBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Thông tin & Điều khoản',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: SingleChildScrollView(
              child: Text(
                '''1. Giới thiệu chung
Chào mừng bạn đến với Innkeeper Hub. Ứng dụng giúp bạn quản lý và tìm kiếm phòng trọ dễ dàng.

2. Quyền và nghĩa vụ
Người dùng cần cung cấp thông tin chính xác khi đặt phòng và thanh toán đúng hạn.

3. Chính sách bảo mật
Chúng tôi cam kết bảo mật thông tin cá nhân của bạn và không chia sẻ cho bên thứ ba khi chưa có sự đồng ý.

4. Giải quyết tranh chấp
Mọi tranh chấp sẽ được ưu tiên giải quyết thông qua thương lượng giữa các bên.''',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}