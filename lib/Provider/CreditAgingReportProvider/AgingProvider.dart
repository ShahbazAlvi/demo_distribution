import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/CreditAgingReport/AgingReportModel.dart';



class CreditAgingProvider with ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  CreditAgingReportModel? report;

  Future<void> fetchCreditAging() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final url = Uri.parse(
          "${ApiEndpoints.baseUrl}/credit-aging");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "text/plain",
        },
      );

      if (response.statusCode == 200) {
        report = CreditAgingReportModel.fromJson(json.decode(response.body));
      } else {
        errorMessage = "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = "Error: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
