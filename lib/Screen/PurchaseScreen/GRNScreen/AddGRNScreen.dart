// import 'dart:convert';
// import 'package:distribution/ApiLink/ApiEndpoint.dart';
// import 'package:distribution/compoents/AppColors.dart';
// import 'package:distribution/compoents/SupplierDropdown.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AddGRNScreen extends StatefulWidget {
//   final String nextGrnId;
//   const AddGRNScreen({super.key, required this.nextGrnId});
//
//   @override
//   State<AddGRNScreen> createState() => _AddGRNScreenState();
// }
//
// class _AddGRNScreenState extends State<AddGRNScreen> {
//   late String currentDate;
//   String? selectedSupplierId;
//   Map<String, dynamic>? selectedSupplierDetails;
//   ItemDetails? selectedProduct;
//   for (var p in order.products) {
//   orderItems.add({
//   "itemName": p.itemName,
//   "qty": p.qty.toDouble(),
//   "itemUnit": p.itemUnit,
//   "rate": p.rate,
//   "totalAmount": p.totalAmount,
//   });
//   }
//   void addProductToOrder() {
//   if (selectedProduct != null && qtyController.text.isNotEmpty) {
//   final qty = double.tryParse(qtyController.text) ?? 0;
//   final total = selectedProduct!.price * qty;
//
//   setState(() {
//   orderItems.add({
//   "product": selectedProduct!,
//   "qty": qty,
//   "total": total,
//   });
//   });
//
//   qtyController.clear();
//   selectedProduct = null;
//   }
//   }
//
//   final TextEditingController itemController = TextEditingController();
//   final TextEditingController qtyController = TextEditingController();
//   final TextEditingController rateController = TextEditingController();
//
//   List<Map<String, dynamic>> productList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   }
//
//   void addProduct() {
//     if (itemController.text.isEmpty ||
//         qtyController.text.isEmpty ||
//         rateController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("⚠️ Please enter item, qty & rate")),
//       );
//       return;
//     }
//
//     final qty = double.tryParse(qtyController.text) ?? 0;
//     final rate = double.tryParse(rateController.text) ?? 0;
//     final total = qty * rate;
//
//     setState(() {
//       productList.add({
//         "item": itemController.text,
//         "qty": qty,
//         "rate": rate,
//         "total": total,
//       });
//     });
//
//     itemController.clear();
//     qtyController.clear();
//     rateController.clear();
//   }
//
//   double get totalAmount {
//     return productList.fold(0, (sum, item) => sum + item["total"]);
//   }
//
//   Future<void> saveGRN() async {
//     if (selectedSupplierId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("⚠️ Please select a supplier")),
//       );
//       return;
//     }
//     if (productList.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("⚠️ Please add at least one product")),
//       );
//       return;
//     }
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');
//
//       if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("❌ Token not found")),
//         );
//         return;
//       }
//
//       final url = Uri.parse("${ApiEndpoints.baseUrl}/grn");
//
//       final body = {
//         "grnDate": currentDate,
//         "supplierId": selectedSupplierId,
//         "products": productList,
//         "totalAmount": totalAmount,
//       };
//
//       final response = await http.post(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode(body),
//       );
//
//       final data = jsonDecode(response.body);
//
//       if (response.statusCode == 200 && data["success"] == true) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("✅ GRN ${widget.nextGrnId} saved successfully!"),
//             backgroundColor: Colors.green,
//           ),
//         );
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("❌ Failed to save GRN: ${data["message"] ?? 'Error'}")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error: $e")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           "Add New GRN",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//             letterSpacing: 1.2,
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
//
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // GRN Info
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.deepPurple.shade50,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("GRN ID: ${widget.nextGrnId}",
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//                   const SizedBox(height: 6),
//                   Text("Date: $currentDate",
//                       style: const TextStyle(fontSize: 16, color: Colors.black54)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Supplier Dropdown
//             SupplierDropdown(
//               selectedSupplierId: selectedSupplierId,
//               onSelected: (id) {
//                 setState(() {
//                   selectedSupplierId = id;
//                   // Example: Fetch supplier details if available in your model
//                   selectedSupplierDetails = {
//                     "balance": 50000,
//                     "address": "Industrial Area, Lahore",
//                     "phone": "0300-1234567"
//                   };
//                 });
//               },
//             ),
//
//             if (selectedSupplierDetails != null) ...[
//               const SizedBox(height: 10),
//               Card(
//                 color: Colors.grey.shade100,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("📞 Phone: ${selectedSupplierDetails!["phone"]}"),
//                       Text("🏠 Address: ${selectedSupplierDetails!["address"]}"),
//                       Text("💰 Balance: ${selectedSupplierDetails!["balance"]}"),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//
//             const SizedBox(height: 20),
//
//             // Product Add Section
//             const Text("Add Product", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//             const SizedBox(height: 10),
//
//             // TextField(
//             //   controller: itemController,
//             //   decoration: const InputDecoration(
//             //     labelText: "Item Name",
//             //     border: OutlineInputBorder(),
//             //   ),
//             // ),
//             // const SizedBox(height: 10),
//             //
//             // TextField(
//             //   controller: qtyController,
//             //   keyboardType: TextInputType.number,
//             //   decoration: const InputDecoration(
//             //     labelText: "Quantity",
//             //     border: OutlineInputBorder(),
//             //   ),
//             // ),
//             // const SizedBox(height: 10),
//             //
//             // TextField(
//             //   controller: rateController,
//             //   keyboardType: TextInputType.number,
//             //   decoration: const InputDecoration(
//             //     labelText: "Rate",
//             //     border: OutlineInputBorder(),
//             //   ),
//             // ),
//             /// ✅ Product Dropdown
//             ItemDetailsDropdown(
//               onItemSelected: (item) {
//                 setState(() => selectedProduct = item);
//               },
//             ),
//             const SizedBox(height: 10),
//
//             /// ✅ Product Quantity & Add button
//             if (selectedProduct != null)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Purchase: ${selectedProduct!.purchase}"),
//                   //Text("Price: ${selectedProduct!.price}"),
//                   Text("Unit: ${selectedProduct!.itemUnit?.unitName}"),
//                   const SizedBox(height: 8),
//
//                   TextField(
//                     controller: qtyController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: "Enter Quantity",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//
//                   ElevatedButton.icon(
//                     onPressed: addProductToOrder,
//                     icon: const Icon(Icons.add),
//                     label: const Text("Add Product"),
//                   ),
//                 ],
//               ),
//
//             const SizedBox(height: 20),
//
//             /// ✅ Product List
//             if (orderItems.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Added Products",
//                       style:
//                       TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   ...orderItems.map((item) {
//                     final isNew = item.containsKey("product");
//                     String itemName;
//                     String unit;
//                     double price;
//                     double qty;
//                     double total;
//                     double purchase;
//
//                     if (isNew) {
//                       final product = item["product"] as ItemDetails;
//                       itemName = product.itemName;
//                       unit = product.itemUnit?.unitName ?? "";
//                       price = item["price"] ?? product.price.toDouble(); // use local price if exists
//                       qty = item["qty"];
//                       total = item["total"];
//                       purchase = product.purchase.toDouble();
//                     } else {
//                       itemName = item["itemName"];
//                       unit = item["itemUnit"];
//                       price = item["rate"].toDouble();
//                       qty = item["qty"];
//                       total = item["totalAmount"];
//                       purchase = item["purchase"].toDouble();
//                     }
//
//                     return Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       margin: const EdgeInsets.symmetric(vertical: 6),
//                       color: Colors.grey[50],
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Product name and delete icon
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   itemName,
//                                   style: const TextStyle(
//                                       fontSize: 18, fontWeight: FontWeight.bold),
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.delete, color: Colors.red),
//                                   onPressed: () => setState(() => orderItems.remove(item)),
//                                 ),
//                               ],
//                             ),
//                             Text("Purchase: $purchase"),
//                             const SizedBox(height: 6),
//
//                             // Unit & Editable Price
//                             Row(
//                               children: [
//                                 Chip(
//                                   label: Text("Unit: $unit"),
//                                   backgroundColor: Colors.blue[100],
//                                 ),
//                                 const SizedBox(width: 10),
//                                 SizedBox(
//                                   width: 100,
//                                   child: TextFormField(
//                                     initialValue: price.toString(),
//                                     keyboardType:
//                                     const TextInputType.numberWithOptions(decimal: true),
//                                     decoration: const InputDecoration(
//                                       contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                                       border: OutlineInputBorder(),
//                                       labelText: "Price",
//                                     ),
//                                     onChanged: (v) {
//                                       setState(() {
//                                         final newPrice = double.tryParse(v) ?? 0;
//                                         price = newPrice;
//
//                                         // Save editable price in orderItems map
//                                         if (isNew) {
//                                           item["price"] = newPrice; // ✅ store local editable price
//                                         } else {
//                                           item["rate"] = newPrice;
//                                         }
//
//                                         final newTotal = newPrice * qty;
//                                         item["totalAmount"] = newTotal;
//                                         item["total"] = newTotal;
//                                         total = newTotal;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                             const SizedBox(height: 10),
//
//                             // Quantity Input & Total
//                             Row(
//                               children: [
//                                 const Text("Qty: "),
//                                 SizedBox(
//                                   width: 60,
//                                   child: TextFormField(
//                                     initialValue: qty.toString(),
//                                     keyboardType:
//                                     const TextInputType.numberWithOptions(decimal: true),
//                                     decoration: const InputDecoration(
//                                       contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                                       border: OutlineInputBorder(),
//                                     ),
//                                     onChanged: (v) {
//                                       setState(() {
//                                         final newQty = double.tryParse(v) ?? 0;
//                                         qty = newQty;
//                                         item["qty"] = newQty;
//
//                                         final newTotal = newQty * price;
//                                         item["totalAmount"] = newTotal;
//                                         item["total"] = newTotal;
//                                         total = newTotal;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                                 const SizedBox(width: 20),
//                                 Text(
//                                   "Total: $total",
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold, fontSize: 16),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   })
//
//
//
//
//                 ],
//               ),
//             const SizedBox(height: 20),
//
//
//             const SizedBox(height: 10),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.add),
//               label: const Text("Add Product"),
//               onPressed: addProduct,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 minimumSize: const Size(double.infinity, 45),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Product List
//             if (productList.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Added Products",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   ...productList.map((item) => Card(
//                     child: ListTile(
//                       title: Text(item["item"]),
//                       subtitle: Text("Qty: ${item["qty"]}, Rate: ${item["rate"]}, Total: ${item["total"]}"),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () {
//                           setState(() => productList.remove(item));
//                         },
//                       ),
//                     ),
//                   )),
//                   const SizedBox(height: 10),
//                   Text("Total Amount: $totalAmount",
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
//                 ],
//               ),
//
//             const SizedBox(height: 20),
//
//             // Save Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.save),
//                 label: const Text("Save GRN"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.secondary,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: saveGRN,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../Provider/Purchase_Provider/GRNProvider/GRN_Provider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/ProductDropdown.dart';
import '../../../compoents/SupplierDropdown.dart';
import '../../../model/ProductModel/itemsdetailsModel.dart';

class AddGRNScreen extends StatefulWidget {
  const AddGRNScreen({super.key});

  @override
  State<AddGRNScreen> createState() => _AddGRNScreenState();
}

class _AddGRNScreenState extends State<AddGRNScreen> {
  String? selectedSupplierId;
  ItemDetails? selectedProduct;

  final qtyController = TextEditingController();
  final rateController = TextEditingController();
  double productTotal = 0;

  List<Map<String, dynamic>> selectedProducts = [];
  double grandTotal = 0;

  void calculateTotal() {
    int qty = int.tryParse(qtyController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;
    setState(() {
      productTotal = qty * rate;
    });
  }

  void addProductToList() {
    if (selectedProduct == null ||
        qtyController.text.isEmpty ||
        rateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    selectedProducts.add({
      "item": selectedProduct!.name,
      "qty": int.parse(qtyController.text),
      "rate": double.parse(rateController.text),
      "total": productTotal,
    });

    grandTotal = selectedProducts.fold(
        0, (sum, item) => sum + (item["total"] as double));

    qtyController.clear();
    rateController.clear();
    productTotal = 0;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final grnProvider = Provider.of<GRNProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Add GRN",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- Supplier Dropdown ----------------
            SupplierDropdown(
              onSelected: (id) => selectedSupplierId = id,
            ),
            const SizedBox(height: 15),

            /// ---------------- Product Dropdown ----------------
            ItemDetailsDropdown(
              onItemSelected: (item) {
                selectedProduct = item;
                setState(() {});
              },
            ),

            const SizedBox(height: 20),

            /// ---------------- Qty & Rate Fields ----------------
            if (selectedProduct != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Quantity"),
                  TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => calculateTotal(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Quantity",
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text("Rate"),
                  TextField(
                    controller: rateController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => calculateTotal(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Rate",
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text(
                    "Total: Rs $productTotal",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: addProductToList,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Product"),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            /// ---------------- Selected Products List ----------------
            if (selectedProducts.isNotEmpty)
              Column(
                children: [
                  const Text(
                    "Products",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),

                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                    },
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(color: Colors.black12),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(6),
                            child: Text("Item",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(6),
                            child: Text("Qty",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(6),
                            child: Text("Rate",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(6),
                            child: Text("Total",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),

                      ...selectedProducts.map((p) {
                        return TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(p["item"]),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(p["qty"].toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(p["rate"].toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(p["total"].toString()),
                          ),
                        ]);
                      }).toList(),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Grand Total: Rs $grandTotal",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ),

            const SizedBox(height: 20),

            /// ---------------- Save Button ----------------
            ElevatedButton(
              onPressed: () async {
                if (selectedSupplierId == null || selectedProducts.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Select supplier & add at least 1 product"),
                    ),
                  );
                  return;
                }

                final date = DateFormat("yyyy-MM-dd").format(DateTime.now());

                bool success = await grnProvider.addNewGRN(
                  supplierId: selectedSupplierId!,
                  grnDate: date,
                  products: selectedProducts,
                  totalAmount: grandTotal,
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("GRN Added Successfully")),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to Add GRN")),
                  );
                }
              },
              child: const Text("Save GRN"),
            ),
          ],
        ),
      ),
    );
  }
}

