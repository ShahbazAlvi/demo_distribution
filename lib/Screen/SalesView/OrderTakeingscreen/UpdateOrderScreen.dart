import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../Provider/OrderTakingProvider/OrderTakingProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../model/OrderTakingModel/OrderTakingModel.dart';

class UpdateOrderScreen extends StatefulWidget {
  final OrderData order;

  const UpdateOrderScreen({super.key, required this.order});

  @override
  State<UpdateOrderScreen> createState() => _UpdateOrderScreenState();
}

class _UpdateOrderScreenState extends State<UpdateOrderScreen> {
  late TextEditingController soController;
  late TextEditingController dateController;
  late TextEditingController statusController;

  int? selectedCustomerId;
  int? selectedSalesmanId;

  List<Map<String, dynamic>> orderItems = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    soController = TextEditingController(text: widget.order.soNo);
    dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(widget.order.orderDate),
    );
    statusController = TextEditingController(text: widget.order.status);

    selectedCustomerId = widget.order.customerId;
    selectedSalesmanId = widget.order.salesmanId;

    // Load existing order items (replace with API if needed)
    orderItems = [
      {"item_id": 7, "qty": 1, "rate": 100},
    ];
  }

  Future<void> updateOrder() async {
    setState(() => isLoading = true);

    final url = Uri.parse(
        "https://api.distribution.afaqmis.com/api/sales-orders/${widget.order.id}");

    final body = {
      "so_no": soController.text,
      "customer_id": selectedCustomerId,
      "salesman_id": selectedSalesmanId,
      "order_date": dateController.text,
      "status": statusController.text,
      "details": orderItems,
    };

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization":
          "Bearer YOUR_TOKEN_HERE", // 👉 Replace with actual token
          "x-company-id": "2"
        },
        body: jsonEncode(body),
      );

      print("UPDATE RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        if (!mounted) return;

        Provider.of<OrderTakingProvider>(context, listen: false)
            .FetchOrderTaking();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order Updated Successfully")),
        );

        Navigator.pop(context);
      } else {
        throw Exception("Update failed");
      }
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Update Failed")),
      );
    }

    setState(() => isLoading = false);
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.order.orderDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderTakingProvider>(context);

// Get unique customer and salesman lists
    final customers = <Map<String, dynamic>>[];
    final customerIds = <int>{};
    for (var order in provider.orderData?.data ?? []) {
      if (!customerIds.contains(order.customerId)) {
        customerIds.add(order.customerId);
        customers.add({"id": order.customerId, "name": order.customerName});
      }
    }

    final salesmen = <Map<String, dynamic>>[];
    final salesmanIds = <int>{};
    for (var order in provider.orderData?.data ?? []) {
      if (!salesmanIds.contains(order.salesmanId)) {
        salesmanIds.add(order.salesmanId);
        salesmen.add({"id": order.salesmanId, "name": order.salesmanName});
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Order"),
        backgroundColor: AppColors.primary,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Order Number
            TextField(
              controller: soController,
              decoration: const InputDecoration(
                labelText: "Order Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Customer Dropdown
            DropdownButtonFormField<int>(
              value: selectedCustomerId,
              items: customers.map((customer) {
                return DropdownMenuItem(
                  value: customer["id"] as int,
                  child: Text(customer["name"] as String),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedCustomerId = value);
              },
              decoration: const InputDecoration(
                labelText: "Customer",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Salesman Dropdown
            DropdownButtonFormField<int>(
              value: selectedSalesmanId,
              items: salesmen.map((salesman) {
                return DropdownMenuItem(
                  value: salesman["id"] as int,
                  child: Text(salesman["name"] as String),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedSalesmanId = value);
              },
              decoration: const InputDecoration(
                labelText: "Salesman",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Order Date
            TextField(
              controller: dateController,
              readOnly: true,
              onTap: pickDate,
              decoration: const InputDecoration(
                labelText: "Order Date",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 15),

            // Status
            TextField(
              controller: statusController,
              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),

            // Update Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: updateOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
                child: const Text(
                  "Update Order",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
