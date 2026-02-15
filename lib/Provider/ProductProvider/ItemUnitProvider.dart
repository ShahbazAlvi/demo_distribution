import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/ProductModel/ItemUnitModel.dart';


class ItemUnitProvider extends ChangeNotifier {
  List<ItemUnitModel> units = [];
  bool loading = false;


  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Adjust key as per your storage
  }

  Future<void> fetchItemUnits() async {
    loading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/item-unit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer your_token_here', // optional if required
        },
      );

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        units = data.map((e) => ItemUnitModel.fromJson(e)).toList();
      } else {
        debugPrint("Failed to load item units: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error fetching item units: $e");
    }

    loading = false;
    notifyListeners();
  }

  Future<bool> deleteItemUnit(String id) async {
    final token = await _getToken();

    if (token == null) {
      debugPrint("No token found");
      return false;
    }

    try {
      final response = await http.delete(
        Uri.parse('${ApiEndpoints.baseUrl}/item-unit/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        units.removeWhere((u) => u.id == id);
        notifyListeners();
        return true;
      } else {
        debugPrint('Delete failed: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint("Error deleting unit: $e");
      return false;
    }
  }
  Future<void> addItemUnit({
    required String unitName,
    required String description,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/item-unit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "unitName": unitName,
          "description": description,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh the list after adding
        await fetchItemUnits();
      } else {
        debugPrint('Failed to add unit: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error adding unit: $e');
    }
  }
  // Add this method to your ItemUnitProvider class
  Future<void> updateItemUnit(String id, String unitName, String description, String token) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}/item-unit/$id');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'unitName': unitName,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        // Update the local list
        final index = units.indexWhere((unit) => unit.id == id);
        if (index != -1) {
          units[index] = ItemUnitModel(
            id: id,
            unitName: unitName,
            description: description,
            // Add other fields if needed
          );
          notifyListeners();
        }
      } else {
        debugPrint("Update failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error updating item unit: $e");
    }
  }

}
