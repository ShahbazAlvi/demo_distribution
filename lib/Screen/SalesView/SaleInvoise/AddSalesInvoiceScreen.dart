

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
      "location_id": 1,
      "invoice_date": DateTime.now().toIso8601String().split("T").first,
      "invoice_type": "CASH",
      "status": "DRAFT",
      "details": provider.selectedOrder!.details.map((item) => {
        "item_id": item.itemId,
        "qty": item.qty,
        "rate": item.rate,
      }).toList(),
    };

    try {
      final response = await http.post(
        Uri.parse("${ApiEndpoints.baseUrl}/sales-invoices-notax"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "x-company-id": "2",
        },
        body: jsonEncode(body),
      );

      print("STATUS => ${response.statusCode}");
      print("BODY => ${response.body}");

      final res = jsonDecode(response.body);

      /// ✅ SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res["message"] ?? "Invoice created successfully"),
            backgroundColor: Colors.green,
          ),
        );

        /// optional → go back
        Navigator.pop(context, true);
      }

      /// ❌ API ERROR
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res["message"] ?? "Failed to create invoice"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      /// ❌ NETWORK / EXCEPTION
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderTakingProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        elevation: 0,
        title: const Text("Create Sales Invoice"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
            ),
          ),
        ),
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔽 ORDER SELECT CARD
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: DropdownButtonFormField<int>(
                value: selectedOrderId,
                decoration: const InputDecoration(
                  labelText: "Select Sales Order",
                  border: OutlineInputBorder(),
                ),
                items: provider.orderData?.data
                    .map(
                      (order) => DropdownMenuItem<int>(
                    value: int.parse(order.id),
                    child: Text(
                        "${order.soNo}  •  ${order.customerName}"),
                  ),
                )
                    .toList(),
                onChanged: (id) {
                  if (id != null) onOrderSelected(id);
                },
              ),
            ),

            const SizedBox(height: 16),

            /// 🔽 ORDER INFO HEADER
            if (provider.selectedOrder != null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.selectedOrder!.customerName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text("Salesman: ${provider.selectedOrder!.salesmanName}"),
                    Text("Order #: ${provider.selectedOrder!.soNo}"),
                  ],
                ),
              ),

            const SizedBox(height: 14),

            /// 🔽 ITEMS LIST
            provider.selectedOrder == null
                ? const Expanded(
              child: Center(child: Text("Select order to continue")),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: provider.selectedOrder!.details.length,
                itemBuilder: (context, index) {
                  final item =
                  provider.selectedOrder!.details[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.12),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.itemName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            /// Qty
                            Expanded(
                              child: TextFormField(
                                initialValue: item.qty.toString(),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Qty",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (val) {
                                  item.qty =
                                      double.tryParse(val) ?? 0;
                                  setState(() => updateLineTotal(item));
                                },
                              ),
                            ),

                            const SizedBox(width: 10),

                            /// Rate
                            Expanded(
                              child: TextFormField(
                                initialValue: item.rate.toString(),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Rate",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (val) {
                                  item.rate =
                                      double.tryParse(val) ?? 0;
                                  setState(() => updateLineTotal(item));
                                },
                              ),
                            ),

                            const SizedBox(width: 10),

                            /// Line Total
                            Expanded(
                              child: Container(
                                height: 56,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                child: Text(
                                  item.lineTotal
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// 🔽 TOTAL + BUTTON
            if (provider.selectedOrder != null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 6,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Grand Total",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          provider.selectedOrder!.details
                              .fold(0.0,
                                  (sum, item) => sum + item.lineTotal)
                              .toStringAsFixed(2),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: createInvoice,
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF1E88E5),
                                Color(0xFF42A5F5)
                              ],
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(12)),
                          ),
                          child: const Center(
                            child: Text("Create Invoice",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

}
