class ItemUnitModel {
  final int? id;
  final String? name;
  final String? shortName;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  ItemUnitModel({
    this.id,
    this.name,
    this.shortName,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory ItemUnitModel.fromJson(Map<String, dynamic> json) {
    return ItemUnitModel(
      id: json['id'],
      name: json['name'],
      shortName: json['short_name'],
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'short_name': shortName,
      'is_active': isActive == true ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}