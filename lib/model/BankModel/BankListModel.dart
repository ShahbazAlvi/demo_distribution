class BankListModel {
  final bool success;
  final int count;
  final List<BankData> data;

  BankListModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory BankListModel.fromJson(Map<String, dynamic> json) {
    return BankListModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>)
          .map((item) => BankData.fromJson(item))
          .toList(),
    );
  }
}
class BankData {
  final String id;
  final String bankName;
  final String accountHolderName;
  final String accountNumber;
  final int balance;
  final String createdAt;
  final String updatedAt;

  BankData({
    required this.id,
    required this.bankName,
    required this.accountHolderName,
    required this.accountNumber,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BankData.fromJson(Map<String, dynamic> json) {
    return BankData(
      id: json['_id'] ?? '',
      bankName: json['bankName'] ?? '',
      accountHolderName: json['accountHolderName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      balance: json['balance'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
