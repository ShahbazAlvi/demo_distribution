class PayableAmountModel {
  final int? sr;
  final String? supplier;
  final double? balance;

  PayableAmountModel({
    this.sr,
    this.supplier,
    this.balance,
  });

  factory PayableAmountModel.fromJson(Map<String, dynamic> json) {
    return PayableAmountModel(
      sr: json["SR"] is int ? json["SR"] : int.tryParse(json["SR"].toString()),
      supplier: json["Supplier"]?.toString(),
      balance: double.tryParse(json["Balance"].toString()) ?? 0.0,
    );
  }
}

class PayableAmountResponse {
  final bool success;
  final String? message;
  final double totalPayable;
  final int count;
  final List<PayableAmountModel> data;

  PayableAmountResponse({
    required this.success,
    this.message,
    required this.totalPayable,
    required this.count,
    required this.data,
  });

  factory PayableAmountResponse.fromJson(Map<String, dynamic> json) {
    return PayableAmountResponse(
      success: json["success"] ?? false,
      message: json["message"],
      totalPayable: double.tryParse(json["totalPayable"].toString()) ?? 0.0,
      count: json["count"] ?? 0,
      data: (json["data"] as List<dynamic>?)
          ?.map((e) => PayableAmountModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}
