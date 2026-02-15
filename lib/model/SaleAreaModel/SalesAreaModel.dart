class SalesAreaModel {
  final String id;
  final String salesArea;
  final String description;
  final String createdAt;
  final String updatedAt;
  final int v;

  SalesAreaModel({
    required this.id,
    required this.salesArea,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory SalesAreaModel.fromJson(Map<String, dynamic> json) {
    return SalesAreaModel(
      id: json["_id"],
      salesArea: json["salesArea"],
      description: json["description"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      v: json["__v"],
    );
  }
}
