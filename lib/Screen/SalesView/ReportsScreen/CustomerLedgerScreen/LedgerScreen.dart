import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../Provider/CustomerLedgerProvider/LedgerProvider.dart';
import '../../../../compoents/AppColors.dart';
import '../../../../compoents/Customerdropdown.dart';

class CustomerLedgerScreen extends StatefulWidget {
  const CustomerLedgerScreen({super.key});

  @override
  State<CustomerLedgerScreen> createState() => _CustomerLedgerScreenState();
}

class _CustomerLedgerScreenState extends State<CustomerLedgerScreen> {
  String? selectedCustomerId;
  DateTime? fromDate;
  DateTime? toDate;

  final dateFormat = DateFormat("yyyy-MM-dd");

  Future<void> pickFromDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() => fromDate = date);

      if (selectedCustomerId != null && toDate != null) {
        Provider.of<CustomerLedgerProvider>(context, listen: false)
            .getLedger(
          customerId: selectedCustomerId!,
          fromDate: dateFormat.format(fromDate!),
          toDate: dateFormat.format(toDate!),
        );
      }
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

      if (selectedCustomerId != null && fromDate != null) {
        Provider.of<CustomerLedgerProvider>(context, listen: false)
            .getLedger(
          customerId: selectedCustomerId!,
          fromDate: dateFormat.format(fromDate!),
          toDate: dateFormat.format(toDate!),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerLedgerProvider>(context);

    double totalCredit = 0;
    double totalDebit = 0;

    if (provider.ledgerData != null) {
      for (var item in provider.ledgerData!.data) {
        double received = double.tryParse(item.received) ?? 0;
        double paid = double.tryParse(item.paid) ?? 0;

        totalCredit += received;
        totalDebit += paid;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Ledger Details ",
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
            // CustomerDropdown(
            //   selectedCustomerId: selectedCustomerId,
            //   onChanged: (customer) {
            //     selectedCustomerId = customer?.id;
            //
            //     if (selectedCustomerId != null) {
            //       Provider.of<CustomerLedgerProvider>(context, listen: false)
            //           .getLedger(customerId: selectedCustomerId!);
            //     }
            //   },
            //   showDetails: false,
            // ),

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

            /// ✅ Ledger Data UI
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.error != null
                  ? Center(
                  child: Text(provider.error!,
                      style: const TextStyle(color: Colors.red)))
                  : provider.ledgerData == null
                  ? const Center(child: Text("Select customer"))
                  : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                      provider.ledgerData!.data.length,
                      itemBuilder: (context, index) {
                        final item = provider
                            .ledgerData!.data[index];
                        return Card(
                          child: ListTile(
                            title: Text(item.description),
                            subtitle: Text(item.date),
                            trailing: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: [
                                Text(
                                    "Debit: ${item.paid}",
                                    style: const TextStyle(
                                        color: Colors.red)),
                                Text(
                                    "Credit: ${item.received}",
                                    style: const TextStyle(
                                        color: Colors.green)),
                                Text(
                                    "Balance: ${item.balance}",
                                    style: const TextStyle(
                                        color: Colors.orange)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  /// ✅ TOTALS SECTION
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius:
                        BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Total Debit: $totalDebit",
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Total Credit: $totalCredit",
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
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
