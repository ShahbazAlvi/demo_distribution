class SupplierLedgerDetailModel {
  final bool success;
  final String message;
  final int count;
  final List<SupplierLedgerData> data;

  SupplierLedgerDetailModel({
    required this.success,
    required this.message,
    required this.count,
    required this.data,
  });

  factory SupplierLedgerDetailModel.fromJson(Map<String, dynamic> json) {
    return SupplierLedgerDetailModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => SupplierLedgerData.fromJson(item))
          .toList(),
    );
  }
}

class SupplierLedgerData {
  final int sr;
  final String id;
  final String date;
  final String supplierName;
  final String description;
  final double paid;
  final double received;
  final double balance;

  SupplierLedgerData({
    required this.sr,
    required this.id,
    required this.date,
    required this.supplierName,
    required this.description,
    required this.paid,
    required this.received,
    required this.balance,
  });

  factory SupplierLedgerData.fromJson(Map<String, dynamic> json) {
    return SupplierLedgerData(
      sr: json['SR'] ?? 0,
      id: json['ID'] ?? '',
      date: json['Date'] ?? '',
      supplierName: json['SupplierName'] ?? '',
      description: json['Description'] ?? '',
      paid: double.tryParse(json['Paid'].toString()) ?? 0.0,
      received: double.tryParse(json['Received'].toString()) ?? 0.0,
      balance: double.tryParse(json['Balance'].toString()) ?? 0.0,
    );
  }
}
