// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Provider/OrderTakingProvider/OrderTakingProvider.dart';
// import '../../../Provider/SaleManProvider/SaleManProvider.dart';
// import '../../../compoents/AppColors.dart';
// import '../../../compoents/Customerdropdown.dart';
// import '../../../compoents/ProductDropdown.dart';
// import '../../../compoents/SaleManDropdown.dart';
//
// import '../../../model/CustomerModel/CustomerModel.dart';
// import '../../../model/OrderTakingModel/OrderTakingModel.dart';
// import '../../../model/ProductModel/itemsdetailsModel.dart';
//
// class UpdateOrderScreen extends StatefulWidget {
//   final OrderData order;
//
//   const UpdateOrderScreen({super.key, required this.order});
//
//   @override
//   State<UpdateOrderScreen> createState() => _UpdateOrderScreenState();
// }
//
// class _UpdateOrderScreenState extends State<UpdateOrderScreen> {
//   String? selectedSalesmanId;
//   CustomerModel? selectedCustomer;
//   ItemDetails? selectedProduct;
//   bool isLoading = false;
//
//
//   final TextEditingController qtyController = TextEditingController();
//   final TextEditingController rateController = TextEditingController();
//
//
//   List<Map<String, dynamic>> orderItems = [];
//   late String currentDate;
//
//   @override
//   void initState() {
//     super.initState();
//
//     currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//
//     /// Load Existing Order into UI
//     _loadExistingOrder();
//
//     Future.microtask(() {
//       Provider.of<SaleManProvider>(context, listen: false).fetchSalesmen();
//     });
//   }
//
//   void _loadExistingOrder() {
//     final order = widget.order;
//
//     selectedSalesmanId = order.salesmanId?.id;
//
//     selectedCustomer = CustomerModel(
//       id: order.customerId!.id,
//       customerName: order.customerId!.customerName,
//       address: order.customerId!.address,
//       phoneNumber: order.customerId!.phoneNumber,
//       creditTime: order.customerId!.creditTime,
//       salesBalance: order.customerId!.salesBalance,
//       timeLimit: order.customerId!.timeLimit.toString(),
//       formattedTimeLimit: order.customerId!.timeLimit.toString(),
//     );
//
//     for (var p in order.products) {
//       orderItems.add({
//         "itemName": p.itemName,
//         "qty": p.qty.toDouble(),
//         "itemUnit": p.itemUnit,
//         //"purchase": p.purchase.toDouble(),
//         "rate": double.tryParse(p.rate.toString()) ?? 0.0,
//        // "rate": p.rate.toDouble(),
//         "totalAmount": p.totalAmount.toDouble(),
//       });
//     }
//   }
//
//   void addProductToOrder() {
//     if (selectedProduct != null && qtyController.text.isNotEmpty) {
//       final qty = double.tryParse(qtyController.text) ?? 0;
//       final rate = double.tryParse(rateController.text) ?? 0;
//       //final total = selectedProduct!.price * qty;
//       final total = qty * rate;
//
//       setState(() {
//         orderItems.add({
//           "itemName": selectedProduct!.name,
//           "qty": qty,
//          // "itemUnit": selectedProduct!.itemUnit?.unitName ?? "",
//          // "rate": selectedProduct!.price.toDouble(),
//           "rate": rate,
//           //"purchase": selectedProduct!.purchase.toDouble(),
//           "totalAmount": total,
//         });
//       });
//
//       qtyController.clear();
//       rateController.clear();
//       selectedProduct = null;
//     }
//   }
//
//   Future<void> updateOrder() async {
//     if (selectedSalesmanId == null ||
//         selectedCustomer == null ||
//         orderItems.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please complete all fields")),
//       );
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     final provider = Provider.of<OrderTakingProvider>(context, listen: false);
//
//     final body = {
//       "orderId": widget.order.orderId,
//       "salesmanId": selectedSalesmanId,
//       "customerId": selectedCustomer!.id,
//       "products": orderItems.map((p) {
//         return {
//           "itemName": p["itemName"],
//           "qty": p["qty"],
//           "itemUnit": p["itemUnit"],
//           "purchase": p["purchase"],
//           "rate": p["rate"],
//           "totalAmount": p["totalAmount"],
//         };
//       }).toList(),
//     };
//
//     await provider.updateOrder(widget.order.id, body);
//
//     setState(() => isLoading = false);
//
//     Navigator.pop(context);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Order Updated Successfully")),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final order = widget.order;
//
//     return ChangeNotifierProvider(
//       create: (_) => SaleManProvider()..fetchEmployees(),
//       child: Scaffold(
//         backgroundColor: Color(0xFFEEEEEE),
//         appBar: AppBar(
//           iconTheme: const IconThemeData(color: Colors.white),
//           title: const Text(
//             "Update Order",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           centerTitle: true,
//           elevation: 6,
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [AppColors.secondary, AppColors.primary],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//         ),
//
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               /// TOP INFO
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Order ID: ${order.orderId}"),
//                   Text("Date: $currentDate"),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Divider(),
//
//               /// SALESMAN
//               SalesmanDropdown(
//                 selectedId: selectedSalesmanId,
//                 onChanged: (value) {
//                   setState(() => selectedSalesmanId = value);
//                 },
//               ),
//
//               const SizedBox(height: 25),
//
//               /// CUSTOMER
//               CustomerDropdown(
//                 selectedCustomerId: selectedCustomer?.id,
//                 onChanged: (customer) {
//                   setState(() => selectedCustomer = customer);
//                 },
//               ),
//
//               const SizedBox(height: 25),
//
//               /// PRODUCT SELECTOR
//               ItemDetailsDropdown(
//                 onItemSelected: (item) {
//                   setState(() => selectedProduct = item);
//                 },
//               ),
//
//               const SizedBox(height: 10),
//
//               /// QTY + ADD PRODUCT
//               if (selectedProduct != null)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Purchase: ${selectedProduct!.purchasePrice}"),
//                     Text("Unit: ${selectedProduct!.unitId}"),
//                     const SizedBox(height: 10),
//
//                     TextField(
//                       controller: qtyController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         labelText: "Enter Quantity",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//
//                     /// RATE FIELD (NEW)
//                     TextField(
//                       controller: rateController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         labelText: "Enter Rate",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//
//                     const SizedBox(height: 10),
//                     ElevatedButton.icon(
//                       onPressed: addProductToOrder,
//                       icon: const Icon(Icons.add),
//                       label: const Text("Add Product"),
//                     )
//                   ],
//                 ),
//
//               const SizedBox(height: 20),
//
//               /// PRODUCT LIST
//               ...orderItems.map((item) {
//                 return Card(
//                   elevation: 3,
//                   shape:
//                   RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   margin: const EdgeInsets.symmetric(vertical: 6),
//                   child: ListTile(
//                     title: Text(item["itemName"]),
//                     subtitle: Text(
//                         "${item["qty"]} ${item["itemUnit"]} × ${item["rate"]}  =  Rs. ${item["totalAmount"]}"),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () {
//                         setState(() => orderItems.remove(item));
//                       },
//                     ),
//                   ),
//                 );
//               }),
//
//               const SizedBox(height: 20),
//
//               /// UPDATE ORDER BUTTON
//               ElevatedButton(
//                 onPressed: isLoading ? null : updateOrder,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.secondary,
//                   padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 35),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: isLoading
//                     ? const SizedBox(
//                   height: 24,
//                   width: 24,
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 1,
//                   ),
//                 )
//                     : const Text(
//                   "Update Order",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               ),
//
//
//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
