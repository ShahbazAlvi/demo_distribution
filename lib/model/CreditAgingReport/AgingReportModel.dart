class CreditAgingReportModel {
  final bool success;
  final String message;
  final int count;
  final Totals totals;
  final List<CustomerReport> data;

  CreditAgingReportModel({
    required this.success,
    required this.message,
    required this.count,
    required this.totals,
    required this.data,
  });

  factory CreditAgingReportModel.fromJson(Map<String, dynamic> json) {
    return CreditAgingReportModel(
      success: json['success'],
      message: json['message'],
      count: json['count'],
      totals: Totals.fromJson(json['totals']),
      data: (json['data'] as List)
          .map((e) => CustomerReport.fromJson(e))
          .toList(),
    );
  }
}

class Totals {
  final int totalDebit;
  final int totalCredit;
  final int totalUnderCredit;
  final int totalDue;
  final int totalOutstanding;

  Totals({
    required this.totalDebit,
    required this.totalCredit,
    required this.totalUnderCredit,
    required this.totalDue,
    required this.totalOutstanding,
  });

  factory Totals.fromJson(Map<String, dynamic> json) {
    return Totals(
      totalDebit: json['totalDebit'],
      totalCredit: json['totalCredit'],
      totalUnderCredit: json['totalUnderCredit'],
      totalDue: json['totalDue'],
      totalOutstanding: json['totalOutstanding'],
    );
  }
}

class CustomerReport {
  final int sr;
  final String customerName;
  final List<InvoiceData> invoices;

  CustomerReport({
    required this.sr,
    required this.customerName,
    required this.invoices,
  });

  factory CustomerReport.fromJson(Map<String, dynamic> json) {
    return CustomerReport(
      sr: json['sr'],
      customerName: json['customerName'],
      invoices: (json['invoices'] as List)
          .map((e) => InvoiceData.fromJson(e))
          .toList(),
    );
  }
}

class InvoiceData {
  final String customerName;
  final String salesman;
  final String invoiceNo;
  final String invoiceDate;
  final String deliveryDate;
  final int allowDays;
  final int billDays;
  final int debit;
  final int credit;
  final int underCredit;
  final int due;
  final int outstanding;

  InvoiceData({
    required this.customerName,
    required this.salesman,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.deliveryDate,
    required this.allowDays,
    required this.billDays,
    required this.debit,
    required this.credit,
    required this.underCredit,
    required this.due,
    required this.outstanding,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    return InvoiceData(
      customerName: json['customerName'],
      salesman: json['salesman'],
      invoiceNo: json['invoiceNo'],
      invoiceDate: json['invoiceDate'],
      deliveryDate: json['deliveryDate'],
      allowDays: json['allowDays'],
      billDays: json['billDays'],
      debit: json['debit'],
      credit: json['credit'],
      underCredit: json['underCredit'],
      due: json['due'],
      outstanding: json['outstanding'],
    );
  }
}
