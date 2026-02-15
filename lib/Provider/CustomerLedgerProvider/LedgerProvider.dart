import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/CustomersLedger/CustomerLedger.dart';
import 'LedgerServices.dart';

class CustomerLedgerProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  CustomerLedgerDetailsModel? ledgerData;

  final _service = CustomerLedgerService();

  Future<void> getLedger({
    required String customerId,
    String? fromDate,
    String? toDate,
  }) async {
    isLoading = true;
    error = null;
    ledgerData = null;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      ledgerData = await _service.fetchCustomerLedger(
        customerId: customerId,
        fromDate: fromDate,
        toDate: toDate,
        token: token,
      );
    } catch (e) {
      error = "Failed to fetch ledger";
    }

    isLoading = false;
    notifyListeners();
  }

}
