

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Provider/OrderTakingProvider/OrderTakingProvider.dart';
import '../../../model/SaleInvoiceModel/InvoiceOrderUpdate.dart';
import '../../../ApiLink/ApiEndpoint.dart';
import 'package:http/http.dart' as http;

class AddSalesInvoiceScreen extends StatefulWidget {
  final String nextOrderId;
  const AddSalesInvoiceScreen({super.key, required this.nextOrderId});

  @override
  State<AddSalesInvoiceScreen> createState() => _AddSalesInvoiceScreenState();
}

class _AddSalesInvoiceScreenState extends State<AddSalesInvoiceScreen> {
  int? selectedOrderId;

  @override
  @override
  void initState() {
    super.initState();
    // Delay the fetch until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderTakingProvider>(context, listen: false).FetchOrderTaking();
    });
  }


  void onOrderSelected(int orderId) async {
    setState(() {
      selectedOrderId = orderId;
    });

    await Provider.of<OrderTakingProvider>(context, listen: false)
        .fetchSingleOrder(orderId);
  }

  void updateLineTotal(OrderDetail item) {
    item.lineTotal = item.qty * item.rate;
  }

  // Create Sales Invoice
  Future<void> createInvoice() async {
    final provider = Provider.of<OrderTakingProvider>(context, listen: false);
    if (provider.selectedOrder == null) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final body = {
      "inv_no": widget.nextOrderId,
      "sales_order_id": provider.selectedOrder!.id,
      "customer_id": provider.selectedOrder!.customerId,
      "salesman_id": provider.selectedOrder!.salesmanId,
      "location_id": 1, // ⭐ replace with valid id
      "invoice_date": DateTime.now().toIso8601String().split("T").first,
      "invoice_type": "CASH",
      "status": "DRAFT",
      "details": provider.selectedOrder!.details.map((item) => {
        "item_id": item.itemId,
        "qty": item.qty,
        "rate": item.rate,
      }).toList(),
    };

    final response = await http.post(
      Uri.parse("${ApiEndpoints.baseUrl}/sales-invoices-notax"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "x-company-id": "2",   // ⭐ VERY IMPORTANT
      },
      body: jsonEncode(body),
    );

    print("STATUS => ${response.statusCode}");
    print("BODY => ${response.body}");
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderTakingProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Sales Invoice")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Dropdown to select order
            DropdownButton<int>(
              hint: const Text("Select Order"),
              value: selectedOrderId,
              items: provider.orderData?.data
                  .map(
                    (order) => DropdownMenuItem<int>(
                  value: int.parse(order.id),
                  child: Text("${order.soNo} - ${order.customerName}"),
                ),
              )
                  .toList(),
              onChanged: (id) {
                if (id != null) onOrderSelected(id);
              },
            ),
            const SizedBox(height: 20),

            // Editable order details
            provider.selectedOrder == null
                ? const SizedBox()
                : Expanded(
              child: ListView.builder(
                itemCount: provider.selectedOrder!.details.length,
                itemBuilder: (context, index) {
                  final item =
                  provider.selectedOrder!.details[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(item.itemName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              // Qty
                              Expanded(
                                child: TextFormField(
                                  initialValue: item.qty.toString(),
                                  keyboardType:
                                  TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: "Qty"),
                                  onChanged: (val) {
                                    item.qty =
                                        double.tryParse(val) ?? 0;
                                    setState(
                                            () => updateLineTotal(item));
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Rate
                              Expanded(
                                child: TextFormField(
                                  initialValue: item.rate.toString(),
                                  keyboardType:
                                  TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: "Rate"),
                                  onChanged: (val) {
                                    item.rate =
                                        double.tryParse(val) ?? 0;
                                    setState(
                                            () => updateLineTotal(item));
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Line total
                              Expanded(
                                child: Text(
                                    "Total: ${item.lineTotal.toStringAsFixed(2)}"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Optional: update order first
                      if (provider.selectedOrder != null) {
                        await provider.updateSelectedOrder();
                        if (provider.error == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Order updated successfully")));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(provider.error!)));
                        }
                      }
                    },
                    child: const Text("Update Order"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => createInvoice(),
                    child: const Text("Create Invoice"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
