import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../Provider/BankProvider/BankListProvider.dart';
import '../../../../../Provider/BankProvider/ReceiptVoucherProvider.dart';
import '../../../../../Provider/SaleManProvider/SaleManProvider.dart';
import '../../../../../compoents/AppColors.dart';
import '../../../../../model/BankModel/BankListModel.dart';
import '../../../../../model/BankModel/ReceiptVoucher.dart';
import '../../../../../model/SaleManModel/EmployeesModel.dart';
import '../../../../../model/SaleManModel/SaleManModel.dart';



class AddReceiptVoucherScreen extends StatefulWidget {
  final String receiptId; // coming from previous screen

  const AddReceiptVoucherScreen({super.key, required this.receiptId});

  @override
  State<AddReceiptVoucherScreen> createState() =>
      _AddReceiptVoucherScreenState();
}

class _AddReceiptVoucherScreenState extends State<AddReceiptVoucherScreen> {
  BankData? selectedBank;
  //Salesman? selectedSalesman;// was Salesman? -> use SaleManModel
  String salesmanReceivable = "0";
  //SaleManModel? selectedSalesman;
  EmployeeData? selectedSalesman;




  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  String? bankBalance = "0"; // from API
   // from API

  String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

  @override
  void initState() {
    super.initState();

    // fetch bank and salesman lists
    Future.microtask(() {
      Provider.of<BankProvider>(context, listen: false).fetchBanks();
      Provider.of<SaleManProvider>(context, listen: false).fetchEmployees();
    });
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
        title: const Center(
          child: Text(
            " Add Receipt Vouchers",
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
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// ---------------------- DATE ----------------------
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Date",
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: currentDate),
              ),

              const SizedBox(height: 16),

              /// ---------------------- BANK DROPDOWN ----------------------
              bankProvider.loading
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<BankData>(
                value: selectedBank,
                decoration: const InputDecoration(
                  labelText: "Select Bank",
                  border: OutlineInputBorder(),
                ),
                items: bankProvider.bankListModel.map((bank) {
                  return DropdownMenuItem(
                    value: bank,
                    child: Text("${bank.name} - ${bank.accountNo}"),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedBank = val;
                    bankBalance = val?.name.toString() ?? "0";
                  });
                },
              ),

              const SizedBox(height: 6),

              /// ---------------------- BANK BALANCE ----------------------
              if (selectedBank != null)
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

              /// ---------------------- SALESMAN DROPDOWN ----------------------
             //  salesmanProvider.isLoading
             //      ? const CircularProgressIndicator()
             // : DropdownButtonFormField<EmployeeData>(
             //    decoration: const InputDecoration(
             //      labelText: "Select Salesman",
             //      border: OutlineInputBorder(),
             //    ),
             //    value: selectedSalesman,
             //    isExpanded: true,
             //    items: salesmanProvider.salesmen.map((s) {
             //      return DropdownMenuItem<SaleManModel>(
             //        value: s,
             //        child: Text(s.employeeName),
             //      );
             //    }).toList(),
             //    onChanged: (val) {
             //      setState(() {
             //        selectedSalesman = val;
             //        print("Selected balance: ${val?.preBalance}");
             //        //salesmanReceivable = val?.preBalance.toString() ?? "0"; // use preBalance
             //        salesmanReceivable = val?.preBalance.toString() ?? "0";
             //      });
             //    },
             //  ),
              /// ---------------------- SALESMAN DROPDOWN ----------------------
              salesmanProvider.isLoading
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<EmployeeData>(
                decoration: const InputDecoration(
                  labelText: "Select Salesman",
                  border: OutlineInputBorder(),
                ),
                value: selectedSalesman,
                isExpanded: true,
                items: salesmanProvider.employees.map((emp) {
                  return DropdownMenuItem<EmployeeData>(
                    value: emp,
                    child: Text(emp.name),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedSalesman = val;
                   // salesmanReceivable = val?.recoveryBalance.toString() ?? "0";
                    // Optional debug print
                    print("Selected Salesman: ${val?.name}, Receivable: ${salesmanReceivable}");
                  });
                },
              ),




              const SizedBox(height: 6),

              /// ---------------------- SALESMAN RECEIVABLE ----------------------
              if (selectedSalesman != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.money, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        "Receivable: $salesmanReceivable",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              /// ---------------------- AMOUNT RECEIVED ----------------------
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Amount Received",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// ---------------------- REMARK ----------------------
              TextField(
                controller: remarkController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Remark",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              /// ---------------------- SUBMIT BUTTON ----------------------
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: voucherProvider.isSubmitting
              //         ? null
              //         : () async {
              //       if (selectedBank == null ||
              //           selectedSalesman == null ||
              //           amountController.text.isEmpty) {
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           const SnackBar(
              //               content: Text("Please fill all fields")),
              //         );
              //         return;
              //       }
              //
              //       final success = await voucherProvider.addVoucher(
              //         date: currentDate,
              //         receiptId: widget.receiptId,
              //         bankId: selectedBank!.id,
              //         salesmanId: selectedSalesman!.id,
              //         amount: int.parse(amountController.text),
              //         remarks: remarkController.text,
              //       );
              //
              //       if (success) {
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           const SnackBar(
              //               content: Text("Voucher Added Successfully")),
              //         );
              //         Navigator.pop(context);
              //       }
              //     },
              //     style: ElevatedButton.styleFrom(
              //       padding: const EdgeInsets.all(14),
              //       backgroundColor: AppColors.secondary,
              //     ),
              //     child: voucherProvider.isSubmitting
              //         ? const CircularProgressIndicator(color: Colors.white)
              //         : const Text(
              //       "Submit Voucher",
              //       style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: voucherProvider.isSubmitting
                      ? null
                      : () async {
                    // 1️⃣ Check all required fields
                    if (selectedBank == null ||
                        selectedSalesman == null ||
                        amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                      return;
                    }

                    // 2️⃣ Parse entered amount
                    final enteredAmount = int.tryParse(amountController.text) ?? 0;
                    final receivable = int.tryParse(salesmanReceivable) ?? 0;

                    // 3️⃣ Validate against Salesman receivable
                    if (enteredAmount > receivable) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Amount cannot exceed Salesman receivable ($receivable)",
                          ),
                        ),
                      );
                      return;
                    }

                    // 4️⃣ Call API to add voucher
                    final success = await voucherProvider.addVoucher(
                      date: currentDate,
                      receiptId: widget.receiptId,
                      bankId: selectedBank!.id.toString(),
                      salesmanId: selectedSalesman!.id.toString(),
                      amount: enteredAmount,
                      remarks: remarkController.text,
                    );

                    // 5️⃣ Handle API response
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Voucher Added Successfully")),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("❌ Failed to add voucher. Check the values."),
                        ),
                      );
                    }
                  },
                  // style: ElevatedButton.styleFrom(
                  //   padding: const EdgeInsets.all(14),
                  //   backgroundColor: AppColors.secondary,
                  // ),
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
                    "Submit Voucher",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
