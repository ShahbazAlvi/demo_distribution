import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/BankModel/BankListModel.dart';



class BankProvider extends ChangeNotifier {
  bool loading = false;
  List<BankData> bankList = [];

  Future<void> fetchBanks() async {
    loading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("${ApiEndpoints.baseUrl}/banks"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer YOUR_TOKEN_HERE",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final model = BankListModel.fromJson(jsonData);
        bankList = model.data;
      }
    } catch (e) {
      print("Error: $e");
    }

    loading = false;
    notifyListeners();
  }

  Future<void> deleteBank(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("${ApiEndpoints.baseUrl}/banks/$id"),
        headers: {
          "Authorization": "Bearer YOUR_TOKEN_HERE",
        },
      );

      if (response.statusCode == 200) {
        bankList.removeWhere((bank) => bank.id == id);
        notifyListeners();
      }
    } catch (e) {
      print("Delete Error: $e");
    }
  }
  Future<void> addBank(
      String bankName,
      String holderName,
      String accountNo,
      String balance
      ) async {

    final body = jsonEncode({
      "bankName": bankName,
      "accountHolderName": holderName,
      "accountNumber": accountNo,
      "balance": int.parse(balance),
    });

    try {
      final response = await http.post(
        Uri.parse("${ApiEndpoints.baseUrl}/banks"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer YOUR_TOKEN_HERE",
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchBanks(); // Refresh list
        notifyListeners();
      } else {
        print("Add Error: ${response.body}");
      }
    } catch (e) {
      print("Add Bank Error: $e");
    }
  }
  Future<void> updateBank(
      String id,
      String bankName,
      String holderName,
      String accountNo,
      String balance,
      ) async {
    final body = jsonEncode({
      "bankName": bankName,
      "accountHolderName": holderName,
      "accountNumber": accountNo,
      "balance": int.parse(balance),
    });

    try {
      final response = await http.put(
        Uri.parse("${ApiEndpoints.baseUrl}/banks/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer YOUR_TOKEN_HERE",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // Refresh list
        await fetchBanks();
        notifyListeners();
      } else {
        print("Update Error: ${response.body}");
      }
    } catch (e) {
      print("Update Bank Error: $e");
    }
  }


}
