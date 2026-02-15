
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../Provider/Purchase_Provider/SupplierLedgerProvider/SupplierLedgerProvider.dart';
import '../../../compoents/SupplierDropdown.dart';
import '../../../compoents/AppColors.dart';

class SupplierLedgerScreen extends StatefulWidget {
  const SupplierLedgerScreen({super.key});

  @override
  State<SupplierLedgerScreen> createState() => _SupplierLedgerScreenState();
}

class _SupplierLedgerScreenState extends State<SupplierLedgerScreen> {
  String? selectedSupplierId;
  DateTime? fromDate;
  DateTime? toDate;

  final String token = "YOUR_AUTH_TOKEN_HERE"; // Replace with actual token

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SupplierLedgerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Supplier Ledger ",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            )),
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
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// ✅ Supplier Dropdown
            SupplierDropdown(
              selectedSupplierId: selectedSupplierId,
              onSelected: (id) {
                setState(() => selectedSupplierId = id);
                _fetchLedger(context);
              },
            ),

            const SizedBox(height: 10),

            /// ✅ Date Filters (auto-refresh on change)
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: "From Date",
                    selectedDate: fromDate,
                    onTap: () async {
                      DateTime? picked = await _pickDate();
                      if (picked != null) {
                        setState(() => fromDate = picked);
                        _fetchLedger(context);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDateField(
                    label: "To Date",
                    selectedDate: toDate,
                    onTap: () async {
                      DateTime? picked = await _pickDate();
                      if (picked != null) {
                        setState(() => toDate = picked);
                        _fetchLedger(context);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// ✅ Ledger Data
            Expanded(
              child: provider.loading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.ledgerList.isEmpty
                  ? const Center(child: Text("No Ledger Data Found"))
                  : ListView.builder(
                itemCount: provider.ledgerList.length,
                itemBuilder: (context, index) {
                  final data = provider.ledgerList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 4),
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        "${data.date} - ${data.supplierName}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Description: ${data.description}"),
                          Text("Paid: ${data.paid}"),
                          Text("Received: ${data.received}"),
                          Text("Balance: ${data.balance}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Trigger API when supplier/date changes
  void _fetchLedger(BuildContext context) {
    if (selectedSupplierId == null) return;

    final provider = Provider.of<SupplierLedgerProvider>(context, listen: false);

    final from = fromDate != null
        ? fromDate!.toIso8601String().split("T").first
        : "2025-10-01";
    final to =
    toDate != null ? toDate!.toIso8601String().split("T").first : "2025-11-29";

    provider.fetchSupplierLedger(
      supplierId: selectedSupplierId!,
      fromDate: from,
      toDate: to,
      token: token,
    );
  }

  /// ✅ Date Field Widget
  Widget _buildDateField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          controller: TextEditingController(
            text: selectedDate == null
                ? ''
                : "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
          ),
        ),
      ),
    );
  }

  /// ✅ Date Picker Helper
  Future<DateTime?> _pickDate() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2030, 12, 31),
    );
  }
}
