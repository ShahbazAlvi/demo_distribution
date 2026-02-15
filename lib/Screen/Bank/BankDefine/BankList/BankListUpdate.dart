import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/BankProvider/BankListProvider.dart';
import '../../../../compoents/AppColors.dart';

class UpdateBankScreen extends StatefulWidget {
  final String id;
  final String bankName;
  final String holderName;
  final String accountNo;
  final int balance;

  const UpdateBankScreen({
    super.key,
    required this.id,
    required this.bankName,
    required this.holderName,
    required this.accountNo,
    required this.balance,
  });

  @override
  State<UpdateBankScreen> createState() => _UpdateBankScreenState();
}

class _UpdateBankScreenState extends State<UpdateBankScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController holderCtrl;
  late TextEditingController accountCtrl;
  late TextEditingController balanceCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.bankName);
    holderCtrl = TextEditingController(text: widget.holderName);
    accountCtrl = TextEditingController(text: widget.accountNo);
    balanceCtrl = TextEditingController(text: widget.balance.toString());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BankProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Bank",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildInputField(
                controller: nameCtrl,
                label: "Bank Name",
                icon: Icons.account_balance,
              ),

              buildInputField(
                controller: holderCtrl,
                label: "Account Holder Name",
                icon: Icons.person,
              ),

              buildInputField(
                controller: accountCtrl,
                label: "Account Number",
                icon: Icons.credit_card,
              ),

              buildInputField(
                controller: balanceCtrl,
                label: "Balance",
                icon: Icons.money,
                keyboard: TextInputType.number,
              ),


              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  await provider.updateBank(
                    widget.id,
                    nameCtrl.text,
                    holderCtrl.text,
                    accountCtrl.text,
                    balanceCtrl.text,
                  );

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Bank Updated Successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                ),
                child: const Text(
                  "Update",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

}
