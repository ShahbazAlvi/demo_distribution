import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/ProductModel/itemsdetailsModel.dart';
import '../DashBoardProvider.dart';


class ItemDetailsProvider with ChangeNotifier {
  List<ItemDetails> items = [];
  bool isLoading = false;
  String? errorMessage;

  String baseUrl = "${ApiEndpoints.baseUrl}/items";
  String token = "";   // ✅ Put your token here

  Future<void> fetchItems({String? categoryName, bool? isEnable}) async {
    try {
      isLoading = true;
      notifyListeners();

      final storedToken = await getToken();
      if (storedToken == null) {
        errorMessage = "Token not found";
        isLoading = false;
        notifyListeners();
        print("Fetch Error: Token not found");
        return;
      }

      final uri = Uri.parse(baseUrl);

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $storedToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List dataList = decoded['data']['data'] ?? [];
        items = dataList.map((e) => ItemDetails.fromJson(e)).toList();
      } else if (response.statusCode == 401) {
        errorMessage = "Unauthorized: Please login again";
        print("Fetch Error: Unauthorized");
      } else if (response.statusCode == 404) {
        errorMessage = "Endpoint not found";
        print("Fetch Error: 404 Not Found");
      } else {
        errorMessage = "Error: ${response.body}";
        print("Fetch Error: ${response.body}");
      }
    } catch (e) {
      errorMessage = "Fetch Error: $e";
      print("Fetch Exception: $e");
    }

    isLoading = false;
    notifyListeners();
  }




  Future<void> deleteItem(String id,BuildContext context) async {
    final storedToken = await getToken();
    // 🔥 load token from SharedPreferences

    if (storedToken == null) {
      print("Delete Error: Token is null");
      return;
    }

    final uri = Uri.parse("${ApiEndpoints.baseUrl}/item-details/$id");

    try {
      final res = await http.delete(
        uri,
        headers: {
          "Authorization": "Bearer $storedToken",
        },
      );

      print("Delete response: ${res.body}");

      if (res.statusCode == 200) {
        items.removeWhere((item) => item.id == id);


        // refresh list from server
        fetchItems();
        final dashboardProvider =
        Provider.of<DashBoardProvider>(context, listen: false);
        await dashboardProvider.fetchDashboardData();
        notifyListeners();
      }
    } catch (e) {
      print("Delete error: $e");
    }
  }


  // String getNextItemId() {
  //   if (items.isEmpty) {
  //     return "001"; // first item
  //   }
  //
  //   // get last itemId (convert to int)
  //   List<int> ids = items
  //       .map((e) => int.tryParse(e.itemId) ?? 0)
  //       .toList()
  //     ..sort();
  //
  //   int nextId = ids.last + 1;
  //
  //   // format 3 digits (001, 002, 010...)
  //   return nextId.toString().padLeft(3, "0");
  // }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<bool> addItem({
    required BuildContext context,
    required String itemId,
    required String itemName,
    required String itemCategory,
    required String itemType,
    required String itemUnit,
    required String perUnit,
    required String reorder,
    required String itemKind,
    required File itemImage,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final token = await getToken();
    if (token == null) {
      errorMessage = "Token not found";
      isLoading = false;
      notifyListeners();
      return false;
    }

    final uri = Uri.parse("${ApiEndpoints.baseUrl}/item-details");
    final request = http.MultipartRequest("POST", uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['itemId'] = itemId;
    request.fields['itemName'] = itemName;
    request.fields['itemCategory'] = itemCategory;
    request.fields['itemType'] = itemType;
    request.fields['itemUnit'] = itemUnit;
    request.fields['perUnit'] = perUnit;
    request.fields['reorder'] = reorder;
    request.fields['itemKind'] = 'Finished Goods';
    request.fields['isEnable'] = "true";

    request.files.add(await http.MultipartFile.fromPath('itemImage', itemImage.path));

    request.fields.forEach((key, value) {

    });

    try {
      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchItems();
        final dashboardProvider =
        Provider.of<DashBoardProvider>(context, listen: false);
        await dashboardProvider.fetchDashboardData();
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = "Failed: $resBody";
      }
    } catch (e) {
      errorMessage = "Error: $e";
    }

    isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updateItem({
    required BuildContext context,
    required String id,
    required String itemName,
    required String itemCategory,
    required String itemType,
    required String itemUnit,
    required String perUnit,
    required String reorder,
    required String itemKind,
    File? itemImage, // OPTIONAL
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final storedToken = await getToken();
    if (storedToken == null) {
      errorMessage = "Token not found";
      isLoading = false;
      notifyListeners();
      return false;
    }

    final uri = Uri.parse("${ApiEndpoints.baseUrl}/item-details/$id");
    final request = http.MultipartRequest("PUT", uri);

    request.headers["Authorization"] = "Bearer $storedToken";

    request.fields["itemName"] = itemName;
    request.fields["itemCategory"] = itemCategory;
    request.fields["itemType"] = itemType;
    request.fields["itemUnit"] = itemUnit;
    request.fields["perUnit"] = perUnit;
    request.fields["reorder"] = reorder;
    request.fields["itemKind"] = itemKind;

    if (itemImage != null) {
      request.files.add(
          await http.MultipartFile.fromPath("itemImage", itemImage.path));
    }

    try {
      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        await fetchItems();

        final dashboardProvider =
        Provider.of<DashBoardProvider>(context, listen: false);
        await dashboardProvider.fetchDashboardData();

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = body;
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
    return false;
  }




}
