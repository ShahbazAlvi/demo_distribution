class StockPositionModel {
  final bool success;
  final String message;
  final StockPositionData data;

  StockPositionModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory StockPositionModel.fromJson(Map<String, dynamic> json) {
    return StockPositionModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: StockPositionData.fromJson(json['data']),
    );
  }
}

class StockPositionData {
  final List<StockItem> items;

  StockPositionData({required this.items});

  factory StockPositionData.fromJson(Map<String, dynamic> json) {
    return StockPositionData(
      items: (json['data'] as List)
          .map((e) => StockItem.fromJson(e))
          .toList(),
    );
  }
}

class StockItem {
  final int id;
  final String sku;
  final String itemName;
  final String itemType;
  final String category;
  final String subcategory;
  final String manufacturer;
  final String unit;
  final String unitShort;
  final String location;
  final String locationCode;

  final int openingQty;
  final int inQty;
  final int outQty;
  final int balanceQty;

  final num avgRate;
  final num stockValue;

  final bool isActive;
  final String? updatedAt;

  final StockBreakdown breakdown;

  StockItem({
    required this.id,
    required this.sku,
    required this.itemName,
    required this.itemType,
    required this.category,
    required this.subcategory,
    required this.manufacturer,
    required this.unit,
    required this.unitShort,
    required this.location,
    required this.locationCode,
    required this.openingQty,
    required this.inQty,
    required this.outQty,
    required this.balanceQty,
    required this.avgRate,
    required this.stockValue,
    required this.isActive,
    required this.updatedAt,
    required this.breakdown,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      id: json['id'] ?? 0,
      sku: json['sku'] ?? '',
      itemName: json['item_name'] ?? '',
      itemType: json['item_type'] ?? '',
      category: json['category'] ?? '',
      subcategory: json['subcategory'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      unit: json['unit'] ?? '',
      unitShort: json['unit_short'] ?? '',
      location: json['location'] ?? '',
      locationCode: json['location_code'] ?? '',
      openingQty: json['opening_qty'] ?? 0,
      inQty: json['in_qty'] ?? 0,
      outQty: json['out_qty'] ?? 0,
      balanceQty: json['balance_qty'] ?? 0,
      avgRate: json['avg_rate'] ?? 0,
      stockValue: json['stock_value'] ?? 0,
      isActive: json['is_active'] == 1,
      updatedAt: json['updated_at'],
      breakdown: StockBreakdown.fromJson(json['breakdown']),
    );
  }
}

class StockBreakdown {
  final int purchases;
  final int purchaseReturns;
  final int salesTax;
  final int salesNoTax;
  final int salesTotal;
  final int salesReturns;

  StockBreakdown({
    required this.purchases,
    required this.purchaseReturns,
    required this.salesTax,
    required this.salesNoTax,
    required this.salesTotal,
    required this.salesReturns,
  });

  factory StockBreakdown.fromJson(Map<String, dynamic> json) {
    return StockBreakdown(
      purchases: json['purchases'] ?? 0,
      purchaseReturns: json['purchase_returns'] ?? 0,
      salesTax: json['sales_tax'] ?? 0,
      salesNoTax: json['sales_notax'] ?? 0,
      salesTotal: json['sales_total'] ?? 0,
      salesReturns: json['sales_returns'] ?? 0,
    );
  }
}