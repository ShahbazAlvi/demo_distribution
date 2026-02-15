import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/Purchase_Provider/SupplierWisePurchaseProvider/SupplierWisePurchaseProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/SupplierDropdown.dart';


class SupplierwisePurchaseScreen extends StatefulWidget {
  const SupplierwisePurchaseScreen({super.key});

  @override
  State<SupplierwisePurchaseScreen> createState() =>
      _SupplierwisePurchaseScreenState();
}

class _SupplierwisePurchaseScreenState
    extends State<SupplierwisePurchaseScreen> {
  String? selectedSupplierId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SupplierwisePurchaseProvider>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Supplier Wise Purchase ",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            )),
        ),
        centerTitle: true,
        elevation: 6,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SupplierDropdown(
              selectedSupplierId: selectedSupplierId,
              onSelected: (id) {
                setState(() => selectedSupplierId = id);
                provider.fetchSupplierwiseData(id);
              },
            ),
            const SizedBox(height: 20),

            provider.loading
                ? const Expanded(
                child: Center(child: CircularProgressIndicator()))
                : provider.purchaseList.isEmpty
                ? const Expanded(child: Center(child: Text("No data found")))
                : Expanded(
              child: ListView.builder(
                itemCount: provider.purchaseList.length + 1,
                itemBuilder: (context, index) {
                  // ✅ Last item is the summary card
                  if (index == provider.purchaseList.length) {
                    return Card(
                      color: Colors.green.shade50,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Summary",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                                "Total Amount: ${provider.totalAmount.toStringAsFixed(2)}"),
                            Text(
                                "Total Payable: ${provider.totalPayable.toStringAsFixed(2)}"),
                            Text(
                                "Total Discount: ${provider.totalDiscount.toStringAsFixed(2)}"),
                          ],
                        ),
                      ),
                    );
                  }

                  final item = provider.purchaseList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date: ${item.date}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          Text("GRN ID: ${item.id}"),
                          Text("Supplier: ${item.supplierName}"),
                          Text("Item: ${item.item}"),
                          Text("Rate: ${item.rate.toStringAsFixed(2)}"),
                          Text("Quantity: ${item.qty.toStringAsFixed(2)}"),
                          Text("Amount: ${item.amount.toStringAsFixed(2)}"),
                          Text("Total: ${item.total.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
