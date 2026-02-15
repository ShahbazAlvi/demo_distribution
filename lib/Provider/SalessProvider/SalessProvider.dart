import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/SalessModel/SalessModel.dart';


class SalesProvider extends ChangeNotifier {
  bool isLoading = false;
  SalesModel? salesData;

  Future<void> fetchSalesReport(String salesmanId) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("https://call-logs-backend.vercel.app/api/salesman-report?salesmanId=$salesmanId"),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        salesData = SalesModel.fromJson(jsonData);
      } else {
        salesData = null;
      }
    } catch (e) {
      print("❌ Error fetching sales report: $e");
      salesData = null;
    }

    isLoading = false;
    notifyListeners();
  }
}
