class PurchaseOrder {
  final int id;
  final String poNo;
  final int supplierId;
  final String supplierName;
  final DateTime poDate;
  final String status;
  final String? remarks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalItems;
  final String totalQty;
  final String totalAmount;

  PurchaseOrder({
    required this.id,
    required this.poNo,
    required this.supplierId,
    required this.supplierName,
    required this.poDate,
    required this.status,
    required this.remarks,
    required this.createdAt,
    required this.updatedAt,
    required this.totalItems,
    required this.totalQty,
    required this.totalAmount,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      id: json['id'],
      poNo: json['po_no'],
      supplierId: json['supplier_id'],
      supplierName: json['supplier_name'],
      poDate: DateTime.parse(json['po_date']),
      status: json['status'],
      remarks: json['remarks'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      totalItems: json['total_items'],
      totalQty: json['total_qty'],
      totalAmount: json['total_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'po_no': poNo,
      'supplier_id': supplierId,
      'supplier_name': supplierName,
      'po_date': poDate.toIso8601String(),
      'status': status,
      'remarks': remarks,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'total_items': totalItems,
      'total_qty': totalQty,
      'total_amount': totalAmount,
    };
  }
}
class PurchaseOrderResponse {
  final bool success;
  final String message;
  final List<PurchaseOrder> orders;

  PurchaseOrderResponse({
    required this.success,
    required this.message,
    required this.orders,
  });

  factory PurchaseOrderResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderResponse(
      success: json['success'],
      message: json['message'],
      orders: (json['data']['data'] as List)
          .map((e) => PurchaseOrder.fromJson(e))
          .toList(),
    );
  }
}
