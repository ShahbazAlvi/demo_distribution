import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/AmountReceivableDetailsModel/AmountReceivableDetailsModel.dart';

class ReceivableProvider extends ChangeNotifier {
  AmountReceivableModel? receivableModel;

  bool isLoading = false;
  bool withZero = true;
  String searchText = '';
  String token = "";

  /// 🔐 Load token from SharedPreferences
  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token") ?? "";
  }

  /// 📡 Fetch Receivables
  Future<void> fetchReceivables() async {
    await loadToken();

    try {
      isLoading = true;
      notifyListeners();

      final url = Uri.parse(
        "${ApiEndpoints.baseUrl}/amount-receivables?withZero=$withZero",
      );

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        receivableModel =
            AmountReceivableModel.fromJson(json.decode(response.body));
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching receivables: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔎 Filter list by search
  List<ReceivableData> get filteredList {
    if (receivableModel == null) return [];

    final list = receivableModel!.data.invoices;

    return list.where((e) {
      final matchSearch = e.customerName
          .toLowerCase()
          .contains(searchText.toLowerCase());

      final matchZero = withZero ? true : e.balance > 0;

      return matchSearch && matchZero;
    }).toList();
  }



  void updateSearch(String value) {
    searchText = value;
    notifyListeners();
  }

  /// 🔁 Toggle With Zero
  void updateWithZero(bool value) {
    withZero = value;
    fetchReceivables();
  }
}
