class EmployeesModel {
  final List<EmployeeData> data;

  EmployeesModel({required this.data});

  // Nayi API me 'data' key ke andar 'data' list hai
  factory EmployeesModel.fromJson(Map<String, dynamic> json) {
    final List list = json['data']['data'] ?? [];
    return EmployeesModel(
      data: list.map((e) => EmployeeData.fromJson(e)).toList(),
    );
  }
}

class EmployeeData {
  final int id;
  final String name;
  final String phone;
  final int isActive;
  final String createdAt;
  final String updatedAt;

  EmployeeData({
    required this.id,
    required this.name,
    required this.phone,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      phone: json['phone'] ?? "",
      isActive: json['is_active'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "is_active": isActive,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
