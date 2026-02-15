import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/OrderTakingModel/OrderTakingModel.dart';
import 'package:http/http.dart'as http;

class OrderTakingProvider with ChangeNotifier{
  bool _isFetched = false;
  bool _isLoading = false;
  OrderTakingModel? _orderData;
  String? _error;
  bool _isCreatingOrder = false;
  bool get isCreatingOrder => _isCreatingOrder;


  // gets

  bool get isLoading => _isLoading;
  OrderTakingModel? get orderData => _orderData;
  String? get error => _error;


  Future<void> FetchOrderTaking() async {
    if (_isFetched) return;

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        _error = "Token not found. Please login again.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/sales-orders'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "x-company-id": "2",
          "Cache-Control": "no-cache", // prevents 304 cache response
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _orderData = OrderTakingModel.fromJson(data);
        _isFetched = true;
        _error = null;
      }
      else if (response.statusCode == 304) {
        debugPrint("Data not modified (304)");
      }
      else {
        _error = "Failed to load orders (${response.statusCode})";
        debugPrint(response.body);
      }
    } catch (e) {
      _error = "Error fetching orders: $e";
    }

    _isLoading = false;
    notifyListeners();
  }


  Future<void> createOrder({
    required String orderId,
    required String salesmanId,
    required String customerId,
    required List<Map<String, dynamic>> products,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        _error = "Token not found!";
        _isLoading = false;
        notifyListeners();
        return;
      }

      final url = Uri.parse('${ApiEndpoints.baseUrl}/sales-order');

      final body = jsonEncode({
        "orderId": orderId,
        "salesmanId": salesmanId,
        "customerId": customerId,
        "products": products.map((item) => {
          "itemId": item["product"].id,
          "qty": item["qty"],
          "rate": item["price"]
        }).toList(),
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,

      );
      print(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("✅ Order created: ${response.body}");
        _isFetched = false;
        await FetchOrderTaking();
      } else {
        _error = "❌ Failed: ${response.statusCode} - ${response.body}";
        print(_error);
      }
    } catch (e) {
      _error = "Error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> deleteOrder(String orderId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final url = Uri.parse("${ApiEndpoints.baseUrl}/order-taker/$orderId");

      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Order deleted successfully");

        _isFetched = false; // re-fetch
        await FetchOrderTaking();
      } else {
        _error = "Failed to delete: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      _error = "Error deleting: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrder(String orderId, Map<String, dynamic> body) async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final url = Uri.parse("${ApiEndpoints.baseUrl}/order-taker/$orderId");

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Order updated successfully");

        _isFetched = false;
        await FetchOrderTaking();
      } else {
        _error = "Failed to update: ${response.statusCode}";
      }
    } catch (e) {
      _error = "Error updating: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }




}