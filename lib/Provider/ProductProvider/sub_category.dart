import 'dart:convert';

import 'package:demo_distribution/ApiLink/ApiEndpoint.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

import '../../model/ProductModel/Sub_Category_model.dart';

class SubCategory with ChangeNotifier{
  bool _isLoading =false;
  String _error='';
  
  // getx 
bool get isLoading=> _isLoading;
String get error => _error;

  List<SubCategoryModel> subCategories = [];

  Future<void> fetchSubCategories() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/subcategories'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Cache-Control': 'no-cache',   // 👈 IMPORTANT
          'Pragma': 'no-cache',          // 👈 IMPORTANT
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final model = SubCategoryResponse.fromJson(decoded);
        subCategories = model.data.data;
      }
      else if (response.statusCode == 304) {
        print("Server returned 304 → using cached data");
      }
      else {
        _error = "Server error: ${response.statusCode}";
      }
    } catch (e) {
      _error = e.toString();
      print("SubCategory error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}