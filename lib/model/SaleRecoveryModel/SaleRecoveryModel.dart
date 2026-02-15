// class RecoverySaleModel {
//   bool? success;
//   String? message;
//   int? count;
//   List<RecoverySaleData>? data;
//
//   RecoverySaleModel({
//     this.success,
//     this.message,
//     this.count,
//     this.data,
//   });
//
//   factory RecoverySaleModel.fromJson(Map<String, dynamic> json) {
//     return RecoverySaleModel(
//       success: json['success'],
//       message: json['message'],
//       count: json['count'],
//       data: json['data'] != null
//           ? List<RecoverySaleData>.from(
//           json['data'].map((x) => RecoverySaleData.fromJson(x)))
//           : [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "success": success,
//       "message": message,
//       "count": count,
//       "data": data != null
//           ? List<dynamic>.from(data!.map((x) => x.toJson()))
//           : [],
//     };
//   }
// }
//
// class RecoverySaleData {
//   int? sr;
//   String? date;
//   String? id;
//   String? customer;
//   String? salesman;
//   num? total;
//   num? received;
//   num? balance;
//   int? billDays;
//   int? dueDays;
//   String? recoveryDate;
//
//   RecoverySaleData({
//     this.sr,
//     this.date,
//     this.id,
//     this.customer,
//     this.salesman,
//     this.total,
//     this.received,
//     this.balance,
//     this.billDays,
//     this.dueDays,
//     this.recoveryDate,
//   });
//
//   factory RecoverySaleData.fromJson(Map<String, dynamic> json) {
//     return RecoverySaleData(
//       sr: json['sr'],
//       date: json['date'],
//       id: json['id'],
//       customer: json['customer'],
//       salesman: json['salesman'],
//       total: json['total'],
//       received: json['received'],
//       balance: json['balance'],
//       billDays: json['billDays'],
//       dueDays: json['dueDays'],
//       recoveryDate: json['recoveryDate'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "sr": sr,
//       "date": date,
//       "id": id,
//       "customer": customer,
//       "salesman": salesman,
//       "total": total,
//       "received": received,
//       "balance": balance,
//       "billDays": billDays,
//       "dueDays": dueDays,
//       "recoveryDate": recoveryDate,
//     };
//   }
// }
class RecoveryReport {
  bool? success;
  int? count;
  String? date;
  List<RecoveryInvoice>? data;

  RecoveryReport({
    this.success,
    this.count,
    this.date,
    this.data,
  });

  factory RecoveryReport.fromJson(Map<String, dynamic> json) {
    return RecoveryReport(
      success: json['success'],
      count: json['count'],
      date: json['date'],
      data: json['data'] != null
          ? List<RecoveryInvoice>.from(
          json['data'].map((x) => RecoveryInvoice.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "count": count,
      "date": date,
      "data": data != null
          ? List<dynamic>.from(data!.map((x) => x.toJson()))
          : [],
    };
  }
}

class RecoveryInvoice {
  String? invoiceId;
  String? invoiceNo;
  String? invoiceDate;
  String? customer;
  String? salesman;
  int? billDays;
  int? overDays;
  String? agingDate;
  String? status;
  List<InvoiceItem>? items;
  num? totalPrice;
  num? receivable;
  num? received;
  num? balance;
  String? recoveryId;
  String? recoveryNo;
  num? recoveryAmount;

  RecoveryInvoice({
    this.invoiceId,
    this.invoiceNo,
    this.invoiceDate,
    this.customer,
    this.salesman,
    this.billDays,
    this.overDays,
    this.agingDate,
    this.status,
    this.items,
    this.totalPrice,
    this.receivable,
    this.received,
    this.balance,
    this.recoveryId,
    this.recoveryNo,
    this.recoveryAmount,
  });

  factory RecoveryInvoice.fromJson(Map<String, dynamic> json) {
    return RecoveryInvoice(
      invoiceId: json['invoiceId'],
      invoiceNo: json['invoiceNo'],
      invoiceDate: json['invoiceDate'],
      customer: json['customer'],
      salesman: json['salesman'],
      billDays: json['billDays'],
      overDays: json['overDays'],
      agingDate: json['agingDate'],
      status: json['status'],
      items: json['items'] != null
          ? List<InvoiceItem>.from(
          json['items'].map((x) => InvoiceItem.fromJson(x)))
          : [],
      totalPrice: json['totalPrice'],
      receivable: json['receivable'],
      received: json['received'],
      balance: json['balance'],
      recoveryId: json['recoveryId'],
      recoveryNo: json['recoveryNo'],
      recoveryAmount: json['recoveryAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "invoiceId": invoiceId,
      "invoiceNo": invoiceNo,
      "invoiceDate": invoiceDate,
      "customer": customer,
      "salesman": salesman,
      "billDays": billDays,
      "overDays": overDays,
      "agingDate": agingDate,
      "status": status,
      "items": items != null
          ? List<dynamic>.from(items!.map((x) => x.toJson()))
          : [],
      "totalPrice": totalPrice,
      "receivable": receivable,
      "received": received,
      "balance": balance,
      "recoveryId": recoveryId,
      "recoveryNo": recoveryNo,
      "recoveryAmount": recoveryAmount,
    };
  }
}

class InvoiceItem {
  int? sr;
  String? item;
  num? rate;
  num? qty;
  num? total;

  InvoiceItem({
    this.sr,
    this.item,
    this.rate,
    this.qty,
    this.total,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      sr: json['sr'],
      item: json['item'],
      rate: json['rate'],
      qty: json['qty'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sr": sr,
      "item": item,
      "rate": rate,
      "qty": qty,
      "total": total,
    };
  }
}
