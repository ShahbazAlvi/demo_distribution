class ItemDetails {
  final String id;
  final String sku;
  final String name;
  final int itemTypeId;
  final int categoryId;
  final int subcategoryId;
  final int manufacturerId;
  final int unitId;
  final double minLevelQty;
  final double purchasePrice;
  final double salePrice;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  ItemDetails({
    required this.id,
    required this.sku,
    required this.name,
    required this.itemTypeId,
    required this.categoryId,
    required this.subcategoryId,
    required this.manufacturerId,
    required this.unitId,
    required this.minLevelQty,
    required this.purchasePrice,
    required this.salePrice,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    return ItemDetails(
      id: json['id'].toString(),
      sku: json['sku'] ?? "",
      name: json['name'] ?? "",
      itemTypeId: json['item_type_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      subcategoryId: json['subcategory_id'] ?? 0,
      manufacturerId: json['manufacturer_id'] ?? 0,
      unitId: json['unit_id'] ?? 0,
      minLevelQty: parseDouble(json['min_level_qty']),
      purchasePrice: parseDouble(json['purchase_price']),
      salePrice: parseDouble(json['sale_price']),
      isActive: json['is_active'] == 1,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }
}
