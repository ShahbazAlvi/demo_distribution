class AmountReceivableModel {
  final bool success;
  final String message;
  final String totalReceivable;
  final int count;
  final List<ReceivableData> data;

  AmountReceivableModel({
    required this.success,
    required this.message,
    required this.totalReceivable,
    required this.count,
    required this.data,
  });

  factory AmountReceivableModel.fromJson(Map<String, dynamic> json) {
    return AmountReceivableModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      totalReceivable: json["totalReceivable"] ?? "0",
      count: json["count"] ?? 0,
      data: (json["data"] as List<dynamic>? ?? [])
          .map((e) => ReceivableData.fromJson(e))
          .toList(),
    );
  }
}

class ReceivableData {
  final int sr;
  final String customer;
  final String balance;

  ReceivableData({
    required this.sr,
    required this.customer,
    required this.balance,
  });

  factory ReceivableData.fromJson(Map<String, dynamic> json) {
    return ReceivableData(
      sr: json["SR"] ?? 0,
      customer: json["Customer"] ?? "",
      balance: json["Balance"] ?? "0",
    );
  }
}
