import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/discover_controller.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _priceType;
  late double _minPrice;
  late double _maxPrice;
  late int _minCapacity;
  late int _maxCapacity;

  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  void initState() {
    super.initState();
    final controller = context.read<DiscoverController>();
    _priceType = controller.priceType;
    _minPrice = controller.minPrice;
    _maxPrice = controller.maxPrice;
    _minCapacity = controller.minCapacity;
    _maxCapacity = controller.maxCapacity;
  }

  void _applyFilters() {
    context.read<DiscoverController>().setFilters(
      priceType: _priceType,
      minPrice: 100000, // Cố định
      maxPrice: _maxPrice,
      minCapacity: 1, // Cố định
      maxCapacity: _maxCapacity,
    );
    Navigator.pop(context);
  }

  void _clearFilters() {
    context.read<DiscoverController>().clearFilters();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bộ lọc', style: AppTextStyles.titleLarge),
                Row(
                  children: [
                    TextButton(
                      onPressed: _clearFilters,
                      child: const Text('Xóa bộ lọc', style: TextStyle(color: Colors.red)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMain),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Loại Giá (Price Type)
            const Text('Loại giá', style: AppTextStyles.inputLabel),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _priceType = 'hourly'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _priceType == 'hourly' ? AppColors.buttonBlue : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _priceType == 'hourly' ? AppColors.buttonBlue : Colors.transparent,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Theo giờ',
                        style: TextStyle(
                          color: _priceType == 'hourly' ? Colors.white : AppColors.textMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _priceType = 'daily'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _priceType == 'daily' ? AppColors.buttonBlue : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _priceType == 'daily' ? AppColors.buttonBlue : Colors.transparent,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Theo ngày',
                        style: TextStyle(
                          color: _priceType == 'daily' ? Colors.white : AppColors.textMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Giá Tiền (Price Range) - Single Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Chọn mức giá', style: AppTextStyles.inputLabel),
                Text(
                  _currencyFormat.format(_maxPrice),
                  style: const TextStyle(
                    color: AppColors.buttonBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: _maxPrice,
              min: 100000,
              max: 10000000,
              divisions: 99, // Mỗi bước nhảy là 100k
              activeColor: AppColors.buttonBlue,
              inactiveColor: Colors.grey[200],
              label: _currencyFormat.format(_maxPrice),
              onChanged: (double value) {
                setState(() {
                  _maxPrice = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Số lượng người (Capacity) - Single Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Chọn số lượng người', style: AppTextStyles.inputLabel),
                Text(
                  '$_maxCapacity người',
                  style: const TextStyle(
                    color: AppColors.buttonBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: _maxCapacity.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              activeColor: AppColors.buttonBlue,
              inactiveColor: Colors.grey[200],
              label: '$_maxCapacity',
              onChanged: (double value) {
                setState(() {
                  _maxCapacity = value.round();
                });
              },
            ),
            const SizedBox(height: 32),

            // Nút Áp dụng
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text('Áp dụng', style: AppTextStyles.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
