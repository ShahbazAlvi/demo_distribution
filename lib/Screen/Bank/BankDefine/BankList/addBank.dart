
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Provider/BankProvider/BankListProvider.dart';
import '../../../../compoents/AppColors.dart';
import '../../../../compoents/AppTextfield.dart';

class AddBankScreen extends StatefulWidget {
  const AddBankScreen({super.key});

  @override
  State<AddBankScreen> createState() => _AddBankScreenState();
}

class _AddBankScreenState extends State<AddBankScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController bankNameC = TextEditingController();
  final TextEditingController holderC = TextEditingController();
  final TextEditingController accountNoC = TextEditingController();
  final TextEditingController balanceC = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            "Add Banks",
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              AppTextField(controller: bankNameC, label: "Bank Name",validator: (v) => v!.isEmpty ? "Enter bank name" : null,),


              const SizedBox(height: 10),
              AppTextField(controller: holderC, label:"Account Title",   validator: (v) => v!.isEmpty ? "Enter holder name" : null,),


              const SizedBox(height: 10),
              AppTextField(controller:accountNoC, label: "Account Number", validator: (v) => v!.isEmpty ? "Enter account number" : null,),



              const SizedBox(height: 10),
              AppTextField(controller:balanceC, label: "Branch",  validator: (v) => v!.isEmpty ? "Enter balance" : null,),






              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: isLoading ? null : () async {
                  if (!_formKey.currentState!.validate()) return;

                  setState(() => isLoading = true);

                  await Provider.of<BankProvider>(context, listen: false)
                      .addBank(
                    bankNameC.text.trim(),
                    holderC.text.trim(),
                    accountNoC.text.trim(),
                    balanceC.text.trim(),
                  );

                  setState(() => isLoading = false);

                  Navigator.pop(context);
                },
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Save Bank",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
