class ProductModel {
  final String id;
  final String itemUnit;
  final String itemName;
  final double price;
  final double stock;

  ProductModel({
    required this.id,
    required this.itemUnit,
    required this.itemName,
    required this.price,
    required this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      itemUnit: json['itemUnit'] ?? '',
      itemName: json['itemName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: (json['stock'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'itemUnit': itemUnit,
      'itemName': itemName,
      'price': price,
      'stock': stock,
    };
  }
}
