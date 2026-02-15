import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/CreditAgingReportProvider/AgingProvider.dart';
import '../../../../compoents/AppColors.dart';

class CreditAgingScreen extends StatefulWidget {
  const CreditAgingScreen({super.key});

  @override
  State<CreditAgingScreen> createState() => _CreditAgingScreenState();
}

class _CreditAgingScreenState extends State<CreditAgingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CreditAgingProvider>(context, listen: false)
            .fetchCreditAging());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreditAgingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Credit Aging Details ",
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
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
          ? Center(child: Text(provider.errorMessage!))
          : provider.report == null
          ? const Center(child: Text("No data found"))
          : _buildReport(provider),
    );
  }

  Widget _buildReport(CreditAgingProvider provider) {
    final totals = provider.report!.totals;
    final customers = provider.report!.data;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildTotalsCard(totals),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];

                return ExpansionTile(
                  title: Text(
                    "${customer.sr}. ${customer.customerName}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  children: customer.invoices.map((inv) {
                    return ListTile(
                      title: Text("Invoice: ${inv.invoiceNo}"),
                      subtitle: Text(
                        "Date: ${inv.invoiceDate}\n"
                            "Debit: ${inv.debit}, Credit: ${inv.credit}\n"
                            "Outstanding: ${inv.outstanding}",
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsCard(totals) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              "Totals Summary",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _totalRow("Total Debit", totals.totalDebit),
            _totalRow("Total Credit", totals.totalCredit),
            _totalRow("Total Under Credit", totals.totalUnderCredit),
            _totalRow("Total Due", totals.totalDue),
            _totalRow("Total Outstanding", totals.totalOutstanding),
          ],
        ),
      ),
    );
  }

  Widget _totalRow(String title, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
