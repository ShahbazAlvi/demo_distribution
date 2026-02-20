class ItemTypeModel {
  final int? id;
  final String? name;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  ItemTypeModel({
    this.id,
    this.name,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory ItemTypeModel.fromJson(Map<String, dynamic> json) {
    return ItemTypeModel(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive == true ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}