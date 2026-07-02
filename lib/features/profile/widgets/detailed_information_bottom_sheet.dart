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
  late TextEditingController _nameController;
  late TextEditingController _ageController;
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
    _nameController = TextEditingController(text: user.fullName);
    
    // Lưu ý: Nếu trong UserState của bạn chưa có thuộc tính age hoặc phoneNumber, 
    // hãy tạm để trống hoặc bổ sung vào class UserState của đồ án.
    _ageController = TextEditingController(text: ''); 
    _phoneController = TextEditingController(text: ''); 
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
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
        age: int.tryParse(_ageController.text.trim()) ?? 0,
        phoneNumber: _phoneController.text.trim(),
      );
    }
  }

  // Xử lý đổi mật khẩu
  void _submitChangePassword() {
    if (_passwordFormKey.currentState!.validate()) {
      context.read<ProfileController>().changePassword(
        context,
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );
    }
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
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Họ và tên',
                              prefixIcon: Icon(Icons.person_outline),
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) => (val == null || val.trim().isEmpty) ? 'Vui lòng nhập họ tên' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Tuổi',
                              prefixIcon: Icon(Icons.cake_outlined),
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return 'Vui lòng nhập tuổi';
                              if (int.tryParse(val) == null) return 'Tuổi phải là một số';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Số điện thoại',
                              prefixIcon: Icon(Icons.phone_outlined),
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return 'Vui lòng nhập số điện thoại';
                              if (val.length < 10) return 'Số điện thoại không hợp lệ';
                              return null;
                            },
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
                        leading: const Icon(Icons.lock_reset, color: Colors.amber),
                        title: const Text('Thay đổi mật khẩu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        childrenPadding: const EdgeInsets.only(top: 10),
                        children: [
                          Form(
                            key: _passwordFormKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _oldPasswordController,
                                  obscureText: _obscureOldPassword,
                                  decoration: InputDecoration(
                                    labelText: 'Mật khẩu hiện tại',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscureOldPassword ? Icons.visibility_off : Icons.visibility),
                                      onPressed: () => setState(() => _obscureOldPassword = !_obscureOldPassword),
                                    ),
                                  ),
                                  validator: (val) => (val == null || val.isEmpty) ? 'Vui lòng nhập mật khẩu cũ' : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _newPasswordController,
                                  obscureText: _obscureNewPassword,
                                  decoration: InputDecoration(
                                    labelText: 'Mật khẩu mới',
                                    prefixIcon: const Icon(Icons.vpn_key_outlined),
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscureNewPassword ? Icons.visibility_off : Icons.visibility),
                                      onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val == null || val.isEmpty) return 'Vui lòng nhập mật khẩu mới';
                                    if (val.length < 6) return 'Mật khẩu phải từ 6 ký tự trở lên';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  decoration: InputDecoration(
                                    labelText: 'Xác nhận mật khẩu mới',
                                    prefixIcon: const Icon(Icons.check_circle_outline),
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val != _newPasswordController.text) return 'Mật khẩu xác nhận không trùng khớp';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: _submitChangePassword,
                                    child: const Text('Đổi mật khẩu', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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