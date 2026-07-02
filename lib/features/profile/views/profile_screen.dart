import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/api_endpoints.dart';
import '../controllers/profile_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../state/user_state.dart';

<<<<<<< HEAD
import '../widgets/history_screen_bottom_sheet.dart';
import '../widgets/information_and_terms_bottom_sheet.dart';
import '../widgets/voucher_screen_bottom_sheet.dart';
import '../widgets/detailed_information_bottom_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showDetailedInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const DetailedInformationBottomSheet(),
    );
  }

  void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const HistoryScreenBottomSheet(),
    );
  }

  void _showVoucher(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const VoucherScreenBottomSheet(),
    );
  }

  void _showTerms(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const InformationAndTermsBottomSheet(),
    );
  }

=======
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
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
<<<<<<< HEAD
      body: SafeArea(
=======
      // Đã xoá AppBar để đẩy giao diện lên trên cùng
      body: SafeArea( // Thêm SafeArea để phần trên không bị lẹm vào thanh trạng thái (pin, wifi)
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
<<<<<<< HEAD
=======
              // Vùng 1: Thông tin người dùng
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
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
<<<<<<< HEAD
                    Consumer<ProfileController>(
                      builder: (context, profileCtrl, child) {
                        String getFullImageUrl(String path) {
                          if (path.isEmpty) return '';
                          if (path.startsWith('http')) return path;
                          final domain = ApiEndpoints.baseUrl.replaceAll('/api', '');
                          return '$domain$path';
=======
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
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
                        }

                        return GestureDetector(
                          onTap: () async {
<<<<<<< HEAD
=======
                            // Gọi ImagePicker mở thư viện ảnh
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                            
                            if (image != null && context.mounted) {
<<<<<<< HEAD
=======
                              // Gửi đường dẫn ảnh vào Controller để xử lý upload
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
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
<<<<<<< HEAD
                                ? const CircularProgressIndicator(color: AppColors.buttonBlue) 
=======
                                // Đang tải ảnh thì hiện vòng xoay
                                ? const CircularProgressIndicator(color: AppColors.buttonBlue) 
                                // Không có ảnh thì hiện icon mặc định
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
                                : (user.avatarUrl.isEmpty 
                                    ? Icon(Icons.person, size: 45, color: Colors.grey[400]) 
                                    : null),
                          ),
                        );
                      }
                    ),
                    const SizedBox(width: 20),
<<<<<<< HEAD
=======
                    // Thông tin tên và nút chỉnh sửa bên phải
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
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
<<<<<<< HEAD
=======
              // Vùng 2: Các chức năng
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
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
<<<<<<< HEAD
                    _buildMenuItem(Icons.info_outline, 'Thông tin chi tiết', () => _showDetailedInfo(context)),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(Icons.bookmark_border, 'Đã lưu', () {}),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(Icons.history, 'Lịch sử', () => _showHistory(context)),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(Icons.local_offer_outlined, 'Voucher của tôi', () => _showVoucher(context)),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(Icons.settings_outlined, 'Cài đặt', () {}),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(Icons.description_outlined, 'Thông tin và điều khoản', () => _showTerms(context)),
=======
                    _buildMenuItem(Icons.info_outline, 'Thông tin chi tiết', () {}),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(Icons.bookmark_border, 'Đã lưu', () {}),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(Icons.history, 'Lịch sử', () {}),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(Icons.local_offer_outlined, 'Voucher của tôi', () {}),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(Icons.settings_outlined, 'Cài đặt', () {}),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(Icons.description_outlined, 'Thông tin và điều khoản', () {}),
>>>>>>> b04b91ac5c0e2244891045922e1748782cb60a6d
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