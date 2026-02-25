class CustomerInvoiceModel {
  final List<CustomerInvoice> invoices;

  CustomerInvoiceModel({required this.invoices});

  factory CustomerInvoiceModel.fromJson(Map<String, dynamic> json) {
    return CustomerInvoiceModel(
      invoices: (json['data']['data'] as List)
          .map((e) => CustomerInvoice.fromJson(e))
          .toList(),
    );
  }
}

class CustomerInvoice {
  final int id;
  final String invNo;
  final double netTotal;
  final String status;

  CustomerInvoice({
    required this.id,
    required this.invNo,
    required this.netTotal,
    required this.status,
  });

  factory CustomerInvoice.fromJson(Map<String, dynamic> json) {
    return CustomerInvoice(
      id: json['id'],
      invNo: json['inv_no'],
      netTotal: double.parse(json['net_total']),
      status: json['status'],
    );
  }
}