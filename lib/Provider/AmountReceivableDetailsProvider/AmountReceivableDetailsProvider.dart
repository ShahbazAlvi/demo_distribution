import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/AmountReceivableDetailsModel/AmountReceivableDetailsModel.dart';



class ReceivableProvider extends ChangeNotifier {

  AmountReceivableModel? receivableModel;
  bool isLoading = false;
  bool withZero = true;
  String searchText = '';

  Future<void> fetchReceivables() async {
    try {
      isLoading = true;
      notifyListeners();

      final url = Uri.parse(
        '${ApiEndpoints.baseUrl}/customer-ledger/receivables?withZero=$withZero',
      );

      final headers = {
        'Authorization': 'Bearer YOUR_TOKEN_HERE',
        'Content-Type': 'text/plain',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        receivableModel =
            AmountReceivableModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      print("Error fetching receivables: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  List<ReceivableData> get filteredList {
    if (receivableModel == null) return [];

    if (searchText.isEmpty) {
      return receivableModel!.data;
    }

    return receivableModel!.data
        .where((e) =>
        e.customer.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  void updateSearch(String value) {
    searchText = value;
    notifyListeners();
  }

  void updateWithZero(bool value) {
    withZero = value;
    fetchReceivables();
  }
}
