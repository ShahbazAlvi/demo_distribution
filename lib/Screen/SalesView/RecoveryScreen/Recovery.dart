
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Provider/RecoveryProvider/RecoveryProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/Customerdropdown.dart';
import '../../../compoents/SaleManDropdown.dart';
import '../../../model/CustomerModel/CustomerModel.dart';
import '../../../model/SaleRecoveryModel/SaleRecoveryModel.dart';

class RecoveryListScreen extends StatefulWidget {
  const RecoveryListScreen({super.key});

  @override
  State<RecoveryListScreen> createState() => _RecoveryListScreenState();
}

class _RecoveryListScreenState extends State<RecoveryListScreen> {
  String? selectedDate;
  CustomerModel? selectedCustomer;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecoveryProvider>(context);

    final records = provider.recoveryData?.data ?? [];

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        title: const Text("Recovery Report",
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
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
                      setState(() {});
                      provider.fetchRecoveryReport(
                        selectedCustomer?.id ?? "",
                        selectedDate ?? "",
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
                // CustomerDropdown(
                //   showDetails: false,
                //   selectedCustomerId: selectedCustomer?.id,
                //   onChanged: (customer) {
                //     setState(() => selectedCustomer = customer);
                //     provider.fetchRecoveryReport(
                //       selectedCustomer?.id ?? "",
                //       selectedDate ?? "",
                //     );
                //   },
                // ),
              ],
            ),
          ),

          if (provider.isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Expanded(
              child: records.isEmpty
                  ? const Center(child: Text("No Recovery Records Found"))
                  : ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final item = records[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.grey.withOpacity(0.3),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),

                      onTap: () async {
                        String? message = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditRecoveryScreen(invoice: item),
                          ),
                        );

                        if (message != null) {
                          // Refresh data
                          provider.fetchRecoveryReport(
                            selectedCustomer?.id ?? "",
                            selectedDate ?? "",
                          );

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },


                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Invoice Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Invoice: ${item.invoiceNo}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: item.status == "Pending"
                                        ? Colors.orange
                                        : Colors.green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.status ?? "N/A",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Customer & Salesman
                            Row(
                              children: [
                                const Icon(Icons.person, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item.customer ?? "",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                const Icon(Icons.work, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item.salesman ?? "",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Financial Info Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _infoChip("Total", item.totalPrice),
                                _infoChip("Received", item.received),
                                _infoChip("Balance", item.balance),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Days Info Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _infoChip("Bill Days", item.billDays),
                                _infoChip("Over Days", item.overDays),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

        ],
      ),
    );
  }
  Widget _infoChip(String title, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$title: $value",
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

}
class EditRecoveryScreen extends StatefulWidget {
  final RecoveryInvoice invoice;

  const EditRecoveryScreen({
    super.key,
    required this.invoice,
  });

  @override
  State<EditRecoveryScreen> createState() => _EditRecoveryScreenState();
}

class _EditRecoveryScreenState extends State<EditRecoveryScreen> {
  final TextEditingController receivedController = TextEditingController();
  num balance = 0;

  @override
  void initState() {
    super.initState();
    balance = widget.invoice.balance ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecoveryProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        title: const Text("Edit Recovery Report",
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow("Recovery Id", widget.invoice.invoiceNo ?? "N/A"),
            _infoRow("Recovery Date", formatDate(widget.invoice.agingDate ?? "")),
            const SizedBox(height: 10),
            _infoRow("Invoice No.", widget.invoice.invoiceNo ?? ""),
            _infoRow("Invoice Date", formatDate(widget.invoice.invoiceDate ?? "")),
            _infoRow("Customer", widget.invoice.customer ?? ""),
            _infoRow("Salesman", widget.invoice.salesman ?? ""),
            const SizedBox(height: 20),
            const Text("Items",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _itemsTable(),
            const SizedBox(height: 20),
            _infoRow("Total Price", widget.invoice.totalPrice.toString()),
            _infoRow("Receivable", widget.invoice.receivable.toString()),
            const SizedBox(height: 8),
            TextField(
              controller: receivedController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Received Amount",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                final rec = double.tryParse(v) ?? 0;
                setState(() {
                  balance = (widget.invoice.receivable ?? 0) - rec;
                });
              },
            ),
            const SizedBox(height: 10),
            _infoRow("Balance", balance.toString()),
            const SizedBox(height: 25),
            provider.isUpdating
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                minimumSize: const Size(double.infinity, 50),
              ),

              onPressed: () async {
                if (receivedController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter received amount")),
                  );
                  return;
                }

                String? msg = await provider.updateReceivedAmount(
                  widget.invoice.invoiceId!,
                  receivedController.text.trim(),
                );

                if (msg != null) {
                  // return message to previous screen
                  Navigator.pop(context, msg);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to update recovery")),
                  );
                }
              },

              child: const Text(
                "Update Recovery",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text(value, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _itemsTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      children: [
        TableRow(children: [
          _tableHeader("SR#"),
          _tableHeader("ITEM"),
          _tableHeader("RATE"),
          _tableHeader("QTY"),
          _tableHeader("TOTAL"),
        ]),
        if (widget.invoice.items != null && widget.invoice.items!.isNotEmpty)
          for (var item in widget.invoice.items!)
            TableRow(children: [
              _tableCell(item.sr.toString()),
              _tableCell(item.item ?? ""),
              _tableCell(item.rate.toString()),
              _tableCell(item.qty.toString()),
              _tableCell(item.total.toString()),
            ]),
      ],
    );
  }

  static Widget _tableHeader(String text) => Padding(
    padding: const EdgeInsets.all(8),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );

  static Widget _tableCell(String text) => Padding(
    padding: const EdgeInsets.all(8),
    child: Text(
      text,
      textAlign: TextAlign.center,
    ),
  );
  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "N/A";

    try {
      DateTime parsed = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(parsed); // simple date
    } catch (e) {
      return date; // fallback if parsing fails
    }
  }

}
