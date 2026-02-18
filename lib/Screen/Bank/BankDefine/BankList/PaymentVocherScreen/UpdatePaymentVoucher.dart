// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../../Provider/BankProvider/BankListProvider.dart';
// import '../../../../../Provider/SupplierProvider/supplierProvider.dart';
// import '../../../../../Provider/BankProvider/PaymentVoucherProvider.dart';
// import '../../../../../compoents/AppColors.dart';
//
// class UpdatePaymentVoucherScreen extends StatefulWidget {
//   final String paymentId;
//
//   const UpdatePaymentVoucherScreen({super.key, required this.paymentId});
//
//   @override
//   State<UpdatePaymentVoucherScreen> createState() =>
//       _UpdatePaymentVoucherScreenState();
// }
//
// class _UpdatePaymentVoucherScreenState
//     extends State<UpdatePaymentVoucherScreen> {
//   String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
//
//   String? selectedBankId;
//   String? selectedSupplierId;
//   String? bankBalance = "0";
//   String? supplierBalance = "0";
//
//   TextEditingController amountController = TextEditingController();
//   TextEditingController remarkController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     Future.microtask(() async {
//       final bankP = Provider.of<BankProvider>(context, listen: false);
//       final supplierP = Provider.of<SupplierProvider>(context, listen: false);
//       final paymentP =
//       Provider.of<PaymentVoucherProvider>(context, listen: false);
//
//
//       await bankP.fetchBanks();
//       await supplierP.loadSuppliers();
//
//       // Load existing payment
//       // final payment = paymentP.paymentData?.data.firstWhere(
//       //       (p) => p.paymentId == widget.paymentId,
//       //   orElse: () => throw Exception("Payment not found"),
//       // );
//       final payment = paymentP.paymentData?.data.firstWhere(
//             (p) => p.paymentId == widget.paymentId,
//       );
//
//
//
//       if (payment != null) {
//         setState(() {
//           currentDate = payment.date.toString().substring(0, 10);
//
//           selectedBankId = payment.bank?.id;
//           final bank =
//           bankP.bankList.firstWhere((b) => b.id == selectedBankId, orElse: () => bankP.bankList.first);
//           bankBalance = bank.balance.toString();
//
//           selectedSupplierId = payment.supplier?.id;
//           final supplier = supplierP.suppliers.firstWhere(
//                   (s) => s.id == selectedSupplierId,
//               orElse: () => supplierP.suppliers.first);
//           supplierBalance = supplier.payableBalance.toString();
//
//           amountController.text = payment.amount.toString();
//           remarkController.text = payment.remarks ?? "";
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final paymentProvider = Provider.of<PaymentVoucherProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Update Payment Voucher"),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.secondary, AppColors.primary],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             // Date
//             Text("Date: $currentDate"),
//             const SizedBox(height: 16),
//
//             // Bank Dropdown
//             Consumer<BankProvider>(builder: (context, bankP, _) {
//               if (bankP.loading) return const CircularProgressIndicator();
//
//               return DropdownButtonFormField(
//                 decoration: const InputDecoration(
//                   labelText: "Select Bank",
//                   border: OutlineInputBorder(),
//                 ),
//                 value: selectedBankId,
//                 items: bankP.bankList.map((b) {
//                   return DropdownMenuItem(
//                     value: b.id,
//                     child: Text("${b.bankName}-${b.accountHolderName}"),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedBankId = value;
//                     final bank =
//                     bankP.bankList.firstWhere((b) => b.id == value);
//                     bankBalance = bank.balance.toString();
//                   });
//                 },
//               );
//             }),
//             const SizedBox(height: 6),
//             if (selectedBankId != null)
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade50,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.account_balance_wallet,
//                         color: Colors.green),
//                     const SizedBox(width: 8),
//                     Text(
//                       "Bank Balance: $bankBalance",
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.green),
//                     ),
//                   ],
//                 ),
//               ),
//             const SizedBox(height: 16),
//
//             // Supplier Dropdown
//             Consumer<SupplierProvider>(builder: (context, supplierP, _) {
//               if (supplierP.isLoading) return const CircularProgressIndicator();
//
//               return DropdownButtonFormField(
//                 decoration: const InputDecoration(
//                   labelText: "Select Supplier",
//                   border: OutlineInputBorder(),
//                 ),
//                 value: selectedSupplierId,
//                 items: supplierP.suppliers.map((s) {
//                   return DropdownMenuItem(
//                     value: s.id,
//                     child: Text(s.supplierName),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedSupplierId = value;
//                     final supplier = supplierP.suppliers
//                         .firstWhere((s) => s.id == value);
//                     supplierBalance = supplier.payableBalance.toString();
//                   });
//                 },
//               );
//             }),
//             const SizedBox(height: 6),
//             if (selectedSupplierId != null)
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.person, color: Colors.blue),
//                     const SizedBox(width: 8),
//                     Text(
//                       "Supplier Balance: $supplierBalance",
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.blue),
//                     ),
//                   ],
//                 ),
//               ),
//
//             const SizedBox(height: 16),
//
//             // Amount
//             TextField(
//               controller: amountController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: "Amount Paid",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // Remarks
//             TextField(
//               controller: remarkController,
//               maxLines: 2,
//               decoration: const InputDecoration(
//                 labelText: "Remarks",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Update Button
//             ElevatedButton(
//               onPressed: paymentProvider.isSubmitting
//                   ? null
//                   : () async {
//                 if (selectedBankId == null ||
//                     selectedSupplierId == null ||
//                     amountController.text.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text("Please fill all fields")),
//                   );
//                   return;
//                 }
//
//                 bool success = await paymentProvider.updatePayment(
//                   id: payment.paymentUniqueMongoId!,   // NOT payment.paymentId
//                   bankId: selectedBankId!,
//                   supplierId: selectedSupplierId!,
//                   amount: double.parse(amountController.text),
//                   remarks: remarkController.text,
//                 );
//
//
//                 if (success) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text("Payment Voucher Updated")),
//                   );
//                   Navigator.pop(context);
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.all(14),
//                   backgroundColor: AppColors.secondary),
//               child: paymentProvider.isSubmitting
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text(
//                 "Update Payment",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../Provider/BankProvider/BankListProvider.dart';
import '../../../../../Provider/SupplierProvider/supplierProvider.dart';
import '../../../../../Provider/BankProvider/PaymentVoucherProvider.dart';
import '../../../../../compoents/AppColors.dart';

class UpdatePaymentVoucherScreen extends StatefulWidget {
  final String id; // MONGO DOCUMENT ID

  const UpdatePaymentVoucherScreen({
    super.key,
    required this.id,
  });

  @override
  State<UpdatePaymentVoucherScreen> createState() =>
      _UpdatePaymentVoucherScreenState();
}

class _UpdatePaymentVoucherScreenState
    extends State<UpdatePaymentVoucherScreen> {
  String currentDate = "";

  String? selectedBankId;
  String? selectedSupplierId;
  String bankBalance = "0";
  String supplierBalance = "0";

  final amountController = TextEditingController();
  final remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final bankP = Provider.of<BankProvider>(context, listen: false);
      final supplierP = Provider.of<SupplierProvider>(context, listen: false);
      final paymentP =
      Provider.of<PaymentVoucherProvider>(context, listen: false);

      await bankP.fetchBanks();
      await supplierP.loadSuppliers();

      // Find payment by Mongo ID
      final payment = paymentP.paymentData?.data
          .firstWhere((p) => p.id == widget.id);

      if (payment != null) {
        setState(() {
          currentDate = payment.date.toString().substring(0, 10);

          selectedBankId = payment.bank?.id;
          selectedSupplierId = payment.supplier?.id;

          final bank = bankP.bankListModel
              .firstWhere((b) => b.id == selectedBankId);
          bankBalance = bank.name.toString();

          final supplier = supplierP.suppliers
              .firstWhere((s) => s.id == selectedSupplierId);
          supplierBalance = supplier.payableBalance.toString();

          amountController.text =
              payment.amount.toString().replaceAll(".0", "");

          remarkController.text = payment.remarks ?? "";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentVoucherProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Update Payment Voucher",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Date: $currentDate"),
            const SizedBox(height: 16),

            // ---------------- BANK DROPDOWN ----------------
            Consumer<BankProvider>(
              builder: (context, bankP, _) {
                if (bankP.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: "Select Bank",
                    border: OutlineInputBorder(),
                  ),
                  value: selectedBankId,
                  items: bankP.bankListModel.map((b) {
                    return DropdownMenuItem(
                      value: b.id,
                      child: Text("${b.name} - ${b.accountNo}"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBankId = value as String?;
                      final bank = bankP.bankListModel
                          .firstWhere((b) => b.id == value);
                      bankBalance = bank.name.toString();
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 10),
            if (selectedBankId != null)
              _infoBox("Bank Balance", bankBalance, Colors.green),

            const SizedBox(height: 20),

            // ---------------- SUPPLIER DROPDOWN ----------------
            Consumer<SupplierProvider>(
              builder: (context, supplierP, _) {
                if (supplierP.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: "Select Supplier",
                    border: OutlineInputBorder(),
                  ),
                  value: selectedSupplierId,
                  items: supplierP.suppliers.map((s) {
                    return DropdownMenuItem(
                      value: s.id,
                      child: Text(s.supplierName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSupplierId = value;

                      final supplier = supplierP.suppliers
                          .firstWhere((s) => s.id == value);

                      supplierBalance = supplier.payableBalance.toString();
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 10),
            if (selectedSupplierId != null)
              _infoBox("Supplier Balance", supplierBalance, Colors.blue),

            const SizedBox(height: 20),

            // ---------------- AMOUNT ----------------
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount Paid",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- REMARKS ----------------
            TextField(
              controller: remarkController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Remarks",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // ---------------- UPDATE BUTTON ----------------
            ElevatedButton(
              onPressed: paymentProvider.isSubmitting
                  ? null
                  : () async {
                if (selectedBankId == null ||
                    selectedSupplierId == null ||
                    amountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill all fields"),
                    ),
                  );
                  return;
                }

                bool success = await paymentProvider.updatePayment(
                  id: widget.id, // Mongo document ID
                  bankId: selectedBankId!,
                  supplierId: selectedSupplierId!,
                  amount:
                  double.tryParse(amountController.text) ?? 0.0,
                  remarks: remarkController.text,
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Payment successfully updated"),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(14),
                backgroundColor: AppColors.secondary,
              ),
              child: paymentProvider.isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                "Update Payment",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- SMALL INFO BOX WIDGET ----------------
  Widget _infoBox(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: color),
          const SizedBox(width: 8),
          Text(
            "$title: $value",
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
