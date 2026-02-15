import 'package:flutter/material.dart';

import '../../../model/Purchase_Model/paymentToSupplierModel/PaymentSupplierModel.dart';
import 'PaymentSupplierServices.dart';


class PaymentToSupplierProvider extends ChangeNotifier {
  List<PaymentToSupplierModel> paymentList = [];
  bool isLoading = false;

  Future<void> loadPayments() async {
    isLoading = true;
    notifyListeners();

    try {
      paymentList = await PaymentToSupplierApi.fetchPayments();
    } catch (e) {
      print("Error loading payments: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deletePayment(String id) async {
    bool success = await PaymentToSupplierApi.deletePayment(id);

    if (success) {
      paymentList.removeWhere((item) => item.id == id);
      notifyListeners();
    }
  }

  Future<void> updatePayment({
    required String id,
    required String supplierId,
    required num amountReceived,
    required String remarks,
  }) async {
    bool success = await PaymentToSupplierApi.updatePayment(
      id: id,
      supplierId: supplierId,
      amountReceived: amountReceived,
      remarks: remarks,
    );

    if (success) {
      int index = paymentList.indexWhere((e) => e.id == id);

      if (index != -1) {
        paymentList[index] = PaymentToSupplierModel(
          id: id,
          receiptId: paymentList[index].receiptId,
          date: paymentList[index].date,
          supplier:
          Supplier(id: supplierId, supplierName: paymentList[index].supplier.supplierName),
          amountReceived: amountReceived,
          newBalance: paymentList[index].newBalance,
          remarks: remarks,
          createdAt: paymentList[index].createdAt,
          updatedAt: paymentList[index].updatedAt,
        );
      }

      notifyListeners();
    }
  }
}
