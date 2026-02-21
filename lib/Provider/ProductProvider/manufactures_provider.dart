import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/ProductModel/manufactures_Model.dart';

class ManufacturesProvider with ChangeNotifier {
  bool _isLoading=false;
  bool get isLoading=> _isLoading;

  List<ManufacturesModel> manufactures = [];

  Future<void> fetchManufactures() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}/manufacturers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Cache-Control': 'no-cache',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final model = ManufacturesResponse.fromJson(decoded);
      manufactures = model.data.data;
    }

    _isLoading = false;
    notifyListeners();
  }
}