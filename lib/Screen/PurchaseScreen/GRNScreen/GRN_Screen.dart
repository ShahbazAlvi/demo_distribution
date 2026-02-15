import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../Provider/Purchase_Provider/GRNProvider/GRN_Provider.dart';
import '../../../compoents/AppColors.dart';
import 'AddGRNScreen.dart';

class GRNScreen extends StatefulWidget {
  const GRNScreen({super.key});

  @override
  State<GRNScreen> createState() => _GRNScreenState();
}

class _GRNScreenState extends State<GRNScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   Provider.of<GRNProvider>(context, listen: false).getGRNData();
  // }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GRNProvider>(context, listen: false).getGRNData();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Goods Received Note Details",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            )),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton.icon(
              // Inside your ElevatedButton.icon onPressed:
              onPressed: () {
                final provider = Provider.of<GRNProvider>(context, listen: false);

                String nextGrnId = "GRN-001"; // Default

                if (provider.grnList.isNotEmpty) {
                  final allNumbers = provider.grnList.map((grn) {
                    final regex = RegExp(r'GRN-(\d+)$');
                    final match = regex.firstMatch(grn.grnId);
                    return match != null ? int.parse(match.group(1)!) : 0;
                  }).toList();

                  final maxNum = allNumbers.reduce((a, b) => a > b ? a : b);
                  nextGrnId = "GRN-${(maxNum + 1).toString().padLeft(3, '0')}";
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddGRNScreen(),
                  ),
                );
              },

              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: const Text(
                "Add GRN",
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
      body: Consumer<GRNProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.grnList.isEmpty) {
            return const Center(child: Text("No GRN Records Found"));
          }

          return ListView.builder(
            itemCount: provider.grnList.length,
            itemBuilder: (context, index) {
              final grn = provider.grnList[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    "GRN ID: ${grn.grnId}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date: ${DateFormat('yyyy-MM-dd').format(grn.grnDate)}"),
                      Text("Supplier: ${grn.supplier.supplierName}"),
                      Text("Total Amount: ${grn.totalAmount}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete GRN"),
                          content: const Text("Are you sure you want to delete this record?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                provider.deleteRecord(grn.id);
                                Navigator.pop(context);
                              },
                              child: const Text("Delete", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
