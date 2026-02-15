// import 'package:distribution/compoents/AppColors.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Provider/DailySaleReport/DailySaleReportProvider.dart';
// import '../../../compoents/SaleManDropdown.dart';
//
//
// class DailySaleReportScreen extends StatefulWidget {
//   const DailySaleReportScreen({super.key});
//
//   @override
//   State<DailySaleReportScreen> createState() => _DailySaleReportScreenState();
// }
//
// class _DailySaleReportScreenState extends State<DailySaleReportScreen> {
//   String? selectedSalesmanId;
//   String selectedDate = " ";
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<DailySaleReportProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text("Daily Sales Report",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 22,
//             )),
//         centerTitle: true,
//         elevation: 6,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.secondary, AppColors.primary],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             /// 🔥 Salesman Dropdown
//             SalesmanDropdown(
//               selectedId: selectedSalesmanId,
//               onChanged: (value) {
//                 setState(() => selectedSalesmanId = value);
//               },
//               label: "Select Salesman",
//             ),
//
//             const SizedBox(height: 20),
//
//             /// 🔥 Date Picker
//             Text("Select Date", style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             InkWell(
//               onTap: pickDate,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
//                 decoration: BoxDecoration(
//                   // filled: true,
//                   // fillColor: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all( width: 1.2),
//                   color: Colors.grey.shade100,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       selectedDate.trim().isEmpty ? "Select Date" : selectedDate,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const Icon(Icons.calendar_month,),
//                   ],
//                 ),
//               ),
//             ),
//
//
//             const SizedBox(height: 20),
//
//             /// 🔥 Button
//             ElevatedButton(
//               onPressed: () {
//                 if (selectedSalesmanId == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("Please select a salesman")));
//                   return;
//                 }
//
//                 provider.fetchDailyReport(
//                   salesmanId: selectedSalesmanId!,
//                   date: selectedDate,
//                 );
//               },
//               child: const Text("Get Report"),
//             ),
//
//             const SizedBox(height: 30),
//
//             /// 🔥 Show Loading
//             if (provider.isLoading)
//               const Center(child: CircularProgressIndicator()),
//
//             /// 🔥 Show Report
//             if (!provider.isLoading && provider.reportData != null)
//               buildReport(provider),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// 🔥 Date Picker Function
//   Future<void> pickDate() async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//       initialDate: DateTime.now(),
//     );
//
//     if (picked != null) {
//       setState(() {
//         selectedDate = "${picked.year}-${picked.month}-${picked.day}";
//       });
//     }
//   }
//
//   /// 🔥 Report UI
//   Widget buildReport(DailySaleReportProvider provider) {
//     final report = provider.reportData!;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Salesman: ${report.salesman}",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         Text("Date: ${report.date}"),
//
//         const SizedBox(height: 20),
//
//         /// Product Table
//         const Text("Product Section",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: DataTable(
//             headingRowColor: WidgetStateProperty.all(Colors.green.shade50),
//             columns: const [
//               DataColumn(label: Text("Product")),
//               DataColumn(label: Text("Qty")),
//               DataColumn(label: Text("Purchase")),
//               DataColumn(label: Text("Sale")),
//             ],
//             rows: report.productSection.map((item) {
//               return DataRow(
//                 cells: [
//                   DataCell(Text(
//                     item.product,
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                   )
//                   ),
//                   DataCell(Text(item.qty.toString())),
//                   DataCell(Text(item.purchaseTotal.toString())),
//                   DataCell(Text(item.saleTotal.toString())),
//                 ],
//               );
//             }).toList(),
//           ),
//         ),
//
//         const SizedBox(height: 20),
//
//         /// Customer Table
//         const Text("Customer Section",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         DataTable(
//           headingRowColor: WidgetStateProperty.all(Colors.green.shade50),
//           columns: const [
//             DataColumn(label: Text("Customer")),
//             DataColumn(label: Text("Sales")),
//             DataColumn(label: Text("Recovery")),
//           ],
//           rows: report.customerSection.map((item) {
//             return DataRow(
//               cells: [
//                 DataCell(Text(item.customer)),
//                 DataCell(Text(item.sales.toString())),
//                 DataCell(Text(item.recovery.toString())),
//               ],
//             );
//           }).toList(),
//         ),
//
//         const SizedBox(height: 20),
//
//         /// Totals
//         Text("Total Purchase: ${report.totals.totalPurchase}",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         Text("Total Sales: ${report.totals.totalSales}",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Provider/DailySaleReport/DailySaleReportProvider.dart';
import '../../../Provider/SaleManProvider/SaleManProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/SaleManDropdown.dart';

class DailySaleReportScreen extends StatefulWidget {
  const DailySaleReportScreen({super.key});

  @override
  State<DailySaleReportScreen> createState() => _DailySaleReportScreenState();
}

class _DailySaleReportScreenState extends State<DailySaleReportScreen> {
  String? selectedSalesmanId;
  String selectedDate = "";

  @override
  void initState() {
    super.initState();
    // Default date is today
    final now = DateTime.now();
    selectedDate = "${now.year}-${now.month}-${now.day}";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DailySaleReportProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => SaleManProvider()..fetchEmployees(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Daily Sales Report",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
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
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔥 Salesman Dropdown
              SalesmanDropdown(
                selectedId: selectedSalesmanId,
                onChanged: (value) {
                  setState(() => selectedSalesmanId = value);
      
                  // 🔥 Auto fetch report when salesman selected
                  if (selectedSalesmanId != null) {
                    provider.fetchDailyReport(
                      salesmanId: selectedSalesmanId!,
                      date: selectedDate,
                    );
                  }
                },
               // label: "Select Salesman",
              ),
      
              const SizedBox(height: 20),
      
              /// 🔥 Date Picker
              Text(
                "Select Date",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 1.2),
                    color: Colors.grey.shade100,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const Icon(Icons.calendar_month),
                    ],
                  ),
                ),
              ),
      
              const SizedBox(height: 30),
      
              /// 🔥 Show Loading
              if (provider.isLoading)
                const Center(child: CircularProgressIndicator()),
      
              /// 🔥 Show Report
              if (!provider.isLoading && provider.reportData != null)
                buildReport(provider),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 Date Picker Function
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = "${picked.year}-${picked.month}-${picked.day}";

        // 🔥 If salesman already selected, fetch report immediately
        final provider =
        Provider.of<DailySaleReportProvider>(context, listen: false);
        if (selectedSalesmanId != null) {
          provider.fetchDailyReport(
            salesmanId: selectedSalesmanId!,
            date: selectedDate,
          );
        }
      });
    }
  }

  /// 🔥 Report UI
  Widget buildReport(DailySaleReportProvider provider) {
    final report = provider.reportData!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Salesman: ${report.salesman}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              formatDate(report.date),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),


        const SizedBox(height: 20),

        /// Product Table
        const Text("Product Section",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.green.shade50),
            columns: const [
              DataColumn(label: Text("Product")),
              DataColumn(label: Text("Qty")),
              DataColumn(label: Text("Purchase")),
              DataColumn(label: Text("Sale")),
            ],
            rows: report.productSection.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(
                    item.product,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )),
                  DataCell(Text(item.qty.toString())),
                  DataCell(Text(item.purchaseTotal.toString())),
                  DataCell(Text(item.saleTotal.toString())),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 20),

        /// Customer Table
        const Text("Customer Section",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.green.shade50),
            columns: const [
              DataColumn(label: Text("Customer")),
              DataColumn(label: Text("Sales")),
              DataColumn(label: Text("Recovery")),
              DataColumn(label: Text("Balance"))
            ],
            rows: report.customerSection.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(item.customer)),
                  DataCell(Text(item.sales.toString())),
                  DataCell(Text(item.recovery.toString())),
              DataCell(
              Text(
              ((item.sales ?? 0) - (item.recovery ?? 0)).toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 20),

        /// Totals
        Text("Total Purchase: ${report.totals.totalPurchase}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text("Total Sales: ${report.totals.totalSales}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
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
