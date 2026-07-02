import 'package:flutter/material.dart';

class HistoryScreenBottomSheet extends StatelessWidget {
  const HistoryScreenBottomSheet({super.key}); // Đã sửa cú pháp super parameter

  @override
  Widget build(BuildContext context) {
    // Demo data - Sẽ thay bằng dữ liệu từ ProfileController thông qua Provider
    final dummyHistory = List.generate(5, (index) => 'Giao dịch phòng #10$index');

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.7,
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
            'Lịch sử giao dịch',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: dummyHistory.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.history, color: Colors.white),
                  ),
                  title: Text(dummyHistory[index]),
                  subtitle: const Text('Đã hoàn thành - 12/10/2023'),
                  trailing: const Text(
                    '- 500.000đ',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}