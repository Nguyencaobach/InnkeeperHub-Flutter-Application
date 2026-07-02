// lib/features/discover/widgets/skeleton_room_detail_card.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonRoomDetailCard extends StatelessWidget {
  const SkeletonRoomDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(width: 48, height: 48, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                const SizedBox(width: 16),
                Container(width: 100, height: 20, color: Colors.white),
              ],
            ),
            Container(width: 80, height: 28, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
          ],
        ),
      ),
    );
  }
}