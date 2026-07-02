class HistoryModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final double amount;
  final String status;

  HistoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.amount,
    required this.status,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
    );
  }
}