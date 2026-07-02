class VoucherModel {
  final String id;
  final String code;
  final String title;
  final double discountPercent;
  final DateTime expiryDate;
  final bool isUsed;

  VoucherModel({
    required this.id,
    required this.code,
    required this.title,
    required this.discountPercent,
    required this.expiryDate,
    this.isUsed = false,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      discountPercent: (json['discountPercent'] ?? 0).toDouble(),
      expiryDate: DateTime.parse(json['expiryDate']),
      isUsed: json['isUsed'] ?? false,
    );
  }
}