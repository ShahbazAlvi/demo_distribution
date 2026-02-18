import 'package:demo_distribution/Provider/BankProvider/BankListProvider.dart';
import 'package:demo_distribution/compoents/AppTextfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/RecoveryProvider/RecoveryProvider.dart';
import '../../../Provider/SaleManProvider/SaleManProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/BankDropDown.dart';
import '../../../compoents/Customerdropdown.dart';
import '../../../compoents/SaleManDropdown.dart';
import '../../../model/BankModel/BankListModel.dart';
import '../../../model/CustomerModel/CustomersDefineModel.dart';

class AddRecoveryScreen extends StatefulWidget {
  final String nextOrderId;
  const AddRecoveryScreen({super.key, required this.nextOrderId});

  @override
  State<AddRecoveryScreen> createState() => _AddRecoveryScreenState();
}

class _AddRecoveryScreenState extends State<AddRecoveryScreen> {
  CustomerData? selectedCustomer;
  String? selectedSalesmanId;
  BankData? selectedBank;
  bool isLoading = false;
  final TextEditingController amountController=TextEditingController();
  @override
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<SaleManProvider>(context, listen: false);
    final bprovider = Provider.of<BankProvider>(context, listen: false);
    provider.fetchEmployees(); // <-- fetch data
    bprovider.fetchBanks();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Recovery",
            style: TextStyle(color: Colors.white, fontSize: 22)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.nextOrderId),
              CustomerDropdown(
                selectedCustomerId: selectedCustomer?.id, // ✅ use ?. instead of !.
                onChanged: (customer) {
                  setState(() => selectedCustomer = customer);
                },
              ),
              SalesmanDropdown(
                selectedId: selectedSalesmanId,
                onChanged: (value) {
                  setState(() => selectedSalesmanId = value);
                },
              ),
          SizedBox(height: 20,),
          BankDropdown(
          selectedBank: selectedBank,
          onChanged: (bank) {
            setState(() {
              selectedBank = bank;
              print("Selected Bank: ${bank?.name}");
            });
          },
                ),
              SizedBox(height: 20,),

              AppTextField(controller: amountController, label: 'Amount',validator: (v) => v!.isEmpty ? "Enter balance" : null ),
              SizedBox(height: 40,),
              ElevatedButton(
                onPressed: isLoading ? null : () async {
                  if (selectedSalesmanId == null || selectedCustomer == null || selectedBank == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields")),
                    );
                    return;
                  }

                  setState(() => isLoading = true);

                  try {
                    final provider = Provider.of<RecoveryProvider>(context, listen: false);
                    final message = await provider.addRecovery(
                      orderId: widget.nextOrderId,
                      salesmanId: selectedSalesmanId!,
                      customerId: selectedCustomer!.id.toString(),
                      bankId: selectedBank!.id.toString(),
                      amount: amountController.text,
                      recoveryDate: DateTime.now().toIso8601String().split("T")[0], // Today
                      mode: "BANK",
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message ?? "Recovery added")),
                    );

                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  } finally {
                    setState(() => isLoading = false);
                  }
                },
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Create Recovery"),
              )



            ],
          ),
        ),
      ),
    );
  }
}
