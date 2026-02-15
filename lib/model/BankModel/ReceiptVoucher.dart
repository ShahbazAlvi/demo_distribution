class ReceiptVoucher {
  final String id;
  final DateTime date;
  final String receiptId;
  final Bank? bank;
  final Salesman? salesman;
  final int amountReceived;
  final String remarks;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReceiptVoucher({
    required this.id,
    required this.date,
    required this.receiptId,
    this.bank,
    this.salesman,
    required this.amountReceived,
    required this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReceiptVoucher.fromJson(Map<String, dynamic> json) {
    return ReceiptVoucher(
      id: json['_id'] ?? "",
      date: DateTime.parse(json['date']),
      receiptId: json['receiptId'] ?? "",
      bank: json['bank'] != null ? Bank.fromJson(json['bank']) : null,
      salesman: json['salesman'] != null ? Salesman.fromJson(json['salesman']) : null,
      amountReceived: json['amountReceived'] ?? 0,
      remarks: json['remarks'] ?? "",
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "date": date.toIso8601String(),
      "receiptId": receiptId,
      "bank": bank?.toJson(),
      "salesman": salesman?.toJson(),
      "amountReceived": amountReceived,
      "remarks": remarks,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

class Bank {
  final String id;
  final String bankName;
  final int balance;

  Bank({
    required this.id,
    required this.bankName,
    required this.balance,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['_id'] ?? "",
      bankName: json['bankName'] ?? "",
      balance: json['balance'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "bankName": bankName,
      "balance": balance,
    };
  }
}

class Salesman {
  final String id;
  final String employeeName;
  final int recoveryBalance;

  Salesman({
    required this.id,
    required this.employeeName,
    required this.recoveryBalance,
  });

  factory Salesman.fromJson(Map<String, dynamic> json) {
    return Salesman(
      id: json['_id'] ?? "",
      employeeName: json['employeeName'] ?? "",
      recoveryBalance: json['recoveryBalance'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "employeeName": employeeName,
      "recoveryBalance": recoveryBalance,
    };
  }
}
