import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../ApiLink/ApiEndpoint.dart';
import '../../../model/Purchase_Model/paymentToSupplierModel/PaymentSupplierModel.dart';


class PaymentToSupplierApi {
  static const String baseUrl = "YOUR_BASE_URL"; // example: https://yourapi.com/api

  /// ✅ Fetch all payments
  static Future<List<PaymentToSupplierModel>> fetchPayments() async {
    final response = await http.get(Uri.parse("${ApiEndpoints.baseUrl}/supplier-cash-deposit"));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return (body["data"] as List)
          .map((e) => PaymentToSupplierModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load payments");
    }
  }

  /// ✅ Delete a payment
  static Future<bool> deletePayment(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/deleteSupplierPayment/$id"));
    return response.statusCode == 200;
  }

  /// ✅ Update a payment (supplier, amountReceived, remarks)
  static Future<bool> updatePayment({
    required String id,
    required String supplierId,
    required num amountReceived,
    required String remarks,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/updateSupplierPayment/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "supplier": supplierId,
        "amountReceived": amountReceived,
        "remarks": remarks,
      }),
    );

    return response.statusCode == 200;
  }
}
