class DailySaleReportModel {
  final bool success;
  final String message;
  final DailySaleReportData data;

  DailySaleReportModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DailySaleReportModel.fromJson(Map<String, dynamic> json) {
    return DailySaleReportModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: DailySaleReportData.fromJson(json['data'] ?? {}),
    );
  }
}

class DailySaleReportData {
  final List<SalesItem> salesItems;
  final List<PaymentReceived> paymentsReceived;
  final List<RecoveryItem> recoveries;
  final Summary summary;

  DailySaleReportData({
    required this.salesItems,
    required this.paymentsReceived,
    required this.recoveries,
    required this.summary,
  });

  factory DailySaleReportData.fromJson(Map<String, dynamic> json) {
    return DailySaleReportData(
      salesItems: (json['sales_items'] as List<dynamic>?)
          ?.map((e) => SalesItem.fromJson(e))
          .toList() ??
          [],
      paymentsReceived: (json['payments_received'] as List<dynamic>?)
          ?.map((e) => PaymentReceived.fromJson(e))
          .toList() ??
          [],
      recoveries: (json['recoveries'] as List<dynamic>?)
          ?.map((e) => RecoveryItem.fromJson(e))
          .toList() ??
          [],
      summary: Summary.fromJson(json['summary'] ?? {}),
    );
  }
}

class SalesItem {
  final int itemId;
  final String itemName;
  final String itemSku;
  final String unitName;
  final double totalQty;
  final double avgRate;
  final double totalAmount;
  final double totalTax;

  SalesItem({
    required this.itemId,
    required this.itemName,
    required this.itemSku,
    required this.unitName,
    required this.totalQty,
    required this.avgRate,
    required this.totalAmount,
    required this.totalTax,
  });

  factory SalesItem.fromJson(Map<String, dynamic> json) {
    return SalesItem(
      itemId: json['item_id'] ?? 0,
      itemName: json['item_name'] ?? "",
      itemSku: json['item_sku'] ?? "",
      unitName: json['unit_name'] ?? "",
      totalQty: double.tryParse(json['total_qty']?.toString() ?? "0") ?? 0,
      avgRate: double.tryParse(json['avg_rate']?.toString() ?? "0") ?? 0,
      totalAmount:
      double.tryParse(json['total_amount']?.toString() ?? "0") ?? 0,
      totalTax: double.tryParse(json['total_tax']?.toString() ?? "0") ?? 0,
    );
  }
}

class PaymentReceived {
  final int customerId;
  final String customerName;
  final double totalInvoiceAmount;
  final double totalReceived;
  final double balance;

  PaymentReceived({
    required this.customerId,
    required this.customerName,
    required this.totalInvoiceAmount,
    required this.totalReceived,
    required this.balance,
  });

  factory PaymentReceived.fromJson(Map<String, dynamic> json) {
    return PaymentReceived(
      customerId: json['customer_id'] ?? 0,
      customerName: json['customer_name'] ?? "",
      totalInvoiceAmount:
      double.tryParse(json['total_invoice_amount']?.toString() ?? "0") ?? 0,
      totalReceived:
      double.tryParse(json['total_received']?.toString() ?? "0") ?? 0,
      balance: double.tryParse(json['balance']?.toString() ?? "0") ?? 0,
    );
  }
}

class RecoveryItem {
  final int customerId;
  final String customerName;
  final int totalInvoices;
  final double totalDue;
  final String invoiceNumbers;
  final double totalRecovered;
  final double pendingRecovery;

  RecoveryItem({
    required this.customerId,
    required this.customerName,
    required this.totalInvoices,
    required this.totalDue,
    required this.invoiceNumbers,
    required this.totalRecovered,
    required this.pendingRecovery,
  });

  factory RecoveryItem.fromJson(Map<String, dynamic> json) {
    return RecoveryItem(
      customerId: json['customer_id'] ?? 0,
      customerName: json['customer_name'] ?? "",
      totalInvoices: json['total_invoices'] ?? 0,
      totalDue: double.tryParse(json['total_due']?.toString() ?? "0") ?? 0,
      invoiceNumbers: json['invoice_numbers'] ?? "",
      totalRecovered:
      double.tryParse(json['total_recovered']?.toString() ?? "0") ?? 0,
      pendingRecovery:
      double.tryParse(json['pending_recovery']?.toString() ?? "0") ?? 0,
    );
  }
}

class Summary {
  final SummarySales salesItems;
  final SummaryPayments payments;
  final SummaryRecoveries recoveries;

  Summary({
    required this.salesItems,
    required this.payments,
    required this.recoveries,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      salesItems: SummarySales.fromJson(json['sales_items'] ?? {}),
      payments: SummaryPayments.fromJson(json['payments'] ?? {}),
      recoveries: SummaryRecoveries.fromJson(json['recoveries'] ?? {}),
    );
  }
}

class SummarySales {
  final int totalItems;
  final double totalQty;
  final double totalAmount;
  final double totalTax;

  SummarySales({
    required this.totalItems,
    required this.totalQty,
    required this.totalAmount,
    required this.totalTax,
  });

  factory SummarySales.fromJson(Map<String, dynamic> json) {
    return SummarySales(
      totalItems: json['total_items'] ?? 0,
      totalQty: double.tryParse(json['total_qty']?.toString() ?? "0") ?? 0,
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? "0") ?? 0,
      totalTax: double.tryParse(json['total_tax']?.toString() ?? "0") ?? 0,
    );
  }
}

class SummaryPayments {
  final int totalCustomers;
  final double totalInvoiceAmount;
  final double totalReceived;
  final double totalBalance;

  SummaryPayments({
    required this.totalCustomers,
    required this.totalInvoiceAmount,
    required this.totalReceived,
    required this.totalBalance,
  });

  factory SummaryPayments.fromJson(Map<String, dynamic> json) {
    return SummaryPayments(
      totalCustomers: json['total_customers'] ?? 0,
      totalInvoiceAmount:
      double.tryParse(json['total_invoice_amount']?.toString() ?? "0") ?? 0,
      totalReceived:
      double.tryParse(json['total_received']?.toString() ?? "0") ?? 0,
      totalBalance: double.tryParse(json['total_balance']?.toString() ?? "0") ?? 0,
    );
  }
}

class SummaryRecoveries {
  final int totalCustomers;
  final int totalInvoices;
  final double totalDue;
  final double totalRecovered;
  final double pendingRecovery;

  SummaryRecoveries({
    required this.totalCustomers,
    required this.totalInvoices,
    required this.totalDue,
    required this.totalRecovered,
    required this.pendingRecovery,
  });

  factory SummaryRecoveries.fromJson(Map<String, dynamic> json) {
    return SummaryRecoveries(
      totalCustomers: json['total_customers'] ?? 0,
      totalInvoices: json['total_invoices'] ?? 0,
      totalDue: double.tryParse(json['total_due']?.toString() ?? "0") ?? 0,
      totalRecovered:
      double.tryParse(json['total_recovered']?.toString() ?? "0") ?? 0,
      pendingRecovery:
      double.tryParse(json['pending_recovery']?.toString() ?? "0") ?? 0,
    );
  }
}
