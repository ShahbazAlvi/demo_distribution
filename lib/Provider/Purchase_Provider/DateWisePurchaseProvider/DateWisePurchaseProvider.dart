import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../ApiLink/ApiEndpoint.dart';
import '../../../model/Purchase_Model/DateWisePurchaseModel/DateWisePurchaseModel.dart';


class DatewisePurchaseProvider extends ChangeNotifier {
  List<DatewisePurchaseData> _purchases = [];
  bool _loading = false;

  List<DatewisePurchaseData> get purchases => _purchases;
  bool get loading => _loading;

  Future<void> fetchPurchases(String startDate, String endDate, String token) async {
    try {
      _loading = true;
      notifyListeners();

      final url = Uri.parse(
          '${ApiEndpoints.baseUrl}/reports/datewise?startDate=$startDate&endDate=$endDate');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final model = DatewisePurchaseModel.fromJson(data);
        _purchases = model.data;
      } else {
        _purchases = [];
      }
    } catch (e) {
      _purchases = [];
      debugPrint("Error fetching datewise purchases: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  double get totalAmount {
    return _purchases.fold(0, (sum, item) => sum + item.totalAmount);
  }
}
