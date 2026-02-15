class DailySaleReportModel {
  final bool success;
  final String message;
  final String salesmanId;
  final String salesman;
  final String date;
  final List<ProductSection> productSection;
  final List<CustomerSection> customerSection;
  final Totals totals;

  DailySaleReportModel({
    required this.success,
    required this.message,
    required this.salesmanId,
    required this.salesman,
    required this.date,
    required this.productSection,
    required this.customerSection,
    required this.totals,
  });

  factory DailySaleReportModel.fromJson(Map<String, dynamic> json) {
    return DailySaleReportModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      salesmanId: json['salesmanId'] ?? "",
      salesman: json['salesman'] ?? "",
      date: json['date'] ?? "",
      productSection: (json['productSection'] as List)
          .map((e) => ProductSection.fromJson(e))
          .toList(),
      customerSection: (json['customerSection'] as List)
          .map((e) => CustomerSection.fromJson(e))
          .toList(),
      totals: Totals.fromJson(json['totals']),
    );
  }
}

class ProductSection {
  final String supplier;
  final String product;
  final String weight;
  final int purchasePrice;
  final int salePrice;
  final int qty;
  final int purchaseTotal;
  final int saleTotal;

  ProductSection({
    required this.supplier,
    required this.product,
    required this.weight,
    required this.purchasePrice,
    required this.salePrice,
    required this.qty,
    required this.purchaseTotal,
    required this.saleTotal,
  });

  factory ProductSection.fromJson(Map<String, dynamic> json) {
    return ProductSection(
      supplier: json['supplier'] ?? "-",
      product: json['product'] ?? "",
      weight: json['weight'] ?? "",
      purchasePrice: json['purchasePrice'] ?? 0,
      salePrice: json['salePrice'] ?? 0,
      qty: json['qty'] ?? 0,
      purchaseTotal: json['purchaseTotal'] ?? 0,
      saleTotal: json['saleTotal'] ?? 0,
    );
  }
}

class CustomerSection {
  final String customer;
  final String salesArea;
  final String customerAddress;
  final int sales;
  final int recovery;

  CustomerSection({
    required this.customer,
    required this.salesArea,
    required this.customerAddress,
    required this.sales,
    required this.recovery,
  });

  factory CustomerSection.fromJson(Map<String, dynamic> json) {
    return CustomerSection(
      customer: json['customer'] ?? "",
      salesArea: json['salesArea'] ?? "-",
      customerAddress: json['customerAddress'] ?? "",
      sales: json['sales'] ?? 0,
      recovery: json['recovery'] ?? 0,
    );
  }
}

class Totals {
  final int totalPurchase;
  final int totalSales;

  Totals({
    required this.totalPurchase,
    required this.totalSales,
  });

  factory Totals.fromJson(Map<String, dynamic> json) {
    return Totals(
      totalPurchase: json['totalPurchase'] ?? 0,
      totalSales: json['totalSales'] ?? 0,
    );
  }
}
