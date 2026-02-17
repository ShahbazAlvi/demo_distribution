import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/SaleInvoiceModel/SaleInvocieModel.dart';

class SaleInvoicesProvider with ChangeNotifier {
  bool isLoading = false;
  String? error;
  SaleInvoiceModel? orderData;

  String? token;

  // ✅ Load token from SharedPreferences
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
  }





  Future<void> fetchOrders({String? date, String? salesmanId}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await loadToken();

      if (token == null) {
        error = "Token not found";
        return;
      }

      String url = "${ApiEndpoints.baseUrl}/sales-invoices-notax";

      Map<String, String> params = {};
      if (date != null && date.isNotEmpty) params['date'] = date;
      if (salesmanId != null && salesmanId.isNotEmpty) {
        params['salesmanId'] = salesmanId;
      }

      if (params.isNotEmpty) {
        url += "?" + Uri(queryParameters: params).query;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "x-company-id": "2",
          "Cache-Control": "no-cache",
          "Pragma": "no-cache",
        },
      );

      if (response.statusCode == 200) {
        orderData = SaleInvoiceModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode != 304) {
        error = "Server Error: ${response.statusCode}";
      }

    } catch (e) {
      error = "Exception: $e";
    }

    isLoading = false;
    notifyListeners();
  }









}
