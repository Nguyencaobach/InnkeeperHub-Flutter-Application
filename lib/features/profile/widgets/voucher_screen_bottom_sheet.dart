import 'package:flutter/material.dart';

class VoucherScreenBottomSheet extends StatelessWidget {
  const VoucherScreenBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dummyVouchers = List.generate(3, (index) => 'Giảm 10% cho tháng đầu');

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.6,
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
            'Kho Voucher của bạn',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: dummyVouchers.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.local_offer, color: Colors.orange, size: 40),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dummyVouchers[index],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              const Text('HSD: 30/11/2023', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Dùng ngay'),
                        )
                      ],
                    ),
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