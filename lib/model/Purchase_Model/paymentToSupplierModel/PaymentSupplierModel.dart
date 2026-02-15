class PaymentToSupplierModel {
  final String id;
  final String receiptId;
  final String date;
  final Supplier supplier;
  final num amountReceived;
  final num newBalance;
  final String remarks;
  final String createdAt;
  final String updatedAt;

  PaymentToSupplierModel({
    required this.id,
    required this.receiptId,
    required this.date,
    required this.supplier,
    required this.amountReceived,
    required this.newBalance,
    required this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentToSupplierModel.fromJson(Map<String, dynamic> json) {
    return PaymentToSupplierModel(
      id: json["_id"],
      receiptId: json["receiptId"],
      date: json["date"],
      supplier: Supplier.fromJson(json["supplier"]),
      amountReceived: json["amountReceived"],
      newBalance: json["newBalance"],
      remarks: json["remarks"] ?? "",
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }
}

class Supplier {
  final String id;
  final String supplierName;

  Supplier({
    required this.id,
    required this.supplierName,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json["_id"],
      supplierName: json["supplierName"],
    );
  }
}
