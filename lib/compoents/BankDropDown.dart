import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/BankProvider/BankListProvider.dart';
import '../model/BankModel/BankListModel.dart';

class BankDropdown extends StatelessWidget {
  final void Function(BankData?) onChanged;
  final BankData? selectedBank;

  const BankDropdown({
    super.key,
    required this.onChanged,
    required this.selectedBank,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BankProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const CircularProgressIndicator();
        }

        return DropdownButtonFormField<BankData>(
          value: selectedBank,
          hint: const Text("Select Bank"),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: provider.bankList.map((bank) {
            return DropdownMenuItem(
              value: bank,
              child: Text(bank.bankName),
            );
          }).toList(),
          onChanged: onChanged,
        );
      },
    );
  }
}
