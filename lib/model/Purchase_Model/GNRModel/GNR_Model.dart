class GRNModel {
  final String id;
  final String grnId;
  final DateTime grnDate;
  final Supplier supplier;
  final List<Product> products;
  final num totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  GRNModel({
    required this.id,
    required this.grnId,
    required this.grnDate,
    required this.supplier,
    required this.products,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GRNModel.fromJson(Map<String, dynamic> json) {
    return GRNModel(
      id: json["_id"],
      grnId: json["grnId"],
      grnDate: DateTime.parse(json["grnDate"]),
      supplier: Supplier.fromJson(json["Supplier"]),
      products: (json["products"] as List)
          .map((e) => Product.fromJson(e))
          .toList(),
      totalAmount: json["totalAmount"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
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

class Product {
  final String item;
  final num qty;
  final num rate;
  final num total;

  Product({
    required this.item,
    required this.qty,
    required this.rate,
    required this.total,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      item: json["item"],
      qty: json["qty"],
      rate: json["rate"],
      total: json["total"],
    );
  }
}
