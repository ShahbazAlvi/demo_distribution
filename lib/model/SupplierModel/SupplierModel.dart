class SupplierModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final double openingBalance;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  SupplierModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.openingBalance,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "N/A",
      email: json["email"] ?? "N/A",
      phone: json["phone"] ?? "N/A",
      address: json["address"] ?? "N/A",
      openingBalance: double.tryParse(json["opening_balance"] ?? "0") ?? 0,
      isActive: json["is_active"] == 1,
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }
}
