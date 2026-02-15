class ItemUnitModel {
  final String? id;
  final String? unitName;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  ItemUnitModel({
    this.id,
    this.unitName,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory ItemUnitModel.fromJson(Map<String, dynamic> json) {
    return ItemUnitModel(
      id: json['_id'],
      unitName: json['unitName'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'unitName': unitName,
    'description': description,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
