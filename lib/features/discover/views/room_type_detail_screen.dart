import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/room_type_model.dart';
import '../widgets/room_type_detail_skeleton.dart';
import 'package:provider/provider.dart';
import '../controllers/discover_controller.dart';
import '../widgets/rating_bottom_sheet.dart';

class RoomTypeDetailScreen extends StatefulWidget {
  final RoomTypeModel roomType;

  const RoomTypeDetailScreen({super.key, required this.roomType});

  @override
  State<RoomTypeDetailScreen> createState() => _RoomTypeDetailScreenState();
}

class _RoomTypeDetailScreenState extends State<RoomTypeDetailScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Giả lập thời gian load để hiển thị skeleton theo yêu cầu
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _submitRating(int rating) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await context.read<DiscoverController>().submitRoomTypeRating(widget.roomType.id, rating);
      if (!mounted) return;
      
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Đóng loading dialog
      }
      
      // Hiện dialog báo thành công
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Thành công!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cảm ơn bạn đã gửi đánh giá.',
                  style: TextStyle(color: AppColors.textSubtitle, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Đóng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      
      if (Navigator.canPop(context)) {
        Navigator.pop(context, true); // Đóng màn hình detail và truyền cờ true về
      }
    } catch (e) {
      if (!mounted) return;
      
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Đóng loading dialog
      }
      
      // Hiện dialog báo lỗi
      await showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Thất bại',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString().replaceAll('Exception: ', ''),
                  style: const TextStyle(color: AppColors.textSubtitle, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Đóng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.mainBackground,
        body: RoomTypeDetailSkeleton(),
      );
    }

    final room = widget.roomType;
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    
    // Xử lý link ảnh
    final String domain = ApiEndpoints.baseUrl.replaceAll('/api', '');
    final String imageUrl = room.roomImgUrl.startsWith('/') 
        ? '$domain${room.roomImgUrl}' 
        : room.roomImgUrl;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: CustomScrollView(
        slivers: [
          // Phần hình ảnh chính
          SliverAppBar(
            expandedHeight: 380.0,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hình ảnh chính của phòng
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: Image.network(
                      imageUrl.isNotEmpty 
                          ? imageUrl 
                          : 'https://via.placeholder.com/400x400',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          Container(color: Colors.grey[300]),
                    ),
                  ),
                  // Lớp phủ Gradient đen tối ở dưới để hiển thị chữ rõ hơn
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.85),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5],
                      ),
                    ),
                  ),
                  // Thông tin Tên phòng
                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: Text(
                      room.name,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Phần hiển thị chi tiết
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thẻ hiển thị Đánh giá
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          widget.roomType.totalReviews > 0 ? Icons.star : Icons.star_border,
                          color: widget.roomType.totalReviews > 0 ? Colors.orangeAccent : AppColors.textSubtitle,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        if (widget.roomType.totalReviews > 0) ...[
                          Text(
                            widget.roomType.averageRating.toStringAsFixed(1),
                            style: AppTextStyles.titleLarge.copyWith(fontSize: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${widget.roomType.totalReviews} lượt đánh giá)',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSubtitle),
                          ),
                        ] else ...[
                          Text(
                            'Chưa có đánh giá',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMain, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bảng Giá tiền
                  Text(
                    'Giá phòng',
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Theo giờ', style: AppTextStyles.bodySmall.copyWith(fontSize: 15)),
                            Text(
                              '${formatCurrency.format(room.hourlyPrice)} / giờ',
                              style: AppTextStyles.inputLabel.copyWith(fontSize: 16, color: AppColors.logoDarkBlue),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(height: 1, color: AppColors.border),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Theo ngày', style: AppTextStyles.bodySmall.copyWith(fontSize: 15)),
                            Text(
                              '${formatCurrency.format(room.dailyPrice)} / ngày',
                              style: AppTextStyles.inputLabel.copyWith(fontSize: 16, color: AppColors.logoDarkBlue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Property Details
                  Text(
                    'Thông tin chi tiết',
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailsGrid(room),
                  const SizedBox(height: 24),
                  
                  // Phần Tiện ích (Amenities)
                  if (room.amenities.isNotEmpty) ...[
                    Text(
                      'Tiện ích',
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    _buildAmenitiesList(room.amenities),
                    const SizedBox(height: 32),
                  ],

                  // 2 nút chức năng dưới cùng
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: AppColors.buttonRate,
                              foregroundColor: Colors.white,
                              elevation: 0,
                            ),
                            child: const Text('Lưu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: AppColors.buttonBlue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                            ),
                            child: const Text('Xem DS phòng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Nút Đánh giá
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      color: AppColors.buttonRate,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          final rating = await showModalBottomSheet<int>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) => const RatingBottomSheet(),
                          );
                          if (rating != null) {
                            _submitRating(rating);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              'Đánh giá',
                              style: AppTextStyles.inputLabel.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Lưới hiển thị chi tiết: 2 thông tin 1 dòng (đã bỏ Hướng nhìn)
  Widget _buildDetailsGrid(RoomTypeModel room) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildDetailItem(Icons.layers_outlined, 'Tầng', room.floor)),
            const SizedBox(width: 16),
            Expanded(child: _buildDetailItem(Icons.people_outline, 'Sức chứa', '${room.capacity} Người')),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildDetailItem(Icons.bed_outlined, 'Loại giường', room.bedType)),
            const SizedBox(width: 16),
            Expanded(child: _buildDetailItem(Icons.square_foot_outlined, 'Diện tích', '${room.roomSize} m²')),
          ],
        ),
      ],
    );
  }

  // Component cục thông tin nhỏ
  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSubtitle, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.inputLabel.copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Danh sách Tiện ích
  Widget _buildAmenitiesList(List<String> amenities) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: amenities.map((amenity) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            amenity,
            style: AppTextStyles.inputLabel.copyWith(
              color: AppColors.textMain,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        );
      }).toList(),
    );
  }
}
