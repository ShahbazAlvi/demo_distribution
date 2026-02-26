// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../../../ApiLink/ApiEndpoint.dart';
// import '../../../model/Purchase_Model/StockPostionModel/StockPostionModel.dart';
//
//
// class StockPositionProvider extends ChangeNotifier {
//   List<StockPositionModel> stockItems = [];
//   bool isLoading = false;
//
//   Future<void> fetchStockPosition() async {
//     isLoading = true;
//     notifyListeners();
//
//     try {
//       final response = await http.get(
//         Uri.parse('${ApiEndpoints.baseUrl}/item-details'),
//       );
//
//       if (response.statusCode == 200) {
//         final List data = json.decode(response.body);
//         stockItems = data.map((json) => StockPositionModel.fromJson(json)).toList();
//
//       } else {
//         stockItems = [];
//       }
//     } catch (e) {
//       stockItems = [];
//       print("Error fetching stock positions: $e");
//     }
//
//     isLoading = false;
//     notifyListeners();
//   }
//
//   // int get totalStockValue =>
//   //     stockItems.fold(0, (sum, item) => sum + item.totalAmount);
//   double get totalStockValue => stockItems.fold(
//     0,
//         (sum, item) => sum + ((item.stock ?? 0) * (item.purchase ?? 0)),
//   );
//
//   Future<bool> updateStock(String itemId, String newStock) async {
//     final url = Uri.parse('${ApiEndpoints.baseUrl}/item-details/$itemId/stock');
//
//     try {
//       final response = await http.put(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'stock': newStock}),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Update local list
//         final index = stockItems.indexWhere((item) => item.id == itemId);
//         if (index != -1) {
//           stockItems[index].stock = int.tryParse(newStock) ?? stockItems[index].stock;
//           notifyListeners();
//         }
//         return true;
//       } else {
//         print('Failed to update stock: ${response.body}');
//         return false;
//       }
//     } catch (e) {
//       print('Error updating stock: $e');
//       return false;
//     }
//   }
//
//
// }
