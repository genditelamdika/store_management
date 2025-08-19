class Report {
  final int storeId;
  final int productId;
  String status; // pending / synced
  final DateTime timestamp;

  Report({required this.storeId, required this.productId, this.status = 'pending', required this.timestamp});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      storeId: json['storeId'],
      productId: json['productId'],
      status: json['status'] ?? 'pending',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'productId': productId,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
