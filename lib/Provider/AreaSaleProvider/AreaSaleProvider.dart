import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/SaleAreaModel/SalesAreaModel.dart';


class SalesAreaProvider with ChangeNotifier {
  List<SalesAreaModel> areas = [];
  bool isLoading = false;
  bool _isCreatingOrder = false;
  bool get isCreatingOrder => _isCreatingOrder;


  final String baseUrl = "${ApiEndpoints.baseUrl}/sales-area";
  String token = ""; // ✅ Add your token if required

  // ✅ Fetch Sales Areas
  Future<void> fetchSalesAreas() async {
    try {
      isLoading = true;
      notifyListeners();



      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        areas = data.map((e) => SalesAreaModel.fromJson(e)).toList();
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Fetch Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // ✅ Delete Sales Area
  Future<void> deleteSalesArea(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/$id"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        areas.removeWhere((area) => area.id == id);
        notifyListeners();
      } else {
        print("Delete Error: ${response.body}");
      }
    } catch (e) {
      print("Delete Exception: $e");
    }
  }

}
