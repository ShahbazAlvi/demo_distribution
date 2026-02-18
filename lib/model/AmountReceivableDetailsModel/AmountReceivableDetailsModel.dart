class AmountReceivableModel {
  final bool success;
  final String message;
  final AmountReceivableData data;

  AmountReceivableModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AmountReceivableModel.fromJson(Map<String, dynamic> json) {
    return AmountReceivableModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: AmountReceivableData.fromJson(json["data"] ?? {}),
    );
  }
}

class AmountReceivableData {
  final List<ReceivableData> invoices;
  final ReceivableSummary summary;

  AmountReceivableData({
    required this.invoices,
    required this.summary,
  });

  factory AmountReceivableData.fromJson(Map<String, dynamic> json) {
    return AmountReceivableData(
      invoices: (json["data"] as List<dynamic>? ?? [])
          .map((e) => ReceivableData.fromJson(e))
          .toList(),
      summary: ReceivableSummary.fromJson(json["summary"] ?? {}),
    );
  }
}

class ReceivableData {
  final int id;
  final int customerId;
  final String customerName;
  final int salesmanId;
  final String salesmanName;
  final int locationId;
  final String locationName;
  final String invNo;
  final DateTime invoiceDate;
  final String invoiceType;
  final double grossTotal;
  final double taxTotal;
  final double netTotal;
  final double received;
  final double balance;
  final String status;
  final String? remarks;
  final DateTime updatedAt;

  ReceivableData({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.salesmanId,
    required this.salesmanName,
    required this.locationId,
    required this.locationName,
    required this.invNo,
    required this.invoiceDate,
    required this.invoiceType,
    required this.grossTotal,
    required this.taxTotal,
    required this.netTotal,
    required this.received,
    required this.balance,
    required this.status,
    this.remarks,
    required this.updatedAt,
  });

  factory ReceivableData.fromJson(Map<String, dynamic> json) {
    return ReceivableData(
      id: json["id"] ?? 0,
      customerId: json["customer_id"] ?? 0,
      customerName: json["customer_name"] ?? "",
      salesmanId: json["salesman_id"] ?? 0,
      salesmanName: json["salesman_name"] ?? "",
      locationId: json["location_id"] ?? 0,
      locationName: json["location_name"] ?? "",
      invNo: json["inv_no"] ?? "",
      invoiceDate: DateTime.parse(json["invoice_date"] ?? DateTime.now().toString()),
      invoiceType: json["invoice_type"] ?? "",
      grossTotal: double.tryParse(json["gross_total"] ?? "0") ?? 0,
      taxTotal: double.tryParse(json["tax_total"] ?? "0") ?? 0,
      netTotal: double.tryParse(json["net_total"] ?? "0") ?? 0,
      received: double.tryParse(json["received"] ?? "0") ?? 0,
      balance: double.tryParse(json["balance"] ?? "0") ?? 0,
      status: json["status"] ?? "",
      remarks: json["remarks"],
      updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toString()),
    );
  }
}

class ReceivableSummary {
  final int totalRecords;
  final double totalNet;
  final double totalReceived;
  final double totalBalance;
  final int countPaid;
  final int countPartial;
  final int countOpen;

  ReceivableSummary({
    required this.totalRecords,
    required this.totalNet,
    required this.totalReceived,
    required this.totalBalance,
    required this.countPaid,
    required this.countPartial,
    required this.countOpen,
  });

  factory ReceivableSummary.fromJson(Map<String, dynamic> json) {
    return ReceivableSummary(
      totalRecords: json["total_records"] ?? 0,
      totalNet: double.tryParse(json["total_net"]?.toString() ?? "0") ?? 0,
      totalReceived: double.tryParse(json["total_received"]?.toString() ?? "0") ?? 0,
      totalBalance: double.tryParse(json["total_balance"]?.toString() ?? "0") ?? 0,
      countPaid: json["count_paid"] ?? 0,
      countPartial: json["count_partial"] ?? 0,
      countOpen: json["count_open"] ?? 0,
    );
  }
}
