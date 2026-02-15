// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Provider/Purchase_Provider/DateWisePurchaseProvider/DateWisePurchaseProvider.dart';
//
//
// class DatewisePurchaseScreen extends StatefulWidget {
//   const DatewisePurchaseScreen({super.key});
//
//   @override
//   State<DatewisePurchaseScreen> createState() => _DatewisePurchaseScreenState();
// }
//
// class _DatewisePurchaseScreenState extends State<DatewisePurchaseScreen> {
//   DateTime startDate = DateTime.now();
//   DateTime endDate = DateTime.now();
//   String token = "your_api_token_here"; // Replace with your real token
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<DatewisePurchaseProvider>().fetchPurchases(
//         startDate.toIso8601String().split('T').first,
//         endDate.toIso8601String().split('T').first,
//         token,
//       );
//     });
//   }
//
//   Future<void> pickDate({required bool isStart}) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: isStart ? startDate : endDate,
//       firstDate: DateTime(2024),
//       lastDate: DateTime(2030),
//     );
//
//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           startDate = picked;
//         } else {
//           endDate = picked;
//         }
//       });
//
//       context.read<DatewisePurchaseProvider>().fetchPurchases(
//         startDate.toIso8601String().split('T').first,
//         endDate.toIso8601String().split('T').first,
//         token,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<DatewisePurchaseProvider>();
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Datewise Purchase Report")),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => pickDate(isStart: true),
//                     child: Text("Start: ${startDate.toLocal()}".split(' ')[0]),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => pickDate(isStart: false),
//                     child: Text("End: ${endDate.toLocal()}".split(' ')[0]),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//
//             if (provider.loading)
//               const Center(child: CircularProgressIndicator())
//             else if (provider.purchases.isEmpty)
//               const Center(child: Text("No data found"))
//             else
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: provider.purchases.length,
//                   itemBuilder: (context, index) {
//                     final item = provider.purchases[index];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(vertical: 6),
//                       child: ListTile(
//                         title: Text("GRN: ${item.grnId}"),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Date: ${item.grnDate.split('T').first}"),
//                             Text("Supplier: ${item.supplier.supplierName}"),
//                             Text("Item: ${item.products.map((e) => e.item).join(', ')}"),
//                           ],
//                         ),
//                         trailing: Text(
//                           "Rs ${item.totalAmount.toStringAsFixed(2)}",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//             // ✅ Total Row at the End
//             if (provider.purchases.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "Total Amount: Rs ${provider.totalAmount.toStringAsFixed(2)}",
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/Purchase_Provider/DateWisePurchaseProvider/DateWisePurchaseProvider.dart';
import '../../../compoents/AppColors.dart';


class DatewisePurchaseScreen extends StatefulWidget {
  const DatewisePurchaseScreen({super.key});

  @override
  State<DatewisePurchaseScreen> createState() => _DatewisePurchaseScreenState();
}

class _DatewisePurchaseScreenState extends State<DatewisePurchaseScreen> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String token = "your_api_token_here"; // 🔒 Replace with your actual token

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    context.read<DatewisePurchaseProvider>().fetchPurchases(
      startDate.toIso8601String().split('T').first,
      endDate.toIso8601String().split('T').first,
      token,
    );
  }

  Future<void> pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
      _fetchData(); // 🔄 Auto call API when date changes
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DatewisePurchaseProvider>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Datewise Purchase",
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🗓️ Date Range Selection
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Date From",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () => pickDate(isStart: true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${startDate.toLocal()}".split(' ')[0],
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Icon(Icons.calendar_today, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Date To",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () => pickDate(isStart: false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${endDate.toLocal()}".split(' ')[0],
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Icon(Icons.calendar_today, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 📦 Data Section
            if (provider.loading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (provider.purchases.isEmpty)
              const Expanded(
                child: Center(child: Text("No data found")),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: provider.purchases.length,
                  itemBuilder: (context, index) {
                    final item = provider.purchases[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          "GRN: ${item.grnId}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date: ${item.grnDate.split('T').first}"),
                            Text("Supplier: ${item.supplier.supplierName}"),
                            Text(
                                "Item: ${item.products.map((e) => e.item).join(', ')}"),
                          ],
                        ),
                        trailing: Text(
                          "Rs ${item.totalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // 💰 Total Amount at Bottom
            if (provider.purchases.isNotEmpty)
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  "Total Amount: Rs ${provider.totalAmount.toStringAsFixed(2)}",
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
