import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/SaleRecoveryModel/SaleRecoveryModel.dart';



class RecoveryProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isUpdating = false;

  RecoveryReport? recoveryData;
  String token = "";

  String baseUrl = "${ApiEndpoints.baseUrl}";

  /// ✅ Load Token Automatically
  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token") ?? "";
  }

  /// ✅ Fetch Recovery Report
  Future<void> fetchRecoveryReport(String salesmanId, String date) async {
    await loadToken(); // ✅ Auto load token

    try {
      isLoading = true;
      notifyListeners();

      final url = Uri.parse(
          //"$baseUrl/sales-invoice/recovery-report?salesmanId=$salesmanId&recoveryDate=$date");
        "$baseUrl/sales-invoice/recovery/$salesmanId?date=$date");

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        recoveryData = RecoveryReport.fromJson(jsonDecode(response.body));
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Update Received Amount (PATCH)

  // Future<bool> updateReceivedAmount(String invoiceId, String receivedAmount) async {
  //   await loadToken();
  //
  //   if (token.isEmpty) {
  //     print("Token missing!");
  //     return false;
  //   }
  //
  //   try {
  //     isUpdating = true;
  //     notifyListeners();
  //
  //     var url = Uri.parse("$baseUrl/recovery"); // POST to /recovery
  //
  //     var body = jsonEncode({
  //       "invoiceId": invoiceId,
  //       "amount": double.parse(receivedAmount),
  //     });
  //
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //       body: body,
  //     );
  //
  //     print("Response status: ${response.statusCode}");
  //     print("Response body: ${response.body}");
  //
  //     isUpdating = false;
  //     notifyListeners();
  //
  //     return response.statusCode == 200;
  //   } catch (e) {
  //     isUpdating = false;
  //     notifyListeners();
  //     print("Error updating recovery: $e");
  //     return false;
  //   }
  // }


  Future<String?> updateReceivedAmount(String invoiceId, String receivedAmount) async {
    await loadToken();

    try {
      isUpdating = true;
      notifyListeners();

      var url = Uri.parse("$baseUrl/recovery");

      var body = jsonEncode({
        "invoiceId": invoiceId,
        "amount": double.parse(receivedAmount),
      });

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response body: ${response.body}");

      isUpdating = false;
      notifyListeners();

      if (response.statusCode == 201 || response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json["message"]; // <-- return success message
      }

      return null;
    } catch (e) {
      isUpdating = false;
      notifyListeners();
      return null;
    }
  }

}
