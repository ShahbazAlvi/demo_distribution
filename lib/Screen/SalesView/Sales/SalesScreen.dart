import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Provider/SalessProvider/SalessProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/SaleManDropdown.dart';
import '../../../model/SalessModel/SalessModel.dart';

class SalessScreen extends StatefulWidget {
  const SalessScreen({super.key});

  @override
  State<SalessScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalessScreen> {
  String? selectedSalesmanId;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SalesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            "Sales",
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SalesmanDropdown(
              selectedId: selectedSalesmanId,
              onChanged: (value) async {
                setState(() {
                  selectedSalesmanId = value;
                });
                if (value != null) {
                  await provider.fetchSalesReport(value);
                }
              },
            ),
            const SizedBox(height: 20),

            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (provider.salesData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSupplierTable(provider.salesData!),
                  const SizedBox(height: 20),
                  _buildCustomerTable(provider.salesData!),
                ],
              )
            else
              const Center(child: Text("No data found")),
          ],
        ),
      ),
    );
  }

  // ✅ Supplier Table
  Widget _buildSupplierTable(SalesModel data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text(
            "Supplier Report",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            columnWidths: const {
              0: FixedColumnWidth(30),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FixedColumnWidth(40),
              4: FixedColumnWidth(70),
              5: FixedColumnWidth(70),
              6: FixedColumnWidth(40),
              7: FixedColumnWidth(80),
              8: FixedColumnWidth(80),
              9: FixedColumnWidth(60),
            },
            children: [
              _buildHeaderRow([
                "SR",
                "SUPPLIER",
                "PRODUCT",
                "WEIGHT",
                "PUR PRICE",
                "SALE PRICE",
                "QTY",
                "PUR TOTAL",
                "SALE TOTAL",
                "PROFIT"
              ]),
              ...data.data.asMap().entries.map((entry) {
                final i = entry.key + 1;
                final item = entry.value;
                final profit = item.saleTotal - item.purchaseTotal;
                return _buildDataRow([
                  "$i",
                  item.supplier,
                  item.product,
                  item.weight,
                  item.purchasePrice.toString(),
                  item.salePrice.toString(),
                  item.qty.toString(),
                  item.purchaseTotal.toString(),
                  item.saleTotal.toString(),
                  profit.toString(),
                ]);
              }),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Total Pur: ${data.totalPurchase}", style: const TextStyle(color: Colors.red)),
              const SizedBox(width: 10),
              Text("Total Sal: ${data.totalSales}", style: const TextStyle(color: Colors.green)),
              const SizedBox(width: 10),
              Text(
                "Total Prof: ${data.totalSales - data.totalPurchase}",
                style: const TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Customer Table
  Widget _buildCustomerTable(SalesModel data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text(
            "Customer Report",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            columnWidths: const {
              0: FixedColumnWidth(30),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FlexColumnWidth(),
              4: FixedColumnWidth(80),
              5: FixedColumnWidth(80),
            },
            children: [
              _buildHeaderRow(["SR", "CUSTOMER", "SECTION/AREA", "ADDRESS", "SALES", "RECOVERY"]),
              ...data.data.asMap().entries.map((entry) {
                final i = entry.key + 1;
                final item = entry.value;
                return _buildDataRow([
                  "$i",
                  item.customer,
                  "-",
                  item.customerAddress,
                  item.saleTotal.toString(),
                  "0",
                ]);
              }),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Total Sal: ${data.totalSales}", style: const TextStyle(color: Colors.green)),
              const SizedBox(width: 10),
              const Text("Total Rec: 0", style: TextStyle(color: Colors.blue)),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Helper for table header row
  TableRow _buildHeaderRow(List<String> headers) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      children: headers
          .map((h) => Padding(
        padding: const EdgeInsets.all(6),
        child: Text(h, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
      ))
          .toList(),
    );
  }

  // ✅ Helper for table data row
  TableRow _buildDataRow(List<String> cells) {
    return TableRow(
      children: cells
          .map((c) => Padding(
        padding: const EdgeInsets.all(6),
        child: Text(c, textAlign: TextAlign.center),
      ))
          .toList(),
    );
  }
}
