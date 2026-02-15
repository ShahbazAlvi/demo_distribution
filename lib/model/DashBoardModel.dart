class DashboardModel {
  bool success;
  Stats stats;
  Charts charts;
  List<RecentBooking> recentBookings;

  DashboardModel({
    required this.success,
    required this.stats,
    required this.charts,
    required this.recentBookings,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    success: json['success'] ?? false,
    stats: Stats.fromJson(json['stats']),
    charts: Charts.fromJson(json['charts']),
    recentBookings: List<RecentBooking>.from(
        json['recentBookings'].map((x) => RecentBooking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'stats': stats.toJson(),
    'charts': charts.toJson(),
    'recentBookings': List<dynamic>.from(recentBookings.map((x) => x.toJson())),
  };
}

class Stats {
  int totalCustomers;
  int totalProducts;
  int totalStaff;
  int totalSales;
  int totalBookings;

  Stats({
    required this.totalCustomers,
    required this.totalProducts,
    required this.totalStaff,
    required this.totalSales,
    required this.totalBookings,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    totalCustomers: json['totalCustomers'] ?? 0,
    totalProducts: json['totalProducts'] ?? 0,
    totalStaff: json['totalStaff'] ?? 0,
    totalSales: json['totalSales'] ?? 0,
    totalBookings: json['totalBookings'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'totalCustomers': totalCustomers,
    'totalProducts': totalProducts,
    'totalStaff': totalStaff,
    'totalSales': totalSales,
    'totalBookings': totalBookings,
  };
}

class Charts {
  List<CustomerOrders> customerOrders;
  List<SalesProfit> salesProfit;
  List<CustomerBalance> customerBalance;

  Charts({
    required this.customerOrders,
    required this.salesProfit,
    required this.customerBalance,
  });

  factory Charts.fromJson(Map<String, dynamic> json) => Charts(
    customerOrders: List<CustomerOrders>.from(
        json['customerOrders'].map((x) => CustomerOrders.fromJson(x))),
    salesProfit: List<SalesProfit>.from(
        json['salesProfit'].map((x) => SalesProfit.fromJson(x))),
    customerBalance: List<CustomerBalance>.from(
        json['customerBalance'].map((x) => CustomerBalance.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'customerOrders': List<dynamic>.from(customerOrders.map((x) => x.toJson())),
    'salesProfit': List<dynamic>.from(salesProfit.map((x) => x.toJson())),
    'customerBalance': List<dynamic>.from(customerBalance.map((x) => x.toJson())),
  };
}

class CustomerOrders {
  int id;
  int totalOrders;

  CustomerOrders({
    required this.id,
    required this.totalOrders,
  });

  factory CustomerOrders.fromJson(Map<String, dynamic> json) => CustomerOrders(
    id: json['_id'] ?? 0,
    totalOrders: json['totalOrders'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'totalOrders': totalOrders,
  };
}

class SalesProfit {
  String label;
  int value;

  SalesProfit({
    required this.label,
    required this.value,
  });

  factory SalesProfit.fromJson(Map<String, dynamic> json) => SalesProfit(
    label: json['label'] ?? '',
    value: json['value'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'label': label,
    'value': value,
  };
}

class CustomerBalance {
  String label;
  int value;

  CustomerBalance({
    required this.label,
    required this.value,
  });

  factory CustomerBalance.fromJson(Map<String, dynamic> json) => CustomerBalance(
    label: json['label'] ?? '',
    value: json['value'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'label': label,
    'value': value,
  };
}

// class RecentBooking {
//   String id;
//   String orderId;
//   DateTime date;
//   String salesmanId;
//   CustomerId customerId;
//   List<Product> products;
//   String status;
//   DateTime createdAt;
//   DateTime updatedAt;
//
//   RecentBooking({
//     required this.id,
//     required this.orderId,
//     required this.date,
//     required this.salesmanId,
//     required this.customerId,
//     required this.products,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory RecentBooking.fromJson(Map<String, dynamic> json) => RecentBooking(
//     id: json['_id'] ?? '',
//     orderId: json['orderId'] ?? '',
//     date: DateTime.parse(json['date']),
//     salesmanId: json['salesmanId'] ?? '',
//     customerId: CustomerId.fromJson(json['customerId']),
//     products:
//     List<Product>.from(json['products'].map((x) => Product.fromJson(x))),
//     status: json['status'] ?? '',
//     createdAt: DateTime.parse(json['createdAt']),
//     updatedAt: DateTime.parse(json['updatedAt']),
//   );
//
//   Map<String, dynamic> toJson() => {
//     '_id': id,
//     'orderId': orderId,
//     'date': date.toIso8601String(),
//     'salesmanId': salesmanId,
//     'customerId': customerId.toJson(),
//     'products': List<dynamic>.from(products.map((x) => x.toJson())),
//     'status': status,
//     'createdAt': createdAt.toIso8601String(),
//     'updatedAt': updatedAt.toIso8601String(),
//   };
// }
class RecentBooking {
  String id;
  String orderId;
  DateTime date;
  String salesmanId;
  CustomerId? customerId; // nullable
  List<Product> products;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  RecentBooking({
    required this.id,
    required this.orderId,
    required this.date,
    required this.salesmanId,
    this.customerId, // nullable
    required this.products,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecentBooking.fromJson(Map<String, dynamic> json) => RecentBooking(
    id: json['_id'] ?? '',
    orderId: json['orderId'] ?? '',
    date: DateTime.parse(json['date']),
    salesmanId: json['salesmanId'] ?? '',
    customerId: json['customerId'] != null
        ? CustomerId.fromJson(json['customerId'])
        : null, // null check
    products: List<Product>.from(
        json['products'].map((x) => Product.fromJson(x))),
    status: json['status'] ?? '',
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'orderId': orderId,
    'date': date.toIso8601String(),
    'salesmanId': salesmanId,
    'customerId': customerId?.toJson(), // safe access
    'products': List<dynamic>.from(products.map((x) => x.toJson())),
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}


class CustomerId {
  String id;
  String customerName;
  String address;
  String phoneNumber;

  CustomerId({
    required this.id,
    required this.customerName,
    required this.address,
    required this.phoneNumber,
  });

  factory CustomerId.fromJson(Map<String, dynamic> json) => CustomerId(
    id: json['_id'] ?? '',
    customerName: json['customerName'] ?? '',
    address: json['address'] ?? '',
    phoneNumber: json['phoneNumber'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'customerName': customerName,
    'address': address,
    'phoneNumber': phoneNumber,
  };
}

class Product {
  String categoryName;
  String itemName;
  int qty;
  String itemUnit;
  int rate;
  int totalAmount;
  String id;

  Product({
    required this.categoryName,
    required this.itemName,
    required this.qty,
    required this.itemUnit,
    required this.rate,
    required this.totalAmount,
    required this.id,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    categoryName: json['categoryName'] ?? '',
    itemName: json['itemName'] ?? '',
    qty: json['qty'] ?? 0,
    itemUnit: json['itemUnit'] ?? '',
    rate: json['rate'] ?? 0,
    totalAmount: json['totalAmount'] ?? 0,
    id: json['_id'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'categoryName': categoryName,
    'itemName': itemName,
    'qty': qty,
    'itemUnit': itemUnit,
    'rate': rate,
    'totalAmount': totalAmount,
    '_id': id,
  };
}
