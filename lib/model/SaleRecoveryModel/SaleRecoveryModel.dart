class RecoveryReport {
  final bool success;
  final String message;
  final RecoveryReportData data;

  RecoveryReport({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RecoveryReport.fromJson(Map<String, dynamic> json) {
    return RecoveryReport(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: RecoveryReportData.fromJson(json['data'] ?? {}),
    );
  }
}

class RecoveryReportData {
  final List<RecoveryVoucher> vouchers;

  RecoveryReportData({required this.vouchers});

  factory RecoveryReportData.fromJson(Map<String, dynamic> json) {
    return RecoveryReportData(
      vouchers: ((json['data']?['data'] ?? []) as List)
          .map((e) => RecoveryVoucher.fromJson(e))
          .toList(),
    );
  }

}

class RecoveryVoucher {
  final int id;
  final String rvNo;
  final int customerId;
  final String customerName;
  final int salesmanId;
  final String salesmanName;
  final DateTime recoveryDate;
  final String mode;
  final int? bankId;
  final String? bankName;
  final String? bankBranch;
  final double amount;
  final String? remarks;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  RecoveryVoucher({
    required this.id,
    required this.rvNo,
    required this.customerId,
    required this.customerName,
    required this.salesmanId,
    required this.salesmanName,
    required this.recoveryDate,
    required this.mode,
    this.bankId,
    this.bankName,
    this.bankBranch,
    required this.amount,
    this.remarks,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecoveryVoucher.fromJson(Map<String, dynamic> json) {
    return RecoveryVoucher(
      id: json['id'] ?? 0,
      rvNo: json['rv_no'] ?? '',
      customerId: json['customer_id'] ?? 0,
      customerName: json['customer_name'] ?? '',
      salesmanId: json['salesman_id'] ?? 0,
      salesmanName: json['salesman_name'] ?? '',
      recoveryDate: DateTime.parse(json['recovery_date']),
      mode: json['mode'] ?? '',
      bankId: json['bank_id'],
      bankName: json['bank_name'],
      bankBranch: json['bank_branch'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      remarks: json['remarks'],
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
