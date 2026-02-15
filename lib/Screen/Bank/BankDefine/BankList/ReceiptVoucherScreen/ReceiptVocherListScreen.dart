
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../Provider/BankProvider/ReceiptVoucherProvider.dart';
import '../../../../../compoents/AppColors.dart';
import '../addBank.dart';
import 'AddReceiptVoucher.dart';
import 'ReceiptUpdateScreen.dart';

class ReceiptVoucherListScreen extends StatefulWidget {
  const ReceiptVoucherListScreen({super.key});

  @override
  State<ReceiptVoucherListScreen> createState() =>
      _ReceiptVoucherListScreenState();
}

class _ReceiptVoucherListScreenState extends State<ReceiptVoucherListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ReceiptVoucherProvider>(context, listen: false)
          .fetchVouchers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            "Receipt Vouchers",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                final provider = Provider.of<ReceiptVoucherProvider>(context, listen: false);

                String nextReceiptId = "BR-001"; // Default if no vouchers exist

                if (provider.vouchers.isNotEmpty) {
                  // Extract numeric parts from all receipt IDs
                  final allNumbers = provider.vouchers.map((voucher) {
                    final id = voucher.receiptId;
                    final regex = RegExp(r'BR-(\d+)$'); // Matches "BR-001", "BR-023", etc.
                    final match = regex.firstMatch(id);
                    return match != null ? int.tryParse(match.group(1)!) ?? 0 : 0;
                  }).toList();

                  // Find the maximum number
                  final maxNumber = allNumbers.isNotEmpty
                      ? allNumbers.reduce((a, b) => a > b ? a : b)
                      : 0;

                  // Increment by 1
                  final incremented = maxNumber + 1;
                  nextReceiptId = "BR-${incremented.toString().padLeft(3, '0')}";
                }

                print("✅ Next Receipt ID: $nextReceiptId");

                // Navigate to AddReceiptVoucherScreen with the incremented ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddReceiptVoucherScreen(receiptId: nextReceiptId),
                  ),
                );
              },

              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: const Text(
                " Add Voucher",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
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

      body: Consumer<ReceiptVoucherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.vouchers.isEmpty) {
            return const Center(
              child: Text(
                "No vouchers found",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.vouchers.length,
            itemBuilder: (context, index) {
              final item = provider.vouchers[index];

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Receipt: ${item.receiptId}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${item.amountReceived}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Salesman
                        Row(
                          children: [
                            const Icon(Icons.person,
                                size: 20, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Salesman: ${item.salesman?.employeeName ?? "N/A"}",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Bank
                        Row(
                          children: [
                            const Icon(Icons.account_balance,
                                size: 20, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              "Bank: ${item.bank?.bankName ?? "N/A"}",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black87),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Date
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 20, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              "Date: ${item.date.toString().substring(0, 10)}",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black87),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        const Divider(height: 1),

                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => UpdateReceiptVoucherScreen(voucher: item)
                                  ),
                                );
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Confirm Delete"),
                                    content: const Text("Are you sure you want to delete this item?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  bool ok = await provider.deleteVoucher(item.id);

                                  if (ok) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Deleted successfully")),
                                    );
                                  }
                                }
                              },
                            )

                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
