import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/BankModel/PaymentVoucher.dart';

class PaymentVoucherProvider with ChangeNotifier {
  PaymentVoucherModel? paymentData;
  bool isLoading = false;
  bool isSubmitting = false;

  // ------------------------- GET TOKEN -------------------------
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<void> fetchPayments() async {
    isLoading = true;
    notifyListeners();

    var url = Uri.parse("${ApiEndpoints.baseUrl}/payment-vouchers");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      paymentData =
          PaymentVoucherModel.fromJson(json.decode(response.body));
    }

    isLoading = false;
    notifyListeners();
  }

  // DELETE PAYMENT
  Future<bool> deletePayment(String id) async {
    String? token = await _getToken();  // get token from SharedPreferences
    if (token == null) return false;

    final url = Uri.parse(
        "${ApiEndpoints.baseUrl}/payment-vouchers/$id");

    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      await fetchPayments();  // refresh list
      return true;
    }

    print("Delete failed: ${response.statusCode} ${response.body}");
    return false;
  }




  Future<bool> addPayment({
    required String date,
    required String paymentId,
    required String bankId,
    required String supplierId,
    required int amount,
    required String remarks,
  }) async {
    isSubmitting = true;
    notifyListeners();

    String? token = await _getToken();

    var url = Uri.parse("${ApiEndpoints.baseUrl}/payment-vouchers");

    final body = {
      "date": date,
      "paymentId": paymentId,
      "bank": bankId,
      "supplier": supplierId,
      "amountPaid": amount,
      "remarks": remarks
    };

    final response = await http.post(
      url,
      body: json.encode(body),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    isSubmitting = false;
    notifyListeners();

    if (response.statusCode == 201 || response.statusCode == 200) {
      fetchPayments();
      return true;
    }

    return false;
  }

  // Future<bool> updatePayment({
  //   required String id,           // document ID
  //   required String bankId,
  //   required String supplierId,
  //   required double amount,
  //   required String remarks,
  // }) async {
  //   isSubmitting = true;
  //   notifyListeners();
  //
  //   String? token = await _getToken();
  //   if (token == null) return false;
  //
  //   //final url = Uri.parse("${ApiEndpoints.baseUrl}/payment-vouchers/$paymentId");
  //   final url = Uri.parse("${ApiEndpoints.baseUrl}/payment-vouchers/$id");
  //
  //
  //   final body = {
  //     "bank": bankId,
  //     "supplier": supplierId,
  //     "amountPaid": amount,
  //     "remarks": remarks,
  //   };
  //
  //   final response = await http.put(
  //     url,
  //     body: json.encode(body),
  //     headers: {
  //       "Authorization": "Bearer $token",
  //       "Content-Type": "application/json",
  //     },
  //   );
  //
  //   isSubmitting = false;
  //   notifyListeners();
  //
  //   if (response.statusCode == 200) {
  //     await fetchPayments(); // refresh list
  //     return true;
  //   }
  //
  //   print("Update failed: ${response.statusCode} ${response.body}");
  //   return false;
  // }
  Future<bool> updatePayment({
    required String id, // MONGO DOCUMENT ID
    required String bankId,
    required String supplierId,
    required double amount,
    required String remarks,
  }) async {
    isSubmitting = true;
    notifyListeners();

    String? token = await _getToken();
    if (token == null) return false;

    final url = Uri.parse("${ApiEndpoints.baseUrl}/payment-vouchers/$id");

    final body = {
      "bank": bankId,
      "supplier": supplierId,
      "amountPaid": amount,
      "remarks": remarks,
    };

    final response = await http.put(
      url,
      body: json.encode(body),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    isSubmitting = false;
    notifyListeners();

    if (response.statusCode == 200) {
      await fetchPayments();
      return true;
    }

    print("Update failed: ${response.statusCode} ${response.body}");
    return false;
  }
}
