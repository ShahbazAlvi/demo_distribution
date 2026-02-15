class SupplierModel {
  final String id;
  final String supplierName;
  final String email;
  final String contactPerson;
  final String address;
  final String phoneNumber;
  final String mobileNumber;
  final String designation;
  final String ntn;
  final String gst;
  final String paymentTerms;
  final int creditLimit;
  final int creditTime;
  final bool status;
  final num payableBalance;
  final String createdAt;
  final String updatedAt;
  final String invoiceNo;
  final String contactNumber;


  SupplierModel({
    required this.id,
    required this.supplierName,
    required this.email,
    required this.contactPerson,
    required this.address,
    required this.phoneNumber,
    required this.mobileNumber,
    required this.designation,
    required this.ntn,
    required this.gst,
    required this.paymentTerms,
    required this.creditLimit,
    required this.creditTime,
    required this.status,
    required this.payableBalance,
    required this.createdAt,
    required this.updatedAt,
    required this.invoiceNo,
    required this.contactNumber,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json["_id"] ?? "",
      supplierName: json["supplierName"] ?? "N/A",
      email: json["email"] ?? "N/A",
      contactPerson: json["contactPerson"] ?? "",
      address: json["address"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "0",

      mobileNumber: json["mobileNumber"] ?? "0",
      designation: json["designation"] ?? "",
      ntn: json["ntn"] ?? "0",
      gst: json["gst"] ?? "0",
      paymentTerms: json["paymentTerms"] ?? "N/A",
      creditLimit: json["creditLimit"] ?? 0,
      creditTime: json["creditTime"] ?? 0,
      status: json["status"] ?? false,
      payableBalance: json["payableBalance"] ?? 0,
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      invoiceNo: json["invoiceNo"] ?? "",
      contactNumber: json["contactNumber"]?.toString() ?? "",
    );
  }
}
