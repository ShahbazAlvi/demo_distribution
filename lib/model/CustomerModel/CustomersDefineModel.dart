
// this model for step up
class CustomerData {
  final int id;
  final int? companyId;
  final int? createdBy;
  final int? updatedBy;
  final String name;
  final String phone;
  final String email;
  final String address;
  final int? salesAreaId;
  final int? salesSubAreaId;
  final String openingBalance;
  final String creditLimit;
  final int isActive;
  final String createdAt;
  final String updatedAt;

  CustomerData({
    required this.id,
    this.companyId,
    this.createdBy,
    this.updatedBy,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    this.salesAreaId,
    this.salesSubAreaId,
    required this.openingBalance,
    required this.creditLimit,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'] ?? 0,
      companyId: json['company_id'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      name: json['name'] ?? "",
      phone: json['phone'] ?? "",
      email: json['email'] ?? "",
      address: json['address'] ?? "",
      salesAreaId: json['sales_area_id'],
      salesSubAreaId: json['sales_sub_area_id'],
      openingBalance: json['opening_balance'] ?? "0",
      creditLimit: json['credit_limit'] ?? "0",
      isActive: json['is_active'] ?? 0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }
}
