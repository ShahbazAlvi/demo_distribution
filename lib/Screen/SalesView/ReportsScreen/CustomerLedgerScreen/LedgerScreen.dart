import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../Provider/CustomerLedgerProvider/LedgerProvider.dart';
import '../../../../compoents/AppColors.dart';
import '../../../../compoents/Customerdropdown.dart';
import '../../../../model/CustomerModel/CustomersDefineModel.dart';

class CustomerLedgerScreen extends StatefulWidget {
  const CustomerLedgerScreen({super.key});

  @override
  State<CustomerLedgerScreen> createState() => _CustomerLedgerScreenState();
}

class _CustomerLedgerScreenState extends State<CustomerLedgerScreen> {
  CustomerData? selectedCustomer;
  DateTime? fromDate;
  DateTime? toDate;

  final dateFormat = DateFormat("yyyy-MM-dd");

  /// 🔁 Call API safely
  void loadLedger() {
    if (selectedCustomer == null ||
        fromDate == null ||
        toDate == null) return;

    context.read<CustomerLedgerProvider>().getLedger(
      customerId: selectedCustomer!.id.toString(),
      fromDate: dateFormat.format(fromDate!),
      toDate: dateFormat.format(toDate!),
    );
  }

  Future<void> pickFromDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() => fromDate = date);
      loadLedger();
    }
  }

  Future<void> pickToDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() => toDate = date);
      loadLedger();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerLedgerProvider>();

    double totalCredit = 0;
    double totalDebit = 0;

    if (provider.ledgerData != null) {
      for (var item in provider.ledgerData!.data.entries) {
        totalCredit += item.credit;
        totalDebit += item.debit;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Ledger Details",
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [

            /// ✅ Customer Dropdown
            CustomerDropdown(
              selectedCustomerId: selectedCustomer?.id,
              onChanged: (customer) {
                setState(() => selectedCustomer = customer);
                loadLedger();
              },
            ),

            const SizedBox(height: 15),

            /// ✅ Date Pickers
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: pickFromDate,
                    child: Text(fromDate == null
                        ? "From Date"
                        : dateFormat.format(fromDate!)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: pickToDate,
                    child: Text(toDate == null
                        ? "To Date"
                        : dateFormat.format(toDate!)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// ✅ Ledger Data
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.error != null
                  ? Center(child: Text(provider.error!))
                  : provider.ledgerData == null
                  ? const Center(child: Text("Select customer & date"))
                  : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.ledgerData!.data.entries.length,
                      itemBuilder: (context, index) {
                        final item = provider.ledgerData!.data.entries[index];

                        return Card(
                          child: ListTile(
                            title: Text(item.docNo),
                            subtitle: Text(
                                "${DateFormat("dd MMM yyyy").format(item.date)}\n${item.narration}"),
                            trailing: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: [
                                Text("Debit: ${item.debit}",
                                    style: const TextStyle(color: Colors.red)),
                                Text("Credit: ${item.credit}",
                                    style: const TextStyle(color: Colors.green)),
                                Text("Balance: ${item.balance}",
                                    style: const TextStyle(color: Colors.orange)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  /// ✅ Totals
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Total Debit: $totalDebit",
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                        Text("Total Credit: $totalCredit",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
