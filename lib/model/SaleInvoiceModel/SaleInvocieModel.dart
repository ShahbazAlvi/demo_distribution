class SaleInvoiceModel {
  final bool success;
  final int count;
  final String date;
  final String salesmanId;
  final List<SaleInvoiceData> data;

  SaleInvoiceModel({
    required this.success,
    required this.count,
    required this.date,
    required this.salesmanId,
    required this.data,
  });

  factory SaleInvoiceModel.fromJson(Map<String, dynamic> json) {
    return SaleInvoiceModel(
      success: json["success"],
      count: json["count"],
      date: json["date"],
      salesmanId: json["salesmanId"],
      data: (json["data"] as List)
          .map((e) => SaleInvoiceData.fromJson(e))
          .toList(),
    );
  }
}

class SaleInvoiceData {
  final String id;
  final String orderId;
  final DateTime date;
  //final Salesman salesmanId;
  final Salesman? salesmanId;
  final Customer customerId;
  final List<ProductItem> products;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalAmount;

  SaleInvoiceData({
    required this.id,
    required this.orderId,
    required this.date,
    required this.salesmanId,
    required this.customerId,
    required this.products,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.totalAmount,
  });

  factory SaleInvoiceData.fromJson(Map<String, dynamic> json) {
    return SaleInvoiceData(
      id: json["_id"],
      orderId: json["orderId"],
      date: DateTime.parse(json["date"]),
     // salesmanId: Salesman.fromJson(json["salesmanId"]),
      salesmanId: json["salesmanId"] != null
          ? Salesman.fromJson(json["salesmanId"])
          : null,

      customerId: Customer.fromJson(json["customerId"]),
      products: (json["products"] as List)
          .map((e) => ProductItem.fromJson(e))
          .toList(),
      status: json["status"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      totalAmount: json["totalAmount"],
    );
  }
}

class Salesman {
  final String id;
  final String employeeName;

  Salesman({
    required this.id,
    required this.employeeName,
  });

  factory Salesman.fromJson(Map<String, dynamic> json) {
    return Salesman(
      id: json["_id"],
      employeeName: json["employeeName"],
    );
  }
}

class Customer {
  final String id;
  final String customerName;
  final String address;
  final String phoneNumber;
  final int creditTime;
  final int salesBalance;
 // final int? timeLimit;
  final DateTime? timeLimit;

  Customer({
    required this.id,
    required this.customerName,
    required this.address,
    required this.phoneNumber,
    required this.creditTime,
    required this.salesBalance,
    this.timeLimit,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json["_id"],
      customerName: json["customerName"],
      address: json["address"],
      phoneNumber: json["phoneNumber"],
      creditTime: json["creditTime"],
      salesBalance: json["salesBalance"],
     // timeLimit: json["timeLimit"],
      timeLimit: json["timeLimit"] != null ? DateTime.parse(json["timeLimit"]) : null,
    );
  }
}

class ProductItem {
  final String categoryName;
  final String itemName;
  final int qty;
  final String itemUnit;
  final int rate;
  final int totalAmount;
  final String id;

  ProductItem({
    required this.categoryName,
    required this.itemName,
    required this.qty,
    required this.itemUnit,
    required this.rate,
    required this.totalAmount,
    required this.id,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      categoryName: json["categoryName"],
      itemName: json["itemName"],
      qty: json["qty"],
      itemUnit: json["itemUnit"],
      rate: json["rate"],
      totalAmount: json["totalAmount"],
      id: json["_id"],
    );
  }
}
