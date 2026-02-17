class SaleInvoiceModel {
  final bool success;
  final String message;
  final List<SaleInvoiceData> invoices;

  SaleInvoiceModel({
    required this.success,
    required this.message,
    required this.invoices,
  });

  factory SaleInvoiceModel.fromJson(Map<String, dynamic> json) {
    return SaleInvoiceModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      invoices: (json["data"]["data"] as List)
          .map((e) => SaleInvoiceData.fromJson(e))
          .toList(),
    );
  }
}

class SaleInvoiceData {
  final int id;
  final int salesOrderId;
  final String salesOrderNo;
  final String invNo;

  final int customerId;
  final String customerName;

  final int salesmanId;
  final String salesmanName;

  final int? loadId;
  final String? loadNo;

  final DateTime invoiceDate;

  final int locationId;
  final String locationName;

  final String invoiceType;

  final double grossTotal;
  final double netTotal;

  final String status;
  final String? remarks;

  final DateTime createdAt;
  final DateTime updatedAt;

  final int totalItems;
  final double totalQty;

  SaleInvoiceData({
    required this.id,
    required this.salesOrderId,
    required this.salesOrderNo,
    required this.invNo,
    required this.customerId,
    required this.customerName,
    required this.salesmanId,
    required this.salesmanName,
    this.loadId,
    this.loadNo,
    required this.invoiceDate,
    required this.locationId,
    required this.locationName,
    required this.invoiceType,
    required this.grossTotal,
    required this.netTotal,
    required this.status,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
    required this.totalItems,
    required this.totalQty,
  });

  factory SaleInvoiceData.fromJson(Map<String, dynamic> json) {
    return SaleInvoiceData(
      id: json["id"],
      salesOrderId: json["sales_order_id"],
      salesOrderNo: json["sales_order_no"],
      invNo: json["inv_no"],
      customerId: json["customer_id"],
      customerName: json["customer_name"],
      salesmanId: json["salesman_id"],
      salesmanName: json["salesman_name"],
      loadId: json["load_id"],
      loadNo: json["load_no"],
      invoiceDate: DateTime.parse(json["invoice_date"]),
      locationId: json["location_id"],
      locationName: json["location_name"],
      invoiceType: json["invoice_type"],
      grossTotal: _toDouble(json["gross_total"]),
      netTotal: _toDouble(json["net_total"]),
      status: json["status"],
      remarks: json["remarks"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      totalItems: json["total_items"],
      totalQty: _toDouble(json["total_qty"]),
    );
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is int) return value.toDouble();
  if (value is double) return value;
  return double.parse(value.toString());
}
