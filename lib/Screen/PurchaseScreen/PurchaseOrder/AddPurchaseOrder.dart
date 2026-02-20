// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Provider/SupplierProvider/supplierProvider.dart';
// import '../../../compoents/AppColors.dart';
// import '../../../compoents/ProductDropdown.dart';
// import '../../../model/ProductModel/itemsdetailsModel.dart';
//
// class AddPurchaseOrder extends StatefulWidget {
//   final String nextOrderId;
//   const AddPurchaseOrder({super.key, required this.nextOrderId});
//
//   @override
//   State<AddPurchaseOrder> createState() => _AddPurchaseOrderState();
// }
//
// class _AddPurchaseOrderState extends State<AddPurchaseOrder> {
//   String? selectedSupplierId;
//   String? supplierBalance = "0";
//   ItemDetails? selectedProduct;
//   final TextEditingController rateController = TextEditingController();
//   final TextEditingController qtyController = TextEditingController();
//   List<Map<String, dynamic>> orderItems = [];
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//
//       Provider.of<SupplierProvider>(context, listen: false).loadSuppliers();
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text("Order Taking",
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
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Text(widget.nextOrderId),
//             Consumer<SupplierProvider>(
//               builder: (context, supplierP, _) {
//                 if (supplierP.isLoading) {
//                   return const CircularProgressIndicator();
//                 }
//
//                 return DropdownButtonFormField(
//                   decoration: const InputDecoration(
//                     labelText: "Select Supplier",
//                     border: OutlineInputBorder(),
//                   ),
//                   items: supplierP.suppliers.map((s) {
//                     return DropdownMenuItem(
//                       value: s.id,
//                       child: Text(s.name),
//                     );
//                   }).toList(),
//                   // onChanged: (value) {
//                   //   selectedSupplierId = value;
//                   // },
//                   onChanged: (value) {
//                     setState(() {
//                       selectedSupplierId = value.toString();
//
//                       final supplier = supplierP.suppliers.firstWhere((s) => s.id == value);
//
//                       supplierBalance = supplier.openingBalance.toString(); // <-- supplier balance
//                     });
//                   },
//                 );
//               },
//             ),
//             const SizedBox(height: 6),
//             if (selectedSupplierId != null)
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.person, color: Colors.blue),
//                     const SizedBox(width: 8),
//                     Text(
//                       "Supplier Balance: $supplierBalance",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//
//             const SizedBox(height: 16),
//             _buildSectionTitle('Add Products'),
//             const SizedBox(height: 12),
//             _buildProductSelection(),
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget _buildProductSelection() {
//     return Column(
//       children: [
//         // Product Dropdown
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.08),
//                 spreadRadius: 1,
//                 blurRadius: 6,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: ItemDetailsDropdown(
//             onItemSelected: (item) {
//               setState(() => selectedProduct = item);
//               if (item != null) {
//                 rateController.text = item.purchasePrice?.toString() ?? '';
//               }
//             },
//           ),
//         ),
//
//         if (selectedProduct != null) ...[
//           const SizedBox(height: 16),
//
//           // Selected Product Card
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: AppColors.primary.withOpacity(0.03),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: AppColors.primary.withOpacity(0.2),
//               ),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             selectedProduct!.name ?? 'Selected Product',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'Code: ${selectedProduct!.id ?? 'N/A'}',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.green.shade50,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         'Rs${selectedProduct!.purchasePrice?.toStringAsFixed(2) ?? '0.00'}',
//                         style: TextStyle(
//                           color: Colors.green.shade700,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           // Quantity and Rate Fields
//           Row(
//             children: [
//               Expanded(
//                 child: _buildInputField(
//                   controller: qtyController,
//                   label: 'Quantity',
//                   icon: Icons.format_list_numbered,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildInputField(
//                   controller: rateController,
//                   label: 'Rate (Rs)',
//                   icon: Icons.currency_rupee,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//
//           // Add Product Button
//           SizedBox(
//             width: double.infinity,
//             height: 50,
//             child: ElevatedButton.icon(
//               onPressed: addProductToOrder,
//               icon: const Icon(Icons.add_shopping_cart),
//               label: const Text(
//                 'Add to Order',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ],
//     );
//   }
//   Widget _buildSectionTitle(String title) {
//     return Row(
//       children: [
//         Container(
//           width: 4,
//           height: 24,
//           decoration: BoxDecoration(
//             color: AppColors.primary,
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: TextStyle(
//             fontSize: 13,
//             color: Colors.grey.shade600,
//           ),
//           prefixIcon: Icon(
//             icon,
//             size: 18,
//             color: AppColors.primary,
//           ),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 14,
//           ),
//         ),
//       ),
//     );
//   }
//   void addProductToOrder() {
//     bool alreadyExists = orderItems.any(
//           (item) => item["product"].id == selectedProduct!.id,
//     );
//
//     if (alreadyExists) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Product already added")),
//       );
//       return;
//     }
//     if (selectedProduct != null && qtyController.text.isNotEmpty) {
//       final qty = double.tryParse(qtyController.text) ?? 0;
//       final price = double.tryParse(rateController.text) ??
//           selectedProduct!.purchasePrice?.toDouble() ?? 0;
//       final total = price * qty;
//
//       setState(() {
//         orderItems.add({
//           "product": selectedProduct!,
//           "qty": qty,
//           "price": price,
//           "total": total,
//         });
//       });
//
//       qtyController.clear();
//       rateController.clear();
//       selectedProduct = null;
//     }
//   }
//   void removeProduct(int index) {
//     setState(() {
//       orderItems.removeAt(index);
//     });
//     Widget _buildOrderItemsList() {
//       double grandTotal = 0;
//
//       for (var item in orderItems) {
//         grandTotal += item["total"];
//       }
//
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Order Items"),
//           const SizedBox(height: 10),
//
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: orderItems.length,
//             itemBuilder: (context, index) {
//               final item = orderItems[index];
//               final product = item["product"] as ItemDetails;
//
//               return Card(
//                 margin: const EdgeInsets.only(bottom: 8),
//                 child: ListTile(
//                   title: Text(product.name ?? "Product"),
//                   subtitle: Text(
//                     "Qty: ${item["qty"]}  |  Rate: Rs ${item["price"]}",
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         "Rs ${item["total"].toStringAsFixed(2)}",
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () => removeProduct(index),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           const SizedBox(height: 10),
//
//           /// Grand Total
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.green.shade50,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Grand Total",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 Text(
//                   "Rs ${grandTotal.toStringAsFixed(2)}",
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/SupplierProvider/supplierProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/ProductDropdown.dart';
import '../../../model/ProductModel/itemsdetailsModel.dart';

class AddPurchaseOrder extends StatefulWidget {
  final String nextOrderId;
  const AddPurchaseOrder({super.key, required this.nextOrderId});

  @override
  State<AddPurchaseOrder> createState() => _AddPurchaseOrderState();
}

class _AddPurchaseOrderState extends State<AddPurchaseOrder> {
  String? selectedSupplierId;
  String supplierBalance = "0";

  ItemDetails? selectedProduct;
  String selectedStatus = "DRAFT";

  final List<String> orderStatusList = [
    "DRAFT",
    "APPROVED",
    "CLOSED",
    "CANCELLED",
  ];

  final TextEditingController rateController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  List<Map<String, dynamic>> orderItems = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SupplierProvider>(context, listen: false).loadSuppliers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Add Purchase Order",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order No: ${widget.nextOrderId}",
                style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 14),

            /// SUPPLIER DROPDOWN
            Consumer<SupplierProvider>(
              builder: (context, supplierP, _) {
                if (supplierP.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: "Select Supplier",
                    border: OutlineInputBorder(),
                  ),
                  items: supplierP.suppliers.map((s) {
                    return DropdownMenuItem(
                      value: s.id,
                      child: Text(s.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSupplierId = value.toString();
                      final supplier = supplierP.suppliers
                          .firstWhere((s) => s.id == value);
                      supplierBalance =
                          supplier.openingBalance?.toString() ?? "0";
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 20),


            const SizedBox(height: 8),

            if (selectedSupplierId != null)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Supplier Balance: $supplierBalance",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
            Text(
              "Order Status",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
// status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: DropdownButton<String>(
                value: selectedStatus,
                isExpanded: true,
                underline: const SizedBox(),
                items: orderStatusList.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedStatus = value!);
                },
              ),
            ),

            const SizedBox(height: 20),

            _buildSectionTitle("Add Products"),
            const SizedBox(height: 10),

            _buildProductSelection(),

            const SizedBox(height: 20),

            if (orderItems.isNotEmpty) _buildOrderItemsList(),
          ],
        ),
      ),
    );
  }

  /// PRODUCT SELECTION UI
  Widget _buildProductSelection() {
    return Column(
      children: [
        ItemDetailsDropdown(
          onItemSelected: (item) {
            setState(() => selectedProduct = item);
            if (item != null) {
              rateController.text = item.purchasePrice?.toString() ?? '';
            }
          },
        ),

        if (selectedProduct != null) ...[
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  controller: qtyController,
                  label: "Quantity",
                  icon: Icons.format_list_numbered,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildInputField(
                  controller: rateController,
                  label: "Rate",
                  icon: Icons.currency_rupee,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: addProductToOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text("Add to Order"),
            ),
          )
        ]
      ],
    );
  }

  /// ORDER ITEMS LIST
  Widget _buildOrderItemsList() {
    double grandTotal = 0;
    for (var item in orderItems) {
      grandTotal += item["total"];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Order Items"),
        const SizedBox(height: 10),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orderItems.length,
          itemBuilder: (context, index) {
            final item = orderItems[index];
            final product = item["product"] as ItemDetails;

            return Card(
              child: ListTile(
                title: Text(product.name ?? "Product"),
                subtitle: Text(
                    "Qty: ${item["qty"]} | Rate: Rs ${item["price"]}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Rs ${item["total"].toStringAsFixed(2)}"),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeProduct(index),
                    )
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Grand Total",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Rs ${grandTotal.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  /// ADD PRODUCT
  void addProductToOrder() {
    if (selectedProduct == null || qtyController.text.isEmpty) return;

    bool alreadyExists = orderItems.any(
            (item) => item["product"].id == selectedProduct!.id);

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product already added")),
      );
      return;
    }

    final qty = double.tryParse(qtyController.text) ?? 0;
    final price =
        double.tryParse(rateController.text) ??
            selectedProduct!.purchasePrice?.toDouble() ??
            0;

    final total = qty * price;

    setState(() {
      orderItems.add({
        "product": selectedProduct!,
        "qty": qty,
        "price": price,
        "total": total,
      });

      selectedProduct = null;
      qtyController.clear();
      rateController.clear();
    });
  }

  void removeProduct(int index) {
    setState(() {
      orderItems.removeAt(index);
    });
  }
}