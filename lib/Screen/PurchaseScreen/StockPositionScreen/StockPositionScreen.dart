//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Provider/Purchase_Provider/StockPositionProvider/StockPositionProvider.dart';
// import '../../../compoents/AppColors.dart';
// import '../../../model/Purchase_Model/StockPostionModel/StockPostionModel.dart';
//
// class StockPositionScreen extends StatefulWidget {
//   const StockPositionScreen({super.key});
//
//   @override
//   State<StockPositionScreen> createState() => _StockPositionScreenState();
// }
//
// class _StockPositionScreenState extends State<StockPositionScreen> {
//   final TextEditingController searchController = TextEditingController();
//   String searchQuery = "";
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<StockPositionProvider>(context, listen: false)
//           .fetchStockPosition();
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Center(
//           child: Text(
//             "Stocks Position",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 22,
//               letterSpacing: 1.2,
//             ),
//           ),
//         ),
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
//       body: Consumer<StockPositionProvider>(
//         builder: (context, provider, child) {
//           if (provider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (provider.stockItems.isEmpty) {
//             return const Center(child: Text("No stock data found"));
//           }
//
//           // 🔍 Filter Items by search text
//           List<StockPositionModel> filteredList = provider.stockItems
//               .where((item) {
//             final itemName = (item.itemName ?? "").toLowerCase();
//             return itemName.contains(searchQuery.toLowerCase());
//           }).toList();
//
//           return Column(
//             children: [
//               // 🔍 Search Bar
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: TextField(
//                   controller: searchController,
//                   decoration: InputDecoration(
//                     hintText: "Search by item name...",
//                     prefixIcon: const Icon(Icons.search),
//                     contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       searchQuery = value;
//                     });
//                   },
//                 ),
//               ),
//
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   scrollDirection: Axis.vertical,
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//
//                      // child:  DataTable(
//                      //    columnSpacing: 20, // reduce space between columns
//                      //    horizontalMargin: 10, // reduce left+right padding
//                      //    columns: const [
//                      //      DataColumn(
//                      //        label: Text(
//                      //          'S.No',
//                      //          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                      //        ),
//                      //      ),
//                      //      DataColumn(
//                      //        label: Text(
//                      //          'Item Name',
//                      //          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                      //        ),
//                      //      ),
//                      //      DataColumn(
//                      //        label: Text(
//                      //          'Stock',
//                      //          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                      //        ),
//                      //      ),
//                      //    ],
//                      //    rows: filteredList.asMap().entries.map((entry) {
//                      //      int index = entry.key;
//                      //      StockPositionModel item = entry.value;
//                      //
//                      //      return DataRow(
//                      //        cells: [
//                      //          DataCell(Text((index + 1).toString())),
//                      //         // DataCell(Text(item.itemName?.trim() ?? '-')), // trim spaces
//                      //          DataCell(
//                      //            Text(item.itemName?.trim() ?? '-'),
//                      //            onTap: () {
//                      //              _showUpdateStockDialog(context, item);
//                      //            },
//                      //          ),
//                      //
//                      //         // DataCell(Text((item.stock ?? 0).toString())),
//                      //          DataCell(
//                      //            Text((item.stock ?? 0).toString()),
//                      //            onTap: () {
//                      //              _showUpdateStockDialog(context, item);
//                      //            },
//                      //          ),
//                      //
//                      //        ],
//                      //      );
//                      //    }).toList(),
//                      //  )
//                       // In your StockPositionScreen, update the DataTable to include an Actions column
//                       child: DataTable(
//                         columnSpacing: 20, // reduce space between columns
//                         horizontalMargin: 10, // reduce left+right padding
//                         columns: const [
//                           DataColumn(
//                             label: Text(
//                               'S.No',
//                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                             ),
//                           ),
//                           DataColumn(
//                             label: Text(
//                               'Item Name',
//                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                             ),
//                           ),
//                           DataColumn(
//                             label: Text(
//                               'Stock',
//                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                             ),
//                           ),
//                           DataColumn(
//                             label: Text(
//                               'Actions',
//                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                             ),
//                           ),
//                         ],
//                         rows: filteredList.asMap().entries.map((entry) {
//                           int index = entry.key;
//                           StockPositionModel item = entry.value;
//
//                           return DataRow(
//                             cells: [
//                               DataCell(Text((index + 1).toString())),
//                               DataCell(Text(item.itemName?.trim() ?? '-')),
//                               DataCell(Text((item.stock ?? 0).toString())),
//                               DataCell(
//                                 IconButton(
//                                   icon: const Icon(Icons.edit, color: AppColors.secondary),
//                                   onPressed: () => _showUpdateStockDialog(context, item),
//                                 ),
//                               ),
//                             ],
//                           );
//                         }).toList(),
//                       )
//
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//   void _showUpdateStockDialog(BuildContext context, StockPositionModel item) {
//     final TextEditingController stockController =
//     TextEditingController(text: item.stock?.toString() ?? '0');
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Update Stock for ${item.itemName}'),
//           content: TextField(
//             controller: stockController,
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(
//               labelText: 'Stock',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final newStock = stockController.text.trim();
//                 if (newStock.isEmpty) return;
//
//                 final provider = Provider.of<StockPositionProvider>(context, listen: false);
//                 final success = await provider.updateStock(item.id!, newStock);
//
//                 if (success) {
//                   await provider.fetchStockPosition();
//                   Navigator.pop(context);
//
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Stock updated successfully')),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Failed to update stock')),
//                   );
//                 }
//               },
//               child: const Text('Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
// }
