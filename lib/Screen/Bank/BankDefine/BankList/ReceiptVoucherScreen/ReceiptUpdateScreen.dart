// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../../Provider/BankProvider/ReceiptVoucherProvider.dart';
// import '../../../../../compoents/AppColors.dart';
// import '../../../../../model/BankModel/ReceiptVoucher.dart';
//
//
// class UpdateReceiptVoucherScreen extends StatefulWidget {
//   final ReceiptVoucher voucher;
//
//   const UpdateReceiptVoucherScreen({super.key, required this.voucher});
//
//   @override
//   State<UpdateReceiptVoucherScreen> createState() =>
//       _UpdateReceiptVoucherScreenState();
// }
//
// class _UpdateReceiptVoucherScreenState
//     extends State<UpdateReceiptVoucherScreen> {
//   final TextEditingController dateCtrl = TextEditingController();
//   final TextEditingController remarksCtrl = TextEditingController();
//   final TextEditingController amountCtrl = TextEditingController();
//
//   String? selectedBankId;
//   String? selectedSalesmanId;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Pre-fill fields
//     dateCtrl.text = widget.voucher.date.toString().substring(0, 10);
//     remarksCtrl.text = widget.voucher.remarks ?? "";
//     amountCtrl.text = widget.voucher.amountReceived.toString();
//
//     selectedBankId = widget.voucher.bank?.id;
//     selectedSalesmanId = widget.voucher.salesman?.id;
//
//     // Fetch dropdown lists if required (optional)
//     Future.microtask(() {
//       // load banks, salesmen if needed
//     });
//   }
//
//   Widget buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType keyboard = TextInputType.text,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboard,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.blueAccent),
//           labelText: label,
//           labelStyle: const TextStyle(color: Colors.black54),
//           border: InputBorder.none,
//           contentPadding:
//           const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<ReceiptVoucherProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Center(
//           child: Text(
//             " Update Receipt Vouchers",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 22,
//               letterSpacing: 1.2,
//             ),
//           ),
//         ),
//         centerTitle: true,
//         elevation: 6,
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
//
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//
//             // 📅 Date
//             buildInputField(
//               controller: dateCtrl,
//               label: "Date",
//               icon: Icons.calendar_today,
//               keyboard: TextInputType.datetime,
//             ),
//
//             // 💵 Amount
//             buildInputField(
//               controller: amountCtrl,
//               label: "Amount Received",
//               icon: Icons.currency_rupee,
//               keyboard: TextInputType.number,
//             ),
//
//             // 📝 Remarks
//             buildInputField(
//               controller: remarksCtrl,
//               label: "Remarks",
//               icon: Icons.note_alt,
//             ),
//
//             // 🏦 Bank Dropdown
//             Container(
//               margin: const EdgeInsets.only(bottom: 16),
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     blurRadius: 6,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: DropdownButtonFormField<String>(
//                 value: selectedBankId,
//                 decoration: const InputDecoration(
//                   labelText: "Select Bank",
//                   border: InputBorder.none,
//                 ),
//                 items: provider.vouchers
//                     .map((e) => DropdownMenuItem(
//                   value: e.bank?.id,
//                   child: Text(e.bank?.bankName ?? "No Bank"),
//                 ))
//                     .toList(),
//                 onChanged: (val) {
//                   setState(() => selectedBankId = val);
//                 },
//               ),
//             ),
//
//             // 👨‍💼 Salesman Dropdown
//             Container(
//               margin: const EdgeInsets.only(bottom: 16),
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     blurRadius: 6,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: DropdownButtonFormField<String>(
//                 value: selectedSalesmanId,
//                 decoration: const InputDecoration(
//                   labelText: "Select Salesman",
//                   border: InputBorder.none,
//                 ),
//                 items: provider.vouchers
//                     .map((e) => DropdownMenuItem(
//                   value: e.salesman?.id,
//                   child: Text(e.salesman?.employeeName ?? "No Salesman"),
//                 ))
//                     .toList(),
//                 onChanged: (val) {
//                   setState(() => selectedSalesmanId = val);
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // 🔵 Update Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: provider.isSubmitting
//                     ? null
//                     : () async {
//                   bool ok = await provider.updateVoucher(
//                     id: widget.voucher.id,
//                     date: dateCtrl.text,
//                     receiptId: widget.voucher.receiptId,
//                     bankId: selectedBankId!,
//                     salesmanId: selectedSalesmanId!,
//                     amount: int.parse(amountCtrl.text),
//                     remarks: remarksCtrl.text,
//                   );
//
//                   if (ok) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text("Voucher Updated Successfully")),
//                     );
//                     Navigator.pop(context);
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: provider.isSubmitting
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text(
//                   "Update Voucher",
//                   style: TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../Provider/BankProvider/BankListProvider.dart';
import '../../../../../Provider/BankProvider/ReceiptVoucherProvider.dart';
import '../../../../../Provider/SaleManProvider/SaleManProvider.dart';
import '../../../../../compoents/AppColors.dart';
import '../../../../../model/BankModel/BankListModel.dart';
import '../../../../../model/BankModel/ReceiptVoucher.dart';
import '../../../../../model/SaleManModel/EmployeesModel.dart';

class UpdateReceiptVoucherScreen extends StatefulWidget {
  final ReceiptVoucher voucher;

  const UpdateReceiptVoucherScreen({super.key, required this.voucher});

  @override
  State<UpdateReceiptVoucherScreen> createState() =>
      _UpdateReceiptVoucherScreenState();
}

class _UpdateReceiptVoucherScreenState
    extends State<UpdateReceiptVoucherScreen> {
  final TextEditingController dateCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();
  final TextEditingController amountCtrl = TextEditingController();

  BankData? selectedBank;
  EmployeeData? selectedSalesman;

  @override
  void initState() {
    super.initState();

    // Prefill the text fields
    dateCtrl.text = widget.voucher.date.toString().substring(0, 10);
    remarksCtrl.text = widget.voucher.remarks ?? "";
    amountCtrl.text = widget.voucher.amountReceived.toString();

    // Fetch bank & salesman lists
    Future.microtask(() {
      final bankProvider = Provider.of<BankProvider>(context, listen: false);
      final salesmanProvider =
      Provider.of<SaleManProvider>(context, listen: false);

      bankProvider.fetchBanks();
      salesmanProvider.fetchEmployees();

      // Set selected Bank safely
      if (bankProvider.bankList.isNotEmpty) {
        selectedBank = bankProvider.bankList.firstWhere(
              (b) => b.id == widget.voucher.bank?.id,
          orElse: () => bankProvider.bankList[0],
        );
      }

      // Set selected Salesman safely
      if (salesmanProvider.employees.isNotEmpty) {
        selectedSalesman = salesmanProvider.employees.firstWhere(
              (s) => s.id == widget.voucher.salesman?.id,
          orElse: () => salesmanProvider.employees[0],
        );
      }
    });
  }


  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bankProvider = Provider.of<BankProvider>(context);
    final salesmanProvider = Provider.of<SaleManProvider>(context);
    final voucherProvider = Provider.of<ReceiptVoucherProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Update Receipt Voucher",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Date
            buildInputField(
              controller: dateCtrl,
              label: "Date",
              icon: Icons.calendar_today,
              keyboard: TextInputType.datetime,
            ),

            // Amount
            buildInputField(
              controller: amountCtrl,
              label: "Amount Received",
              icon: Icons.money,
              keyboard: TextInputType.number,
            ),

            // Remarks
            buildInputField(
              controller: remarksCtrl,
              label: "Remarks",
              icon: Icons.note_alt,
            ),

            // Bank Dropdown
            bankProvider.loading
                ? const CircularProgressIndicator()
                : Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                value: selectedBank?.id, // store only the ID
                decoration: const InputDecoration(
                  labelText: "Select Bank",
                  border: InputBorder.none,
                ),
                items: bankProvider.bankList.map((bank) {
                  return DropdownMenuItem<String>(
                    value: bank.id,                     // dropdown value = bank.id
                    child: Text("${bank.bankName} (${bank.accountHolderName})"),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedBank = bankProvider.bankList.firstWhere((b) => b.id == val);
                  });
                },
              ),

            ),

            // Salesman Dropdown
            salesmanProvider.isLoading
                ? const CircularProgressIndicator()
                : Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                value: selectedSalesman?.id.toString(),
                decoration: const InputDecoration(
                  labelText: "Select Salesman",
                  border: InputBorder.none,
                ),
                items: salesmanProvider.employees.map((emp) {
                  return DropdownMenuItem<String>(
                    value: emp.id.toString(),
                    child: Text(emp.name),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedSalesman =
                        salesmanProvider.employees.firstWhere((s) => s.id == val);
                  });
                },
              ),

            ),

            const SizedBox(height: 20),

            // Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: voucherProvider.isSubmitting
                    ? null
                    : () async {
                  if (selectedBank == null ||
                      selectedSalesman == null ||
                      amountCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please fill all fields")),
                    );
                    return;
                  }

                  final success = await voucherProvider.updateVoucher(
                    id: widget.voucher.id,
                    date: dateCtrl.text,
                    receiptId: widget.voucher.receiptId,
                    bankId: selectedBank!.id,
                    salesmanId: selectedSalesman!.id.toString(),
                    amount: int.parse(amountCtrl.text),
                    remarks: remarksCtrl.text,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Voucher Updated Successfully")),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "❌ Failed to update voucher. Try again.")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: voucherProvider.isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Update Voucher",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold,color: AppColors.text),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
