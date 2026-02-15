
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Provider/OrderTakingProvider/OrderTakingProvider.dart';
import '../../../compoents/AppColors.dart';
import 'AddOrder.dart';
import 'UpdateOrderScreen.dart';

class OrderTakingScreen extends StatefulWidget {
  const OrderTakingScreen({super.key});

  @override
  State<OrderTakingScreen> createState() => _OrderTakingScreenState();
}

class _OrderTakingScreenState extends State<OrderTakingScreen> {
  int currentPage = 1;
  int itemsPerPage = 10;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderTakingProvider>(context, listen: false).FetchOrderTaking();
    });
  }


  List getPaginatedData(List data) {
    int start = (currentPage - 1) * itemsPerPage;
    int end = start + itemsPerPage;

    if (start >= data.length) return [];
    if (end > data.length) end = data.length;

    return data.sublist(start, end);
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderTakingProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Order Taking",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                final provider = Provider.of<OrderTakingProvider>(context, listen: false);

                String nextOrderId = "ORD-001"; // Default if no orders found

                // ✅ Check if data exists and not empty
                if (provider.orderData != null && provider.orderData!.data.isNotEmpty) {
                  // ✅ Extract numeric parts from all order IDs
                  final allNumbers = provider.orderData!.data.map((order) {
                    final id = order.soNo?.toString() ?? "";
                    final regex = RegExp(r'ORD-(\d+)$');
                    final match = regex.firstMatch(id);
                    return match != null ? int.tryParse(match.group(1)!) ?? 0 : 0;
                  }).toList();

                  // ✅ Find the maximum existing number
                  final maxNumber = allNumbers.isNotEmpty ? allNumbers.reduce((a, b) => a > b ? a : b) : 0;

                  // ✅ Generate the next order ID
                  final incremented = maxNumber + 1;
                  nextOrderId = "ORD-${incremented.toString().padLeft(3, '0')}";
                }

                print("✅ Last Max Order ID: $nextOrderId");

               // ✅ Navigate to AddOrderScreen with incremented ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddOrderScreen(nextOrderId: nextOrderId),
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
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(child: Text(provider.error!))
          : provider.orderData == null
          ? const Center(child: Text("No data found"))
          : Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Builder(
                    builder: (context) {
                      final paginatedList = getPaginatedData(provider.orderData!.data);
                      return ListView.builder(
                        itemCount: paginatedList.length + 1,   // +1 for pagination row
                        itemBuilder: (context, index) {
                          // 👉 If last index → Show Pagination Buttons
                          if (index == paginatedList.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: currentPage > 1
                                        ? () {
                                      setState(() {
                                        currentPage--;
                                      });
                                    }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondary,
                                    ),
                                    child: const Text("Previous",style: TextStyle(color: AppColors.text),),
                                  ),

                                  const SizedBox(width: 20),

                                  Text(
                                    "Page $currentPage",
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),

                                  const SizedBox(width: 20),

                                  ElevatedButton(
                                    onPressed: (currentPage * itemsPerPage) <
                                        provider.orderData!.data.length
                                        ? () {
                                      setState(() {
                                        currentPage++;
                                      });
                                    }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondary,
                                    ),
                                    child: const Text("Next",style: TextStyle(color: AppColors.text),),
                                  ),
                                ],
                              ),
                            );
                          }

                          // 👉 Normal Order Card
                          final order = paginatedList[index];

                          final salesman = order.salesmanName;
                          final customerName = order.customerName;

                          final orderId = order.soNo;
                          final date = order.orderDate.toLocal().toString().split(' ')[0];


                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Order ID: $orderId",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          date,
                                          style: const TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),
                                  const Divider(),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Salesman: $salesman",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 4),
                                            Text("Customer: $customerName"),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         UpdateOrderScreen(order: order),
                                          //   ),
                                          // );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.betprologo,
                                          padding: const EdgeInsets.all(8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child:
                                        const Icon(Icons.edit, color: AppColors.text),
                                      ),
                                      SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          _confirmDelete(context, order.id);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.Instructions,
                                          padding: const EdgeInsets.all(8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child:
                                        const Icon(Icons.delete, color: AppColors.text),
                                      ),
                                      SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.vertical(top: Radius.circular(20)),
                                            ),
                                            builder: (_) =>
                                                _OrderDetailsSheet(orderId: orderId),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.secondary,
                                          padding: const EdgeInsets.all(8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Icon(Icons.visibility,
                                            color: AppColors.text),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );

                    },
                  ),
                ),
              ),

            ],
          ),
    );
  }
  Future<void> _confirmDelete(BuildContext context, String orderId) async {
    final provider = Provider.of<OrderTakingProvider>(context, listen: false);

    return showDialog(
      context: context,
      barrierDismissible: false, // user cannot close by tapping outside
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            "Delete Order",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to delete this order?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // close dialog first

                await provider.deleteOrder(orderId);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Order deleted successfully")),
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

}

class _OrderDetailsSheet extends StatelessWidget {
  final String orderId;
  const _OrderDetailsSheet({required this.orderId});

  @override
  Widget build(BuildContext context) {
    final provider =
    Provider.of<OrderTakingProvider>(context, listen: false);
    final order =
    provider.orderData!.data.firstWhere((o) => o.soNo == orderId);
    final customer = order.customerId;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text("Order ID: ${order.soNo}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text("Date: ${order.orderDate.toLocal().toString().split(' ')[0]}"),
            Text("Customer: ${order.customerName}"),
            const Divider(),
            const Text("Products:",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            Text("Status: ${order.status}",
                style: const TextStyle(color: Colors.blueAccent)),
          ],
        ),
      ),
    );
  }
}
