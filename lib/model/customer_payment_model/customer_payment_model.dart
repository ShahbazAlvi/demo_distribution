class CustomerPaymentModel {
  final bool success;
  final String message;
  final CustomerPaymentData data;

  CustomerPaymentModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CustomerPaymentModel.fromJson(Map<String, dynamic> json) {
    return CustomerPaymentModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: CustomerPaymentData.fromJson(json['data'] ?? {}),
    );
  }
}

class CustomerPaymentData {
  final List<CustomerPayment> payments;

  CustomerPaymentData({required this.payments});

  factory CustomerPaymentData.fromJson(Map<String, dynamic> json) {
    return CustomerPaymentData(
      payments: (json['data'] as List<dynamic>? ?? [])
          .map((e) => CustomerPayment.fromJson(e))
          .toList(),
    );
  }
}

class CustomerPayment {
  final int id;
  final String paymentNo;
  final DateTime paymentDate;
  final int customerId;
  final String customerName;
  final int invoiceId;
  final String invoiceType;
  final String invoiceNo;
  final String paymentMode;
  final int? bankId;
  final String? bankName;
  final double invoiceAmount;
  final double paymentAmount;
  final String status;
  final String? remarks;
  final DateTime createdAt;
  final DateTime updatedAt;

  CustomerPayment({
    required this.id,
    required this.paymentNo,
    required this.paymentDate,
    required this.customerId,
    required this.customerName,
    required this.invoiceId,
    required this.invoiceType,
    required this.invoiceNo,
    required this.paymentMode,
    this.bankId,
    this.bankName,
    required this.invoiceAmount,
    required this.paymentAmount,
    required this.status,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerPayment.fromJson(Map<String, dynamic> json) {
    return CustomerPayment(
      id: json['id'] ?? 0,
      paymentNo: json['payment_no'] ?? '',
      paymentDate: DateTime.parse(json['payment_date']),
      customerId: json['customer_id'] ?? 0,
      customerName: json['customer_name'] ?? '',
      invoiceId: json['invoice_id'] ?? 0,
      invoiceType: json['invoice_type'] ?? '',
      invoiceNo: json['invoice_no'] ?? '',
      paymentMode: json['payment_mode'] ?? '',
      bankId: json['bank_id'],
      bankName: json['bank_name'],
      invoiceAmount: double.tryParse(json['invoice_amount'].toString()) ?? 0.0,
      paymentAmount: double.tryParse(json['payment_amount'].toString()) ?? 0.0,
      status: json['status'] ?? '',
      remarks: json['remarks'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}