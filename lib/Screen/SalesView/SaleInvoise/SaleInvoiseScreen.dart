import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Provider/OrderTakingProvider/OrderTakingProvider.dart';
import '../../../Provider/SaleInvoiceProvider/SaleInvoicesProvider.dart';
import '../../../Provider/SaleManProvider/SaleManProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/SaleManDropdown.dart';
import 'AddSalesInvoiceScreen.dart';

class SaleInvoiseScreen extends StatefulWidget {
  const SaleInvoiseScreen({super.key});

  @override
  State<SaleInvoiseScreen> createState() => _SaleInvoiseScreenState();
}

class _SaleInvoiseScreenState extends State<SaleInvoiseScreen> {
  String? selectedDate;
  String? selectedSalesmanId;
  int currentPage = 1;
  int itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SaleInvoicesProvider>(context, listen: false).fetchOrders();
    });
  }
  List getPaginatedData(List data) {
    int start = (currentPage - 1) * itemsPerPage;
    int end = start + itemsPerPage;

    if (start >= data.length) return [];
    if (end > data.length) end = data.length;

    return data.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaleInvoicesProvider>(context);

    final orders = provider.orderData?.invoices ?? [];

    return ChangeNotifierProvider(
      create: (_) => SaleManProvider()..fetchEmployees(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sales Invoice",
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
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: () {
                  final invoiceProvider = Provider.of<SaleInvoicesProvider>(context, listen: false);
                  String nextInvNo = "INV-0001"; // default

                  if (invoiceProvider.orderData != null && invoiceProvider.orderData!.invoices.isNotEmpty) {
                    // Extract numeric part from all existing INV numbers
                    final allNumbers = invoiceProvider.orderData!.invoices.map((invoice) {
                      final id = invoice.invNo ?? "";
                      final regex = RegExp(r'INV-(\d+)$');
                      final match = regex.firstMatch(id);
                      return match != null ? int.tryParse(match.group(1)!) ?? 0 : 0;
                    }).toList();

                    final maxNumber = allNumbers.isNotEmpty ? allNumbers.reduce((a, b) => a > b ? a : b) : 0;
                    final incremented = maxNumber + 1;
                    nextInvNo = "INV-${incremented.toString().padLeft(4, '0')}";
                  }

                  print("✅ Next Invoice No: $nextInvNo");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddSalesInvoiceScreen(nextOrderId: nextInvNo),
                    ),
                  );

                },
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                label: const Text(
                  "Add Order",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),


        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // DATE PICKER
                  GestureDetector(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );

                      if (picked != null) {
                        selectedDate = DateFormat('yyyy-MM-dd').format(picked);
                        setState(() { currentPage = 1; });

                        provider.fetchOrders(
                          date: selectedDate,
                          salesmanId: selectedSalesmanId,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selectedDate ?? "Select Date"),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // SALESMAN DROPDOWN
                  SalesmanDropdown(
                    selectedId: selectedSalesmanId,
                    onChanged: (value) {
                      selectedSalesmanId = value;
                      setState(() { currentPage = 1; });

                      provider.fetchOrders(
                        date: selectedDate,
                        salesmanId: selectedSalesmanId,
                      );
                    },
                  ),
                ],
              ),
            ),

            // LOADING
            if (provider.isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )

            // ERROR
            else if (provider.error != null)
              Expanded(
                child: Center(child: Text(provider.error!)),
              )

            // LIST WITH PAGINATION
            else
              Expanded(
                child: orders.isEmpty
                    ? const Center(child: Text("No Orders Found"))
                    : ListView.builder(
                  itemCount: getPaginatedData(orders).length,
                  itemBuilder: (context, index) {
                    final order = getPaginatedData(orders)[index];

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text("INV: ${order.invNo}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.customerName),
                            Text("Salesman: ${order.salesmanName}"),
                            Text("Gross: ${order.grossTotal}"),
                            Text("Net: ${order.netTotal}"),
                            Text("Items: ${order.totalItems} | Qty: ${order.totalQty}"),
                            Text("Date: ${DateFormat('dd-MMM-yyyy').format(order.invoiceDate)}"),
                          ],
                        ),
                        trailing: const Icon(Icons.receipt_long, color: AppColors.secondary),
                      ),
                    );

                  },
                ),
              ),

            // PAGINATION ROW
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: currentPage > 1
                        ? () {
                      setState(() => currentPage--);
                    }
                        : null,
                    child: const Text("Previous"),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "Page $currentPage",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: (currentPage * itemsPerPage) < orders.length
                        ? () {
                      setState(() => currentPage++);
                    }
                        : null,
                    child: const Text("Next"),
                  ),
                ],
              ),
            )
          ],
        ),

      ),
    );
  }







}
