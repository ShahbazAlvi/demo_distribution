  import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../ApiLink/ApiEndpoint.dart';
import '../../../model/PayableAmountModel/PayaAmountModel.dart';


class PayableAmountProvider extends ChangeNotifier {
  bool isLoading = false;
  List<PayableAmountModel> payables = [];
  double totalPayable = 0.0;

  Future<void> fetchPayables({bool withZero = true}) async {
    isLoading = true;
    notifyListeners();

    final url =
        "${ApiEndpoints.baseUrl}/supplier-ledger/payables?withZero=$withZero";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final parsed = PayableAmountResponse.fromJson(data);
        payables = parsed.data;
        totalPayable = parsed.totalPayable;
      }
    } catch (e) {
      debugPrint("Error fetching payables: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
