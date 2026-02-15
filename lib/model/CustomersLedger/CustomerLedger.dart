class CustomerLedgerDetailsModel {
  final bool success;
  final String message;
  final int count;
  final List<CustomerLedgerEntry> data;

  CustomerLedgerDetailsModel({
    required this.success,
    required this.message,
    required this.count,
    required this.data,
  });

  factory CustomerLedgerDetailsModel.fromJson(Map<String, dynamic> json) {
    return CustomerLedgerDetailsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CustomerLedgerEntry.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class CustomerLedgerEntry {
  final int sr;
  final String id;
  final String date;
  final String customerName;
  final String description;
  final String paid;
  final String received;
  final String balance;

  CustomerLedgerEntry({
    required this.sr,
    required this.id,
    required this.date,
    required this.customerName,
    required this.description,
    required this.paid,
    required this.received,
    required this.balance,
  });

  factory CustomerLedgerEntry.fromJson(Map<String, dynamic> json) {
    return CustomerLedgerEntry(
      sr: json['SR'] ?? 0,
      id: json['ID'] ?? "",
      date: json['Date'] ?? "",
      customerName: json['CustomerName'] ?? "",
      description: json['Description'] ?? "",
      paid: json['Paid'] ?? "0.00",
      received: json['Received'] ?? "0.00",
      balance: json['Balance'] ?? "0.00",
    );
  }
}
