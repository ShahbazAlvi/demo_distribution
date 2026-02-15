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

  // ✅ Fetch Orders (with filters)
  Future<void> fetchOrders({String? date, String? salesmanId}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await loadToken(); // ✅ Load token before API call

      String url =
          "${ApiEndpoints.baseUrl}/order-taker/pending";

      Map<String, String> params = {};

      if (date != null && date.isNotEmpty) params['date'] = date;
      if (salesmanId != null && salesmanId.isNotEmpty) {
        params['salesmanId'] = salesmanId;
      }

      if (params.isNotEmpty) {
        url += "?" + Uri(queryParameters: params).query;
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        orderData = SaleInvoiceModel.fromJson(jsonDecode(response.body));
      } else {
        error = "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      error = "Exception: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  // ✅ Create Invoice / Update Invoice
  // Future<void> createOrUpdateInvoice({
  //   required SaleInvoiceData order,
  //   required List<Map<String, dynamic>> products,
  //   required int discount,
  //   required int received,
  //   required DateTime deliveryDate,
  //   required DateTime agingDate,
  // }) async {
  //   try {
  //     isLoading = true;
  //     notifyListeners();
  //
  //     await loadToken();
  //
  //     int totalAmount = products.fold(
  //       0,
  //           (sum, item) => sum + ((item['rate'] as num) * (item['qty'] as num)).toInt(),
  //     );
  //
  //
  //     int receivable = totalAmount - discount;
  //
  //     final body = {
  //       "invoiceDate": DateFormat('yyyy-MM-dd').format(order.date),
  //       "customerId": order.customerId.id,
  //       "salesmanId": order.salesmanId.id,
  //       "orderTakingId": order.id,
  //       "products": products, // ✅ ALL PRODUCTS
  //       "totalAmount": totalAmount,
  //       "receivable": receivable,
  //       "received": received,
  //       "deliveryDate": DateFormat('yyyy-MM-dd').format(deliveryDate),
  //       "agingDate": DateFormat('yyyy-MM-dd').format(agingDate),
  //       "status": "Pending"
  //     };
  //
  //     final response = await http.post(
  //       Uri.parse("https://distribution-backend.vercel.app/api/sales-invoice"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //       body: jsonEncode(body),
  //     );
  //
  //     if (response.statusCode != 200 && response.statusCode != 201) {
  //       error = "Failed: ${response.body}";
  //     }
  //   } catch (e) {
  //     error = e.toString();
  //   }
  //
  //   isLoading = false;
  //   notifyListeners();
  // }
  Future<String?> createOrUpdateInvoice({
    required SaleInvoiceData order,
    required List<Map<String, dynamic>> products,
    required int discount,
    required int received,
    required DateTime deliveryDate,
    required DateTime agingDate,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await loadToken();

      int totalAmount = products.fold(
        0,
            (sum, item) => sum + ((item['rate'] as num) * (item['qty'] as num)).toInt(),
      );

      int receivable = totalAmount - discount;

      final body = {
        "invoiceDate": DateFormat('yyyy-MM-dd').format(order.date),
        "customerId": order.customerId.id,
        "salesmanId": order.salesmanId!.id,
        "orderTakingId": order.id,
        "products": products,
        "totalAmount": totalAmount,
        "receivable": receivable,
        "received": received,
        "deliveryDate": DateFormat('yyyy-MM-dd').format(deliveryDate),
        "agingDate": DateFormat('yyyy-MM-dd').format(agingDate),
        "status": "Pending"
      };

      final response = await http.post(
        Uri.parse("${ApiEndpoints.baseUrl}/sales-invoice"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return data["message"] ?? "Invoice Updated Successfully";
      } else {
        return data["message"] ?? "Failed to update invoice";
      }
    } catch (e) {
      return "Error: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
