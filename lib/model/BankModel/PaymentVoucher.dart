class PaymentVoucherModel {
  final bool success;
  final int count;
  final List<PaymentVoucherData> data;

  PaymentVoucherModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory PaymentVoucherModel.fromJson(Map<String, dynamic> json) {
    return PaymentVoucherModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List?)
          ?.map((e) => PaymentVoucherData.fromJson(e))
          .toList()
          ?? [],
    );
  }
}

class PaymentVoucherData {
  final String id;
  final String paymentId;
  final String date;
  final Supplier? supplier;
  final Bank? bank;
  final double amount;
  final String remarks;

  PaymentVoucherData({
    required this.id,
    required this.paymentId,
    required this.date,
    this.bank,
    this.supplier,
    required this.amount,
    required this.remarks,
  });

  factory PaymentVoucherData.fromJson(Map<String, dynamic> json) {
    return PaymentVoucherData(
      id: json['_id'] ?? "",
      paymentId: json['paymentId'] ?? "",
      date: json['date'] ?? "",
      bank: json['bank'] != null ? Bank.fromJson(json['bank']) : null,
      supplier:
      json['supplier'] != null ? Supplier.fromJson(json['supplier']) : null,
      amount: (json['amountPaid'] ?? 0).toDouble(),
      remarks: json['remarks'] ?? "",
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
      id: json['_id'] ?? "",
      supplierName: json['supplierName'] ?? "",
    );
  }
}

class Bank {
  final String id;
  final String bankName;

  Bank({
    required this.id,
    required this.bankName,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['_id'] ?? "",
      bankName: json['bankName'] ?? "",
    );
  }
}
