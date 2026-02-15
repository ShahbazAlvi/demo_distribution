class SupplierwisePurchaseModel {
  final bool success;
  final int count;
  final List<SupplierwisePurchaseData> data;

  SupplierwisePurchaseModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory SupplierwisePurchaseModel.fromJson(Map<String, dynamic> json) {
    return SupplierwisePurchaseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => SupplierwisePurchaseData.fromJson(e))
          .toList(),
    );
  }
}

class SupplierwisePurchaseData {
  final String date;
  final String id;
  final String supplierName;
  final String item;
  final double rate;
  final double qty;
  final double amount;
  final double payable;
  final double discount;
  final double total;

  SupplierwisePurchaseData({
    required this.date,
    required this.id,
    required this.supplierName,
    required this.item,
    required this.rate,
    required this.qty,
    required this.amount,
    required this.payable,
    required this.discount,
    required this.total,
  });

  factory SupplierwisePurchaseData.fromJson(Map<String, dynamic> json) {
    return SupplierwisePurchaseData(
      date: json['Date'] ?? '',
      id: json['ID'] ?? '',
      supplierName: json['SupplierName'] ?? '',
      item: json['Item'] ?? '',
      rate: double.tryParse(json['Rate'].toString()) ?? 0.0,
      qty: double.tryParse(json['Qty'].toString()) ?? 0.0,
      amount: double.tryParse(json['Amount'].toString()) ?? 0.0,
      payable: double.tryParse(json['Payable'].toString()) ?? 0.0,
      discount: double.tryParse(json['Discount'].toString()) ?? 0.0,
      total: double.tryParse(json['Total'].toString()) ?? 0.0,
    );
  }
}
