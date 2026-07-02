import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/api_endpoints.dart';
import '../controllers/profile_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../state/user_state.dart';
import '../widgets/detailed_information_bottom_sheet.dart';
import '../widgets/information_and_terms_bottom_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {Color? textColor, Color? iconColor}) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.black),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColors.textMain,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserState>();

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      // Đã xoá AppBar để đẩy giao diện lên trên cùng
      body: SafeArea( // Thêm SafeArea để phần trên không bị lẹm vào thanh trạng thái (pin, wifi)
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Vùng 1: Thông tin người dùng
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    // Hình Avatar bấm vào để cập nhật
                    Consumer<ProfileController>(
                      builder: (context, profileCtrl, child) {
                        // Hàm xử lý link ảnh (Nối domain nếu là link tương đối /uploads/...)
                        String getFullImageUrl(String path) {
                          if (path.isEmpty) return '';
                          
                          // Đổi dấu \ thành / (đề phòng backend lưu đường dẫn kiểu Windows)
                          String normalizedPath = path.replaceAll('\\', '/');
                          
                          if (normalizedPath.startsWith('http')) return normalizedPath;
                          
                          final domain = ApiEndpoints.baseUrl.replaceAll('/api', '');
                          
                          // Đảm bảo có dấu / ở đầu trước khi nối với domain
                          if (!normalizedPath.startsWith('/')) {
                            normalizedPath = '/$normalizedPath';
                          }
                          
                          return '$domain$normalizedPath';
                        }

                        return GestureDetector(
                          onTap: () async {
                            // Gọi ImagePicker mở thư viện ảnh
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                            
                            if (image != null && context.mounted) {
                              // Gửi đường dẫn ảnh vào Controller để xử lý upload
                              context.read<ProfileController>().uploadAvatar(context, image.path);
                            }
                          },
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: user.avatarUrl.isNotEmpty 
                                ? NetworkImage(getFullImageUrl(user.avatarUrl)) 
                                : null,
                            child: profileCtrl.isUploadingAvatar
                                // Đang tải ảnh thì hiện vòng xoay
                                ? const CircularProgressIndicator(color: AppColors.buttonBlue) 
                                // Không có ảnh thì hiện icon mặc định
                                : (user.avatarUrl.isEmpty 
                                    ? Icon(Icons.person, size: 45, color: Colors.grey[400]) 
                                    : null),
                          ),
                        );
                      }
                    ),
                    const SizedBox(width: 20),
                    // Thông tin tên và nút chỉnh sửa bên phải
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName.isNotEmpty ? user.fullName : (user.username.isNotEmpty ? user.username : 'Người dùng'),
                            style: AppTextStyles.titleLarge.copyWith(fontSize: 22),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Vùng 2: Các chức năng
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuItem(Icons.info_outline, 'Thông tin chi tiết', () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const DetailedInformationBottomSheet(),
                      );
                    }),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(Icons.bookmark_border, 'Đã lưu', () {}),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(Icons.history, 'Lịch sử', () {}),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(Icons.local_offer_outlined, 'Voucher của tôi', () {}),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(Icons.description_outlined, 'Thông tin và điều khoản', () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const InformationAndTermsBottomSheet(),
                      );
                    }),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(
                      Icons.logout,
                      'Đăng xuất',
                      () async {
                        await context.read<UserState>().logout();
                        if (!context.mounted) return;
                        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                      },
                      textColor: Colors.redAccent,
                      iconColor: Colors.redAccent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}