import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/user_state.dart';
import '../controllers/profile_controller.dart';

class DetailedInformationBottomSheet extends StatefulWidget {
  const DetailedInformationBottomSheet({super.key});

  @override
  State<DetailedInformationBottomSheet> createState() => _DetailedInformationBottomSheetState();
}

class _DetailedInformationBottomSheetState extends State<DetailedInformationBottomSheet> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  // Controllers cho thông tin cá nhân
  late TextEditingController _usernameController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  // Controllers cho đổi mật khẩu
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // Lấy thông tin hiện tại từ UserState để hiển thị sẵn lên các ô nhập
    final user = context.read<UserState>();
    _usernameController = TextEditingController(text: user.username);
    _nameController = TextEditingController(text: user.fullName);
    _emailController = TextEditingController(text: user.email); 
    _phoneController = TextEditingController(text: user.phoneNumber); 
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Xử lý lưu thông tin cá nhân
  void _submitProfile() {
    if (_profileFormKey.currentState!.validate()) {
      context.read<ProfileController>().updateProfile(
        context,
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );
    }
  }

  // Xử lý đổi mật khẩu
  void _submitChangePassword() {
    if (_passwordFormKey.currentState!.validate()) {
      context.read<ProfileController>().changePassword(
        context,
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        newPassword: _newPasswordController.text,
      );
    }
  }

  Widget _buildLabeledField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileCtrl = context.watch<ProfileController>();

    return Padding(
      // Thuộc tính bọc lấy vùng đệm bàn phím khi người dùng gõ chữ không bị che mất nút bấm
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: AppColors.mainBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thanh gạch nhỏ định vị kéo vuốt trên đầu BottomSheet
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
            const SizedBox(height: 20),
            const Text(
              'Thông tin tài khoản',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Phần nội dung cuộn được bên trong
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // --- FORM CHỈNH SỬA THÔNG TIN CÁ NHÂN ---
                    Form(
                      key: _profileFormKey,
                      child: Column(
                        children: [
                          _buildLabeledField(
                            'Tên đăng nhập',
                            TextFormField(
                              controller: _usernameController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                hintText: 'Tên đăng nhập',
                                prefixIcon: Icon(Icons.account_circle_outlined),
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Color(0xFFF5F5F5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledField(
                            'Họ và tên',
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: 'Nhập họ và tên',
                                prefixIcon: Icon(Icons.person_outline),
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) => (val == null || val.trim().isEmpty) ? 'Vui lòng nhập họ tên' : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledField(
                            'Địa chỉ email',
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Nhập địa chỉ email',
                                prefixIcon: Icon(Icons.email_outlined),
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return 'Vui lòng nhập email';
                                if (!val.contains('@')) return 'Email không hợp lệ';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledField(
                            'Số điện thoại',
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                hintText: 'Nhập số điện thoại',
                                prefixIcon: Icon(Icons.phone_outlined),
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return 'Vui lòng nhập số điện thoại';
                                if (val.length < 10) return 'Số điện thoại không hợp lệ';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonBlue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: profileCtrl.isUploadingAvatar ? null : _submitProfile, // Giả định dùng chung trạng thái loading hoặc tạo biến mới
                              child: const Text('Cập nhật thông tin', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(),
                    ),

                    // --- KHU VỰC ĐỔI MẬT KHẨU (GỌN GÀNG TRONG EXPANSION TILE) ---
                    Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: const Text('Thay đổi mật khẩu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        childrenPadding: const EdgeInsets.only(top: 10),
                        children: [
                          Form(
                            key: _passwordFormKey,
                            child: Column(
                              children: [
                                _buildLabeledField(
                                  'Mật khẩu mới',
                                  TextFormField(
                                    controller: _newPasswordController,
                                    obscureText: _obscureNewPassword,
                                    decoration: InputDecoration(
                                      hintText: 'Nhập mật khẩu mới',
                                      prefixIcon: const Icon(Icons.vpn_key_outlined),
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: Icon(_obscureNewPassword ? Icons.visibility_off : Icons.visibility),
                                        onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val != null && val.isNotEmpty && val.length < 6) {
                                        return 'Mật khẩu phải từ 6 ký tự trở lên';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildLabeledField(
                                  'Xác nhận mật khẩu mới',
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: _obscureConfirmPassword,
                                    decoration: InputDecoration(
                                      hintText: 'Nhập lại mật khẩu mới',
                                      prefixIcon: const Icon(Icons.check_circle_outline),
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                      ),
                                    ),
                                    validator: (val) {
                                      if (_newPasswordController.text.isNotEmpty && val != _newPasswordController.text) {
                                        return 'Mật khẩu xác nhận không trùng khớp';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.buttonBlue,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: _submitChangePassword,
                                    child: const Text('Cập nhật mật khẩu', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}