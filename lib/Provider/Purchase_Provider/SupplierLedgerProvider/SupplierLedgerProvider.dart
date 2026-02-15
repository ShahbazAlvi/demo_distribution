import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../../../ApiLink/ApiEndpoint.dart';
import '../../../model/Purchase_Model/SupplierLedgerModel/SupplierLedgerModel.dart';

class SupplierLedgerProvider extends ChangeNotifier {
  bool loading = false;
  List<SupplierLedgerData> ledgerList = [];

  Future<void> fetchSupplierLedger({
    required String supplierId,
    required String fromDate,
    required String toDate,
    required String token, // Authorization header
  }) async {
    loading = true;
    ledgerList.clear();
    notifyListeners();

    try {
      final url = Uri.parse(
          "${ApiEndpoints.baseUrl}/supplier-ledger?supplier=$supplierId&from=$fromDate&to=$toDate");

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = SupplierLedgerDetailModel.fromJson(jsonData);
        ledgerList = data.data;
      } else {
        print("❌ Failed: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching ledger: $e");
    }

    loading = false;
    notifyListeners();
  }
}
