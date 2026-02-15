import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../ApiLink/ApiEndpoint.dart';
import '../../../model/Purchase_Model/ItemWisePurchaseModel/ItemWisePurchaseModel.dart';


class ItemWisePurchaseProvider with ChangeNotifier {
  List<ItemWisePurchaseData> purchases = [];
  bool isLoading = false;

  final String token = ""; // Put your API token here

  Future<void> fetchItemWisePurchase(String itemName) async {
    isLoading = true;
    notifyListeners();

    try {
      final uri = Uri.parse(
          '${ApiEndpoints.baseUrl}/reports/itemwise?itemName=$itemName');

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final model = ItemWisePurchaseModel.fromJson(body);
        purchases = model.data;
      } else {
        print("API Error: ${response.body}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  num get totalAmount =>
      purchases.fold(0, (sum, item) => sum + item.amount);

  num get totalTotal =>
      purchases.fold(0, (sum, item) => sum + item.total);
}
