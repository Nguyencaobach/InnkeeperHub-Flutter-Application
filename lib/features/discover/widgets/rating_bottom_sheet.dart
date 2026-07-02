import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class RatingBottomSheet extends StatefulWidget {
  const RatingBottomSheet({super.key});

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  int selectedRating = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Đánh giá loại phòng này',
            style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final ratingValue = index + 1;
              final isSelected = ratingValue <= selectedRating;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRating = ratingValue;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    isSelected ? Icons.star : Icons.star_border,
                    color: isSelected ? Colors.orangeAccent : Colors.grey[400],
                    size: 40,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedRating);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: AppColors.buttonBlue,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text(
                'Gửi đánh giá',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
