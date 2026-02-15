class CategoriesModel {
  final String? id;
  final String? categoryName;
  final bool? isEnable;
  final String? createdAt;

  CategoriesModel({
    this.id,
    this.categoryName,
    this.isEnable,
    this.createdAt,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json['_id'],
      categoryName: json['categoryName'],
      isEnable: json['isEnable'],
      createdAt: json['createdAt'],
    );
  }
}
