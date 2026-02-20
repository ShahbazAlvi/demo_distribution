import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/ProductModel/ItemTypeModel.dart';


class ItemTypeProvider extends ChangeNotifier {
  List<ItemTypeModel> _itemTypes = [];
  bool loading = false;

  List<ItemTypeModel> get itemTypes => _itemTypes;


  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Adjust key as per your storage
  }

  Future<void> fetchItemTypes() async {
    loading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final url = Uri.parse('${ApiEndpoints.baseUrl}/item-types');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // ✅ correct nested list extraction
        final List list = jsonData['data']['data'];

        _itemTypes = list
            .map((e) => ItemTypeModel.fromJson(e))
            .toList();

      } else {
        debugPrint("Failed to load item types: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching item types: $e");
    }

    loading = false;
    notifyListeners();
  }

  Future<void> deleteItemType(String id) async {
    final url =
    Uri.parse('${ApiEndpoints.baseUrl}/item-type/$id');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        _itemTypes.removeWhere((item) => item.id == id);
        notifyListeners();
      } else {
        debugPrint("Failed to delete item: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Delete error: $e");
    }
  }
  Future<void> addItemType({
    required String categoryId,
    required String itemTypeName,
    required String token,
  }) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}/item-type');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'categoryId': categoryId,
          'itemTypeName': itemTypeName,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchItemTypes(); // Refresh list
        debugPrint('Item type added successfully');
      } else {
        debugPrint('Failed to add item type: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error adding item type: $e');
    }
  }


  Future<bool> updateItemType({
    required String id,
    required String categoryId,
    required String itemTypeName,
    required bool isEnable,
  }) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}/item-type/$id');
    final token = await _getToken();

    if (token == null) {
      debugPrint("No token found for update");
      return false;
    }

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'categoryId': categoryId,
          'itemTypeName': itemTypeName,
          'isEnable': isEnable,
        }),
      );

      if (response.statusCode == 200) {
        // Update the item in the local list
        final index = _itemTypes.indexWhere((item) => item.id == id);
        if (index != -1) {
          _itemTypes[index] = ItemTypeModel(
            // id: id,
            // itemTypeName: itemTypeName,
            // isEnable: isEnable,
            // category: _itemTypes[index].category, // Keep existing category object
            createdAt: _itemTypes[index].createdAt,
            updatedAt: DateTime.now().toIso8601String(),
          );
          notifyListeners();
        }
        debugPrint('Item type updated successfully');
        return true;
      } else {
        debugPrint('Failed to update item type: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error updating item type: $e');
      return false;
    }
  }


}
