class DatewisePurchaseModel {
  final bool success;
  final int count;
  final List<DatewisePurchaseData> data;

  DatewisePurchaseModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory DatewisePurchaseModel.fromJson(Map<String, dynamic> json) {
    return DatewisePurchaseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => DatewisePurchaseData.fromJson(item))
          .toList(),
    );
  }
}

class DatewisePurchaseData {
  final String id;
  final String grnId;
  final String grnDate;
  final Supplier supplier;
  final List<PurchaseProduct> products;
  final double totalAmount;
  final String createdAt;
  final String updatedAt;

  DatewisePurchaseData({
    required this.id,
    required this.grnId,
    required this.grnDate,
    required this.supplier,
    required this.products,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DatewisePurchaseData.fromJson(Map<String, dynamic> json) {
    return DatewisePurchaseData(
      id: json['_id'] ?? '',
      grnId: json['grnId'] ?? '',
      grnDate: json['grnDate'] ?? '',
      supplier: Supplier.fromJson(json['Supplier'] ?? {}),
      products: (json['products'] as List<dynamic>? ?? [])
          .map((e) => PurchaseProduct.fromJson(e))
          .toList(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
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
      id: json['_id'] ?? '',
      supplierName: json['supplierName'] ?? '',
    );
  }
}

class PurchaseProduct {
  final String item;
  final int qty;
  final double rate;
  final double total;

  PurchaseProduct({
    required this.item,
    required this.qty,
    required this.rate,
    required this.total,
  });

  factory PurchaseProduct.fromJson(Map<String, dynamic> json) {
    return PurchaseProduct(
      item: json['item'] ?? '',
      qty: json['qty'] ?? 0,
      rate: (json['rate'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}
