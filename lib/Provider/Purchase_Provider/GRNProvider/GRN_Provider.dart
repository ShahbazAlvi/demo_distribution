
import 'package:flutter/material.dart';
import '../../../model/Purchase_Model/GNRModel/GNR_Model.dart';
import 'GRN_services.dart';

class GRNProvider extends ChangeNotifier {
  List<GRNModel> grnList = [];
  bool isLoading = false;

  Future<void> getGRNData() async {
    isLoading = true;
    notifyListeners();

    try {
      grnList = await GRNApiService.fetchGRN();
    } catch (e) {
      print("Error fetching GRN: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteRecord(String id) async {
    bool success = await GRNApiService.deleteGRN(id);
    if (success) {
      grnList.removeWhere((item) => item.id == id);
      notifyListeners();
    }
  }

  /// ✅ Add New GRN (and refresh list)
  Future<bool> addNewGRN({
    required String supplierId,
    required String grnDate,
    required List<Map<String, dynamic>> products,
    required double totalAmount,
  }) async {
    bool success = await GRNApiService.addGRN(
      supplierId: supplierId,
      grnDate: grnDate,
      products: products,
      totalAmount: totalAmount,
    );

    if (success) {
      await getGRNData(); // refresh list after adding
    }

    return success;
  }




}
