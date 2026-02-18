
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Provider/RecoveryProvider/RecoveryProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/Customerdropdown.dart';
import '../../../compoents/SaleManDropdown.dart';
import '../../../model/CustomerModel/CustomerModel.dart';
import '../../../model/SaleRecoveryModel/SaleRecoveryModel.dart';
import 'AddRecoveryScreen.dart';

class RecoveryListScreen extends StatefulWidget {
  const RecoveryListScreen({super.key});

  @override
  State<RecoveryListScreen> createState() => _RecoveryListScreenState();
}

class _RecoveryListScreenState extends State<RecoveryListScreen> {
  String? selectedDate;
  CustomerModel? selectedCustomer;
@override
@override
void initState() {
  super.initState();

  final provider = Provider.of<RecoveryProvider>(context, listen: false);
  provider.fetchRecoveryReport();
}

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecoveryProvider>(context);

    final List<RecoveryVoucher> records =
        provider.recoveryReport?.data.vouchers ?? [];



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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                final provider = Provider.of<RecoveryProvider>(context, listen: false);

                String nextRvNo = "RV-0001"; // default

                if (provider.recoveryReport != null &&
                    provider.recoveryReport!.data.vouchers.isNotEmpty) {
                  final allNumbers = provider.recoveryReport!.data.vouchers.map((voucher) {
                    final regex = RegExp(r'RV-(\d+)$');
                    final match = regex.firstMatch(voucher.rvNo);
                    return match != null ? int.tryParse(match.group(1)!) ?? 0 : 0;
                  }).toList();

                  final maxNumber =
                  allNumbers.isNotEmpty ? allNumbers.reduce((a, b) => a > b ? a : b) : 0;
                  nextRvNo = "RV-${(maxNumber + 1).toString().padLeft(4, '0')}";
                }


                print("Next RV No: $nextRvNo");


                print("Next RV No: $nextRvNo");





                // ✅ Navigate to AddOrderScreen with incremented ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRecoveryScreen(nextOrderId: nextRvNo),
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
                        // selectedCustomer?.id ?? "",
                        // selectedDate ?? "",
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
                                "Invoice: ${item.rvNo}",
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
                                  item.customerName,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const Icon(Icons.work, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item.salesmanName,
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
                              _infoChip("Amount", item.amount.toString()),
                              _infoChip("Mode", item.mode),
                              _infoChip("Date", DateFormat('dd-MM-yyyy').format(item.createdAt)),


                            ],
                          ),
                          const SizedBox(height: 8),

                          // Days Info Row
                          _infoChip("Recovery Date", DateFormat('dd-MM-yyyy').format(item.recoveryDate)),

                        ],
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


