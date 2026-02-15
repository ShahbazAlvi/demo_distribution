import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/DailySaleReport/DailySaleReport.dart';

class DailySaleReportProvider extends ChangeNotifier {
  bool isLoading = false;
  DailySaleReportModel? reportData;

  String baseUrl = "${ApiEndpoints.baseUrl}";

  /// 🔥 Fetch Daily Sales Report
  Future<void> fetchDailyReport({
    required String salesmanId,
    required String date,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final url = "$baseUrl/salesman-report/$salesmanId?date=$date";

      print("📡 API URL: $url");

      final response = await http.get(Uri.parse(url));

      print("📥 Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        reportData = DailySaleReportModel.fromJson(jsonBody);
      } else {
        reportData = null;
      }
    } catch (e) {
      print("❌ Error: $e");
      reportData = null;
    }

    isLoading = false;
    notifyListeners();
  }
}
