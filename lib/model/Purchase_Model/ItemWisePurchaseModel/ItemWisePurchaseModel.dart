class ItemWisePurchaseModel {
  final bool success;
  final int count;
  final List<ItemWisePurchaseData> data;

  ItemWisePurchaseModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory ItemWisePurchaseModel.fromJson(Map<String, dynamic> json) {
    return ItemWisePurchaseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => ItemWisePurchaseData.fromJson(item))
          .toList(),
    );
  }
}

class ItemWisePurchaseData {
  final DateTime date;
  final String id;
  final String supplierName;
  final String item;
  final num rate;
  final num qty;
  final num amount;
  final num total;

  ItemWisePurchaseData({
    required this.date,
    required this.id,
    required this.supplierName,
    required this.item,
    required this.rate,
    required this.qty,
    required this.amount,
    required this.total,
  });

  factory ItemWisePurchaseData.fromJson(Map<String, dynamic> json) {
    return ItemWisePurchaseData(
      date: DateTime.tryParse(json['Date'] ?? '') ?? DateTime.now(),
      id: json['ID'] ?? '',
      supplierName: json['SupplierName'] ?? '',
      item: json['Item'] ?? '',
      rate: num.tryParse(json['Rate'].toString()) ?? 0,
      qty: num.tryParse(json['Qty'].toString()) ?? 0,
      amount: num.tryParse(json['Amount'].toString()) ?? 0,
      total: num.tryParse(json['Total'].toString()) ?? 0,
    );
  }
}
