class SaleManModel {
  final String id;
  final String employeeName;
  final double preBalance;

  SaleManModel({
    required this.id,
    required this.employeeName,
    required this.preBalance,
  });

  factory SaleManModel.fromJson(Map<String, dynamic> json) {
    return SaleManModel(
      id: json['_id'] ?? '',
      employeeName: json['employeeName'] ?? '',
      preBalance: (json['preBalance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'employeeName': employeeName,
      'preBalance': preBalance,
    };
  }
}
