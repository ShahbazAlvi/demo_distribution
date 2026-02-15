import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/AreaSaleProvider/AreaSaleProvider.dart';
import '../../../../compoents/AppColors.dart';


class SalesAreaScreen extends StatefulWidget {
  const SalesAreaScreen({super.key});

  @override
  State<SalesAreaScreen> createState() => _SalesAreaScreenState();
}

class _SalesAreaScreenState extends State<SalesAreaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SalesAreaProvider>(context, listen: false)
            .fetchSalesAreas());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            "Sales Areas",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigator.push(context,MaterialPageRoute(builder:(context)=>AddCustomerScreen()));
              },
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: const Text(
                "Add Area",
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
      body: Consumer<SalesAreaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.areas.isEmpty) {
            return const Center(child: Text("No Sales Areas Found"));
          }

          return ListView.builder(
            itemCount: provider.areas.length,
            itemBuilder: (context, index) {
              final area = provider.areas[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(area.salesArea,
                      style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Description: ${area.description}"),
                      Text("Created: ${area.createdAt.substring(0, 10)}"),
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✅ Update Button
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // TODO: Navigate to update form
                        },
                      ),

                      // ✅ Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Provider.of<SalesAreaProvider>(context, listen: false)
                              .deleteSalesArea(area.id);
                        },
                      ),
                    ],
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
