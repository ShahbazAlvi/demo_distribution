import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../ApiLink/ApiEndpoint.dart';
import '../../../model/Purchase_Model/SupplierWisePurchaseModel/SupplierWisePurchaseModel.dart';


class SupplierwisePurchaseProvider extends ChangeNotifier {
  bool loading = false;
  List<SupplierwisePurchaseData> purchaseList = [];

  double totalAmount = 0.0;
  double totalPayable = 0.0;
  double totalDiscount = 0.0;

  Future<void> fetchSupplierwiseData(String supplierId) async {
    loading = true;
    notifyListeners();

    try {
      final url = Uri.parse(
          '${ApiEndpoints.baseUrl}/reports/supplierwise?supplierId=$supplierId');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer YOUR_TOKEN_HERE',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final model = SupplierwisePurchaseModel.fromJson(data);

        purchaseList = model.data;
        totalAmount = purchaseList.fold(0, (sum, e) => sum + e.total);
        totalPayable = purchaseList.fold(0, (sum, e) => sum + e.payable);
        totalDiscount = purchaseList.fold(0, (sum, e) => sum + e.discount);
      } else {
        purchaseList = [];
      }
    } catch (e) {
      purchaseList = [];
    }

    loading = false;
    notifyListeners();
  }
}
