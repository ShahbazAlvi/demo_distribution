import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

      // ✅ Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      final url =
          "$baseUrl/daily-sales?salesman_id=$salesmanId&date_from=$date&date_to=$date";

      print("📡 API URL: $url");
      print("🔑 Token: $token");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "x-company-id": "2", // agar API required ho
        },
      );

      print("📥 Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        print(jsonBody);
        reportData = DailySaleReportModel.fromJson(jsonBody);
      } else {
        reportData = null;
        print("❌ Failed: ${response.statusCode} ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Error: $e");
      reportData = null;
    }

    isLoading = false;
    notifyListeners();
  }
}
