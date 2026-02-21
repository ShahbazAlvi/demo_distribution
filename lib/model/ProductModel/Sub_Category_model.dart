class SubCategoryResponse {
  final bool success;
  final String message;
  final SubCategoryData data;

  SubCategoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) {
    return SubCategoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: SubCategoryData.fromJson(json['data']),
    );
  }
}

class SubCategoryData {
  final List<SubCategoryModel> data;

  SubCategoryData({required this.data});

  factory SubCategoryData.fromJson(Map<String, dynamic> json) {
    return SubCategoryData(
      data: (json['data'] as List)
          .map((e) => SubCategoryModel.fromJson(e))
          .toList(),
    );
  }
}

class SubCategoryModel {
  final int id;
  final int categoryId;
  final String name;
  final int isActive;
  final String createdAt;
  final String updatedAt;

  SubCategoryModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}