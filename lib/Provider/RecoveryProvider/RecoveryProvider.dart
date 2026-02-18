import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/SaleRecoveryModel/SaleRecoveryModel.dart';



class RecoveryProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isUpdating = false;

  RecoveryReport? recoveryReport;

  RecoveryReport? recoveryData;
  String token = "";

  String baseUrl = "${ApiEndpoints.baseUrl}";

  /// ✅ Load Token Automatically
  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token") ?? "";
  }

  /// ✅ Fetch Recovery Report
  Future<void> fetchRecoveryReport() async {
    await loadToken(); // ✅ Auto load token

    try {
      isLoading = true;
      notifyListeners();

      final url = Uri.parse(
          //"$baseUrl/sales-invoice/recovery-report?salesmanId=$salesmanId&recoveryDate=$date");
        "$baseUrl/recovery-vouchers");

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = json.decode(response.body);
        recoveryReport = RecoveryReport.fromJson(jsonData);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Update Received Amount (PATCH)




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


  Future<String?> addRecovery({
    required String orderId,
    required String salesmanId,
    required String customerId,
    required String bankId,
    required String amount,
    required String recoveryDate, // Pass date in "YYYY-MM-DD"
    required String mode,         // e.g., "BANK"
  }) async {
    await loadToken();

    try {
      isLoading = true;
      notifyListeners();

      final url = Uri.parse("$baseUrl/recovery-vouchers");

      final body = jsonEncode({
        "rv_no": orderId,
        "salesman_id": int.parse(salesmanId),
        "customer_id": int.parse(customerId),
        "bank_id": int.parse(bankId),
        "amount": double.parse(amount),
        "recovery_date": recoveryDate,
        "mode": mode,
        "status": "DRAFT",
      });

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Add Recovery Response: ${response.body}");

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return jsonData["message"] ?? "Recovery added successfully";
      } else {
        return "Failed to add recovery: ${response.statusCode}";
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return "Error: $e";
    }
  }


}
