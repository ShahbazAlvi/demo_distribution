class BankListModel {
  final bool success;
  final String message;
  final List<BankData> banks;

  BankListModel({
    required this.success,
    required this.message,
    required this.banks,
  });

  factory BankListModel.fromJson(Map<String, dynamic> json) {
    return BankListModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      banks: (json['data']['data'] as List)
          .map((e) => BankData.fromJson(e))
          .toList(),
    );
  }
}
class BankData {
  final int id;
  final String name;
  final String accountTitle;
  final String accountNo;
  final String branch;
  final int isActive;
  final String createdAt;
  final String updatedAt;

  BankData({
    required this.id,
    required this.name,
    required this.accountTitle,
    required this.accountNo,
    required this.branch,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BankData.fromJson(Map<String, dynamic> json) {
    return BankData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      accountTitle: json['account_title'] ?? '',
      accountNo: json['account_no'] ?? '',
      branch: json['branch'] ?? '',
      isActive: json['is_active'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
