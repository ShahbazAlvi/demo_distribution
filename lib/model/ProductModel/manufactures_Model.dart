class ManufacturesResponse {
  final bool success;
  final String message;
  final ManufacturesData data;

  ManufacturesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ManufacturesResponse.fromJson(Map<String, dynamic> json) {
    return ManufacturesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ManufacturesData.fromJson(json['data']),
    );
  }
}

class ManufacturesData {
  final List<ManufacturesModel> data;

  ManufacturesData({required this.data});

  factory ManufacturesData.fromJson(Map<String, dynamic> json) {
    return ManufacturesData(
      data: (json['data'] as List)
          .map((e) => ManufacturesModel.fromJson(e))
          .toList(),
    );
  }
}

class ManufacturesModel {
  final int id;
  final String name;
  final String phone;
  final String address;
  final int isActive;
  final String createdAt;
  final String updatedAt;

  ManufacturesModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ManufacturesModel.fromJson(Map<String, dynamic> json) {
    return ManufacturesModel(
      id: json['id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      isActive: json['is_active'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}