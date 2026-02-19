import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/SupplierModel/SupplierModel.dart';
import 'Supplier_services.dart';

class SupplierProvider extends ChangeNotifier {
  List<SupplierModel> suppliers = [];
  bool isLoading = false;
  String _error="";
  String? get error => _error;

  final TextEditingController nameController=TextEditingController();
  final TextEditingController emailController=TextEditingController();
  final TextEditingController contactController=TextEditingController();
  final TextEditingController addressController=TextEditingController();
  final TextEditingController balanceController=TextEditingController();



  Future<void> loadSuppliers() async {
    isLoading = true;
    notifyListeners();

    try {
      suppliers = await SupplierApi.fetchSuppliers();
    } catch (e) {
      print("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteSupplier(String id) async {
    bool success = await SupplierApi.deleteSupplier(id);
    if (success) {
      suppliers.removeWhere((e) => e.id == id);
      notifyListeners();
    }
  }

  // Update  the Supplier

  // Future<bool> updateSupplier({
  //   required String id,
  //   required String name,
  //   required String email,
  //   required String phone,
  //   required String address,
  //   required String paymentTerms,
  // }) async {
  //   bool success = await SupplierApi.updateSupplier(
  //     id: id,
  //     name: name,
  //     email: email,
  //     phone: phone,
  //     address: address,
  //     paymentTerms: paymentTerms,
  //   );
  //
  //   if (success) {
  //     int index = suppliers.indexWhere((e) => e.id == id);
  //     if (index != -1) {
  //       suppliers[index] = SupplierModel(
  //         : id,
  //         name: name,
  //         email: email,
  //         phone: phone,
  //              // ← REQUIRED
  //         address: address,
  //         openingBalance: paymentTerms,
  //
  //         contactPerson: suppliers[index].contactPerson,
  //         mobileNumber: suppliers[index].mobileNumber,
  //         designation: suppliers[index].designation,
  //         ntn: suppliers[index].ntn,
  //         gst: suppliers[index].gst,
  //         creditLimit: suppliers[index].creditLimit,
  //         creditTime: suppliers[index].creditTime,
  //         status: suppliers[index].status,
  //         payableBalance: suppliers[index].payableBalance,
  //         createdAt: suppliers[index].createdAt,
  //         updatedAt: suppliers[index].updatedAt,
  //         invoiceNo: suppliers[index].invoiceNo,
  //        // contactNumber: suppliers[index].contactNumber,
  //       );
  //
  //     }
  //
  //     notifyListeners();
  //   }
  //
  //   return success;  // 👈 Return bool here
  // }
  //
  //

  // add  the Supplier

  Future<bool> addSupplier(
  {
    required String paymentType,
}
      ) async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _error = "Token not found!";
      isLoading = false;
      notifyListeners();
      return false;
    }

    final url = Uri.parse("${ApiEndpoints.baseUrl}/suppliers");

    final body = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "address": addressController.text.trim(),
      "contactNumber": contactController.text.trim(),  // <-- fixed

      "is_active":1
    };

    print("SEND BODY => $body");
    print("SEND BODY => ");
    print("SEND BODY => ");
    print("SEND BODY => ");// DEBUG PRINT

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      print("API RESPONSE => ${response.body}"); // DEBUG PRINT

      if (response.statusCode == 201 || response.statusCode == 200) {
        await loadSuppliers();
        clearForm();
        return true;
      } else {
        _error = "Failed: ${response.body}";
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }


  void clearForm() {
    nameController.clear();
    emailController.clear();
    addressController.clear();
    contactController.clear();

    notifyListeners();
  }


}
