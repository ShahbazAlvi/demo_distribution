
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Provider/OrderTakingProvider/OrderTakingProvider.dart';
import '../../../Provider/SaleManProvider/SaleManProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/Customerdropdown.dart';
import '../../../compoents/ProductDropdown.dart';
import '../../../compoents/SaleManDropdown.dart';

import '../../../model/CustomerModel/CustomerModel.dart';
import '../../../model/CustomerModel/CustomersDefineModel.dart';
import '../../../model/OrderTakingModel/OrderTakingModel.dart';
import '../../../model/ProductModel/itemsdetailsModel.dart';

class AddOrderScreen extends StatefulWidget {
  final String nextOrderId;
  final OrderData? existingOrder;
  final bool isUpdate;


  const AddOrderScreen({
    super.key,
    required this.nextOrderId,
    this.existingOrder,
    this.isUpdate = false,
  });

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  late String currentDate;
  bool isLoading = false;


  String? selectedSalesmanId;
  CustomerData? selectedCustomer;

  ItemDetails? selectedProduct;


  final TextEditingController qtyController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  List<Map<String, dynamic>> orderItems = [];

  @override
  void dispose() {
    qtyController.dispose();
    super.dispose();
  }

  @override
  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 🔥 ALWAYS load salesmen
    Future.microtask(() =>
        context.read<SaleManProvider>().fetchEmployees());

    if (widget.isUpdate && widget.existingOrder != null) {
      final order = widget.existingOrder!;

      // 🔥 FIX 2 (see below)
      selectedSalesmanId = order.salesmanId?.toString();
    }
  }

  double get grandTotal {
    return orderItems.fold(0.0, (sum, item) {
      bool isNew = item.containsKey("product");

      double total = isNew ? item["total"] : item["totalAmount"];

      return sum + total;
    });
  }


  void addProductToOrder() {
    if (selectedProduct != null && qtyController.text.isNotEmpty) {
      final qty = double.tryParse(qtyController.text) ?? 0;
      final price = double.tryParse(rateController.text)?? 0;
      final total = price * qty;

      setState(() {
        orderItems.add({
          "product": selectedProduct!,
          "qty": qty,
          "price": price,
          "total": total,
        });
      });

      qtyController.clear();
      selectedProduct = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderTakingProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Order Taking",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            )),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ✅ Order ID & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order ID: ${widget.nextOrderId}"),
                Text("Date: $currentDate"),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),

            /// ✅ Salesman
            Text("Select Salesman",style: TextStyle(fontWeight:FontWeight.bold),),
            SizedBox(height: 5,),
            SalesmanDropdown(
              selectedId: selectedSalesmanId,
              onChanged: (value) {
                setState(() => selectedSalesmanId = value);
              },
            ),
            const SizedBox(height: 30),

            /// ✅ Customer
            CustomerDropdown(
              selectedCustomerId: selectedCustomer?.id, // ✅ use ?. instead of !.
              onChanged: (customer) {
                setState(() => selectedCustomer = customer);
              },
            ),




            const SizedBox(height: 20),

            /// ✅ Product Dropdown
            ItemDetailsDropdown(
              onItemSelected: (item) {
                setState(() => selectedProduct = item);
              },
            ),
            const SizedBox(height: 10),

            /// ✅ Product Quantity & Add button
            if (selectedProduct != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("SalePrice: ${selectedProduct!.salePrice}"),
                  //Text("Price: ${selectedProduct!.price}"),

                  const SizedBox(height: 8),

                  TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter Quantity",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: rateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter Rate",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  ElevatedButton.icon(
                    onPressed: addProductToOrder,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Product"),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            /// ✅ Product List
            if (orderItems.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Added Products",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...orderItems.map((item) {
                    final isNew = item.containsKey("product");
                    String itemName;
                    String unit;
                    double price;
                    double qty;
                    double total;
                    double purchase;

                    if (isNew) {
                      final product = item["product"] as ItemDetails;
                      itemName = product.name;
                      unit = product.unitId.toString();
                      price = item["price"] ?? product.salePrice; // use local price if exists
                      qty = item["qty"];
                      total = item["total"];
                      purchase = product.purchasePrice;
                    } else {
                      itemName = item["itemName"];
                      unit = item["itemUnit"];
                      price = item["rate"].toDouble();
                      qty = item["qty"];
                      total = item["totalAmount"];
                      purchase = item["purchase"].toDouble();
                    }

                    return Card(
                      elevation: 6,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title + Delete Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    itemName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red.shade400, size: 22),
                                    onPressed: () {
                                      setState(() {
                                        orderItems.remove(item);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Purchase: $purchase",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Unit + Price badges
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "Qty: $qty",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "Price: $price",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "Total: $total",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Qty + Total (highlighted)


                          ],
                        ),
                      ),
                    );


                  }),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Grand Total:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        grandTotal.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),





                ],
              ),
            const SizedBox(height: 20),

            /// ✅ Final Button (Create/Update)

            // ElevatedButton(
            //   onPressed: () async {
            //
            //     // 🔥 Build final product list (works for new + update)
            //     final productList = orderItems.map((item) {
            //       bool isNew = item.containsKey("product");
            //
            //       String itemName;
            //       String unit;
            //       double qty;
            //       double rate;
            //       double total;
            //
            //       if (isNew) {
            //         // New items
            //         final p = item["product"] as ItemDetails;
            //
            //         itemName = p.itemName;
            //         unit = p.itemUnit?.unitName ?? "";
            //         qty = item["qty"];
            //         rate = item["price"] ?? p.price.toDouble();   // ← user-edited price
            //         total = item["total"];
            //       } else {
            //         // Updated OLD items
            //         itemName = item["itemName"];
            //         unit = item["itemUnit"];
            //         qty = item["qty"];
            //         rate = (item["rate"] as num).toDouble();
            //         total = item["totalAmount"];
            //       }
            //
            //       return {
            //         "itemName": itemName,
            //         "qty": qty,
            //         "itemUnit": unit,
            //         "rate": rate,
            //         "totalAmount": total,
            //       };
            //     }).toList();
            //
            //     // 🔥 Submit
            //     if (widget.isUpdate) {
            //       await orderProvider.updateOrder(
            //         widget.existingOrder!.id,
            //         {
            //           "salesmanId": selectedSalesmanId,
            //           "customerId": selectedCustomer!.id,
            //           "products": productList,
            //         },
            //       );
            //     } else {
            //       await orderProvider.createOrder(
            //         orderId: widget.nextOrderId,
            //         salesmanId: selectedSalesmanId!,
            //         customerId: selectedCustomer!.id,
            //         products: productList,
            //       );
            //     }
            //
            //     Navigator.pop(context);
            //   },
            //   child: Text(widget.isUpdate ? "Update Order" : "Create Order"),
            // ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                if (selectedSalesmanId == null || selectedCustomer == null || orderItems.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields and add products")),
                  );
                  return;
                }

                setState(() => isLoading = true);

                try {
                  await orderProvider.createOrder(
                    orderId: widget.nextOrderId,
                    salesmanId: selectedSalesmanId!,
                    customerId: selectedCustomer!.id.toString(),
                    products: orderItems,
                  );

                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                } finally {
                  setState(() => isLoading = false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                minimumSize: const Size(double.infinity, 60),
              ),
              child: isLoading
                  ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: AppColors.secondary,
                  strokeWidth: 1,
                ),
              )
                  : Text(widget.isUpdate ? "Update Order" : "Create Order", style: const TextStyle(color: Colors.white)),
            )



          ],
        ),
      ),
    );
  }
}
