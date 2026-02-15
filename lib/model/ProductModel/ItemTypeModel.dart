class ItemTypeModel {
  final String? id;
  final Category? category;
  final String? itemTypeName;
  final bool? isEnable;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  ItemTypeModel({
    this.id,
    this.category,
    this.itemTypeName,
    this.isEnable,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ItemTypeModel.fromJson(Map<String, dynamic> json) {
    return ItemTypeModel(
      id: json['_id'],
      category:
      json['category'] != null ? Category.fromJson(json['category']) : null,
      itemTypeName: json['itemTypeName'],
      isEnable: json['isEnable'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'category': category?.toJson(),
      'itemTypeName': itemTypeName,
      'isEnable': isEnable,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class Category {
  final String? id;
  final String? categoryName;

  Category({
    this.id,
    this.categoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      categoryName: json['categoryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'categoryName': categoryName,
    };
  }
}
