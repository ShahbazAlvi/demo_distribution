class SalesModel {
  final bool success;
  final String message;
  final String salesmanId;
  final int totalPurchase;
  final int totalSales;
  final int count;
  final List<SalesData> data;

  SalesModel({
    required this.success,
    required this.message,
    required this.salesmanId,
    required this.totalPurchase,
    required this.totalSales,
    required this.count,
    required this.data,
  });

  factory SalesModel.fromJson(Map<String, dynamic> json) {
    return SalesModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      salesmanId: json['salesmanId'] ?? '',
      totalPurchase: json['totalPurchase'] ?? 0,
      totalSales: json['totalSales'] ?? 0,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => SalesData.fromJson(item))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'salesmanId': salesmanId,
      'totalPurchase': totalPurchase,
      'totalSales': totalSales,
      'count': count,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class SalesData {
  final String orderId;
  final String date;
  final String salesman;
  final String customer;
  final String salesArea;
  final String customerAddress;
  final String supplier;
  final String product;
  final String weight;
  final int purchasePrice;
  final int salePrice;
  final int qty;
  final int purchaseTotal;
  final int saleTotal;

  SalesData({
    required this.orderId,
    required this.date,
    required this.salesman,
    required this.customer,
    required this.salesArea,
    required this.customerAddress,
    required this.supplier,
    required this.product,
    required this.weight,
    required this.purchasePrice,
    required this.salePrice,
    required this.qty,
    required this.purchaseTotal,
    required this.saleTotal,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      orderId: json['orderId'] ?? '',
      date: json['date'] ?? '',
      salesman: json['salesman'] ?? '',
      customer: json['customer'] ?? '',
      salesArea: json['salesArea'] ?? '',
      customerAddress: json['customerAddress'] ?? '',
      supplier: json['supplier'] ?? '',
      product: json['product'] ?? '',
      weight: json['weight'] ?? '',
      purchasePrice: json['purchasePrice'] ?? 0,
      salePrice: json['salePrice'] ?? 0,
      qty: json['qty'] ?? 0,
      purchaseTotal: json['purchaseTotal'] ?? 0,
      saleTotal: json['saleTotal'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'date': date,
      'salesman': salesman,
      'customer': customer,
      'salesArea': salesArea,
      'customerAddress': customerAddress,
      'supplier': supplier,
      'product': product,
      'weight': weight,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'qty': qty,
      'purchaseTotal': purchaseTotal,
      'saleTotal': saleTotal,
    };
  }
}
