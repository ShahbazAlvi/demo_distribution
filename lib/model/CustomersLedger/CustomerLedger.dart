class CustomerLedgerDetailsModel {
  final bool success;
  final String message;
  final CustomerLedgerData data;

  CustomerLedgerDetailsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CustomerLedgerDetailsModel.fromJson(Map<String, dynamic> json) {
    return CustomerLedgerDetailsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: CustomerLedgerData.fromJson(json['data'] ?? {}),
    );
  }
}
class CustomerLedgerData {
  final CustomerInfo customer;
  final List<LedgerEntry> entries;
  final LedgerSummary summary;

  CustomerLedgerData({
    required this.customer,
    required this.entries,
    required this.summary,
  });

  factory CustomerLedgerData.fromJson(Map<String, dynamic> json) {
    return CustomerLedgerData(
      customer: CustomerInfo.fromJson(json['customer'] ?? {}),
      entries: (json['data'] as List<dynamic>? ?? [])
          .map((e) => LedgerEntry.fromJson(e))
          .toList(),
      summary: LedgerSummary.fromJson(json['summary'] ?? {}),
    );
  }
}
class CustomerInfo {
  final int id;
  final String name;
  final String email;
  final String phone;

  CustomerInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
    );
  }
}
class LedgerEntry {
  final int id;
  final DateTime date;
  final String docType;
  final String docNo;
  final String narration;
  final double debit;
  final double credit;
  final String status;
  final int sortOrder;
  final double balance;

  LedgerEntry({
    required this.id,
    required this.date,
    required this.docType,
    required this.docNo,
    required this.narration,
    required this.debit,
    required this.credit,
    required this.status,
    required this.sortOrder,
    required this.balance,
  });

  factory LedgerEntry.fromJson(Map<String, dynamic> json) {
    return LedgerEntry(
      id: json['id'] ?? 0,
      date: DateTime.parse(json['date']),
      docType: json['doc_type'] ?? "",
      docNo: json['doc_no'] ?? "",
      narration: json['narration'] ?? "",
      debit: double.tryParse(json['debit']?.toString() ?? "0") ?? 0,
      credit: double.tryParse(json['credit']?.toString() ?? "0") ?? 0,
      status: json['status'] ?? "",
      sortOrder: json['sort_order'] ?? 0,
      balance: double.tryParse(json['balance']?.toString() ?? "0") ?? 0,
    );
  }
}
class LedgerSummary {
  final int totalRecords;
  final double totalDebit;
  final double totalCredit;
  final double openingBalance;
  final double closingBalance;

  LedgerSummary({
    required this.totalRecords,
    required this.totalDebit,
    required this.totalCredit,
    required this.openingBalance,
    required this.closingBalance,
  });

  factory LedgerSummary.fromJson(Map<String, dynamic> json) {
    return LedgerSummary(
      totalRecords: json['total_records'] ?? 0,
      totalDebit: double.tryParse(json['total_debit']?.toString() ?? "0") ?? 0,
      totalCredit: double.tryParse(json['total_credit']?.toString() ?? "0") ?? 0,
      openingBalance:
      double.tryParse(json['opening_balance']?.toString() ?? "0") ?? 0,
      closingBalance:
      double.tryParse(json['closing_balance']?.toString() ?? "0") ?? 0,
    );
  }
}
