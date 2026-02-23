
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ApiLink/ApiEndpoint.dart';
import '../../../model/Purchase_Model/GNRModel/GNR_Model.dart';

class GRNApiService {
  static final String baseUrl = "${ApiEndpoints.baseUrl}"; // from your ApiEndpoint.dart

  /// ✅ Fetch All GRN Records
  static Future<List<GRNModel>> fetchGRN() async {
    final response = await http.get(Uri.parse("$baseUrl/grn"));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return (body["data"] as List)
          .map((e) => GRNModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load GRN data");

    }
  }

  /// ✅ Delete GRN Record
  // static Future<bool> deleteGRN(String id) async {
  //   final response = await http.delete(Uri.parse("$baseUrl/deleteGRN/$id"));
  //   return response.statusCode == 200;
  // }
  static Future<bool> deleteGRN(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final url = Uri.parse("$baseUrl/grn/$id");

      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      print("DELETE URL = $url");
      print("RESPONSE STATUS = ${response.statusCode}");
      print("RESPONSE BODY = ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Error in deleteGRN: $e");
      return false;
    }
  }


  /// ✅ Add New GRN Record
  // static Future<bool> addGRN({
  //   required String supplierId,
  //   required String grnDate,
  //   required List<Map<String, dynamic>> products,
  //   required double totalAmount,
  // }) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('token');
  //
  //     if (token == null) {
  //       throw Exception("Token not found in SharedPreferences");
  //     }
  //
  //     final url = Uri.parse("$baseUrl/grn");
  //
  //     final body = jsonEncode({
  //       "supplierId": supplierId,
  //       "grnDate": grnDate,
  //       "products": products,
  //       "totalAmount": totalAmount,
  //     });
  //
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //       body: body,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return data["success"] == true;
  //     } else {
  //       print("Add GRN failed: ${response.body}");
  //       return false;
  //     }
  //   } catch (e) {
  //     print("Error in addGRN(): $e");
  //     return false;
  //   }
  // }
  static Future<bool> addGRN({
    required String supplierId,
    required String grnDate,
    required List<Map<String, dynamic>> products,
    required double totalAmount,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception("Token not found in SharedPreferences");
      }

      final url = Uri.parse("$baseUrl/grn");

      final body = jsonEncode({
        "supplierId": supplierId,
        "grnDate": grnDate,
        "products": products,
        "totalAmount": totalAmount,
      });

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200||response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data["success"] == true;
      } else {
        return false;
      }
    } catch (e) {
      print("Exception in addGRN(): $e");
      return false;
    }
  }

}
