
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../Provider/BankProvider/PaymentVoucherProvider.dart';
import '../../../../../compoents/AppColors.dart';
import '../../../../../model/BankModel/PaymentVoucher.dart';
import 'AddPaymentVoucherScreen.dart';
import 'UpdatePaymentVoucher.dart';

class PaymentVoucherListScreen extends StatefulWidget {
  const PaymentVoucherListScreen({super.key});

  @override
  State<PaymentVoucherListScreen> createState() =>
      _PaymentVoucherListScreenState();
}

class _PaymentVoucherListScreenState extends State<PaymentVoucherListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<PaymentVoucherProvider>(context, listen: false)
          .fetchPayments();
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
            "payment Vouchers",
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
              // onPressed: (){
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (_) =>AddPaymentVoucherScreen(paymentId: "BR-008")),
              //   );
              // },
              onPressed: () {
                final provider = Provider.of<PaymentVoucherProvider>(context, listen: false);

                String nextPaymentId = "BP-001"; // Default if no payments found

                // ✅ Check if payment data exists and is not empty
                if (provider.paymentData != null && provider.paymentData!.data.isNotEmpty) {
                  // ✅ Extract numeric parts from all payment IDs
                  final allNumbers = provider.paymentData!.data.map((payment) {
                    final id = payment.paymentId;
                    final regex = RegExp(r'BP-(\d+)$'); // Matches "BP-001", "BP-023", etc.
                    final match = regex.firstMatch(id);
                    return match != null ? int.tryParse(match.group(1)!) ?? 0 : 0;
                  }).toList();

                  // ✅ Find the maximum number
                  final maxNumber = allNumbers.isNotEmpty ? allNumbers.reduce((a, b) => a > b ? a : b) : 0;

                  // ✅ Generate the next ID
                  final incremented = maxNumber + 1;
                  nextPaymentId = "BP-${incremented.toString().padLeft(3, '0')}";
                }

                print("✅ Next Payment ID: $nextPaymentId");

                // ✅ Navigate to AddPaymentVoucherScreen with incremented ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddPaymentVoucherScreen(paymentId: nextPaymentId),
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

      body: Consumer<PaymentVoucherProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.paymentData == null ||
              provider.paymentData!.data.isEmpty) {
            return const Center(
              child: Text(
                "No payments found",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.paymentData!.data.length,
            itemBuilder: (context, index) {
              final pay = provider.paymentData!.data[index];

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

                        // HEADER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment: ${pay.paymentId}",
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
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${pay.amount}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Supplier
                        Row(
                          children: [
                            const Icon(Icons.person, size: 20, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              "Supplier: ${pay.supplier?.supplierName ?? "N/A"}",
                              style: const TextStyle(fontSize: 15),
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
                              "Bank: ${pay.bank?.bankName ?? "N/A"}",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Date
                        Row(
                          children: [
                            const Icon(Icons.calendar_month,
                                size: 20, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              "Date: ${pay.date.toString().substring(0, 10)}",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        const Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => UpdatePaymentVoucherScreen(id: pay.id),
                                  ),
                                );
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                // Show confirmation dialog
                                bool? confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirm Delete"),
                                      content: const Text("Are you sure you want to delete this payment? This action cannot be undone."),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false), // User pressed No
                                          child: const Text("No"),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true), // User pressed Yes
                                          child: const Text("Yes"),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                // If user confirmed
                                if (confirm == true) {
                                  bool ok = await provider.deletePayment(pay.id);
                                  if (ok) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Payment Deleted"),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),

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

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this record?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text("Delete"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    ) ??
        false;
  }
}
