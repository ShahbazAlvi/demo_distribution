import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../Provider/BankProvider/BankListProvider.dart';
import '../../../../../Provider/SupplierProvider/supplierProvider.dart';
import '../../../../../Provider/BankProvider/PaymentVoucherProvider.dart';
import '../../../../../compoents/AppColors.dart';

class AddPaymentVoucherScreen extends StatefulWidget {
  final String paymentId;

  const AddPaymentVoucherScreen({super.key, required this.paymentId});

  @override
  State<AddPaymentVoucherScreen> createState() =>
      _AddPaymentVoucherScreenState();
}

class _AddPaymentVoucherScreenState extends State<AddPaymentVoucherScreen> {
  String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

  String? selectedBankId;
  String? selectedSupplierId;
  String? bankBalance = "0";
  String? supplierBalance = "0";


  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<BankProvider>(context, listen: false).fetchBanks();
      Provider.of<SupplierProvider>(context, listen: false).loadSuppliers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentVoucherProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            "Add payment Vouchers",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            ),
          ),
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
        child: ListView(
          children: [
            // ---------------- Date --------------
            Text("Date: $currentDate"),

            const SizedBox(height: 16),

            // ---------------- Bank --------------
            Consumer<BankProvider>(
              builder: (context, bankP, _) {
                if (bankP.loading) return const CircularProgressIndicator();

                return DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: "Select Bank",
                    border: OutlineInputBorder(),
                  ),
                  items: bankP.bankListModel.map((b) {
                    return DropdownMenuItem(
                      value: b.id,
                      child: Text("${b.name}-${b.accountNo}"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBankId = value as String?;

                      final bank = bankP.bankListModel.firstWhere((b) => b.id == value);

                      bankBalance = bank.name.toString();
                    });
                  },

                );
              },
            ),
            const SizedBox(height: 6),

            /// ---------------------- BANK BALANCE ----------------------
            if (selectedBankId != null)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet,
                        color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      "Bank Balance: $bankBalance",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // ---------------- Supplier --------------
            Consumer<SupplierProvider>(
              builder: (context, supplierP, _) {
                if (supplierP.isLoading) {
                  return const CircularProgressIndicator();
                }

                return DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: "Select Supplier",
                    border: OutlineInputBorder(),
                  ),
                  items: supplierP.suppliers.map((s) {
                    return DropdownMenuItem(
                      value: s.id,
                      child: Text(s.name),
                    );
                  }).toList(),
                  // onChanged: (value) {
                  //   selectedSupplierId = value;
                  // },
                  onChanged: (value) {
                    setState(() {
                      selectedSupplierId = value.toString();

                      final supplier = supplierP.suppliers.firstWhere((s) => s.id == value);

                      supplierBalance = supplier.openingBalance.toString(); // <-- supplier balance
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 6),
            if (selectedSupplierId != null)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      "Supplier Balance: $supplierBalance",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),


            const SizedBox(height: 16),

            // ---------------- Amount --------------
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount Paid",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // ---------------- Remarks --------------
            TextField(
              controller: remarkController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Remarks",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- Button --------------
            ElevatedButton(
              onPressed: paymentProvider.isSubmitting
                  ? null
                  : () async {
                if (selectedBankId == null ||
                    selectedSupplierId == null ||
                    amountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please fill all fields")),
                  );
                  return;
                }

                bool success = await paymentProvider.addPayment(
                  date: currentDate,
                  paymentId: widget.paymentId,
                  bankId: selectedBankId!,
                  supplierId: selectedSupplierId!,
                  amount: int.parse(amountController.text),
                  remarks: remarkController.text,
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Payment Voucher Added")),
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
                  : const Text("Submit Payment",style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
    );
  }
}
