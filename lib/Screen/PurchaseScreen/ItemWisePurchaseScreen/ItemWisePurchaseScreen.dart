import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/Purchase_Provider/itemWisePurchaseProvider/ItemWisePurchaseProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/itemDropdown.dart';

class ItemWisePurchaseScreen extends StatefulWidget {
  const ItemWisePurchaseScreen({super.key});

  @override
  State<ItemWisePurchaseScreen> createState() => _ItemWisePurchaseScreenState();
}

class _ItemWisePurchaseScreenState extends State<ItemWisePurchaseScreen> {
  String? selectedItemName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Item Wise Purchase",
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
        padding: const EdgeInsets.all(16),
       child:  Column(
          children: [
            ItemDropdown(
              selectedItemName: selectedItemName,
              onSelected: (name) {
                setState(() => selectedItemName = name);

                // Auto-fetch on selection
                if (name != null && name.isNotEmpty) {
                  Provider.of<ItemWisePurchaseProvider>(context, listen: false)
                      .fetchItemWisePurchase(name);
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<ItemWisePurchaseProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.purchases.isEmpty) {
                    return const Center(child: Text("No data found"));
                  }

                  return ListView(
                    children: [
                      ...provider.purchases.map((item) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Date: ${item.date.toLocal().toString().split(' ')[0]}"),
                                Text("ID: ${item.id}"),
                                Text("Supplier: ${item.supplierName}"),
                                Text("Item: ${item.item}"),
                                Text("Rate: ${item.rate}"),
                                Text("Qty: ${item.qty}"),
                                Text("Amount: ${item.amount}"),
                                Text("Total: ${item.total}"),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      Card(
                        color: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Amount: ${provider.totalAmount}"),
                              Text("Total Total: ${provider.totalTotal}"),
                            ],
                          ),
                        ),
                      )
                    ],
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
