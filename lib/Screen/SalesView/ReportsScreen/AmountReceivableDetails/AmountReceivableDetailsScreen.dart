import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/AmountReceivableDetailsProvider/AmountReceivableDetailsProvider.dart';
import '../../../../compoents/AppColors.dart';


class ReceivableScreen extends StatelessWidget {
  const ReceivableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Amount Receivable Details",
            style: TextStyle(color: Colors.white, fontSize: 22)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [

            // ✅ Radio Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _radioItem(context, true, "With Zero"),
                const SizedBox(width: 20),
                _radioItem(context, false, "Without Zero"),
              ],
            ),

            const SizedBox(height: 10),

            // ✅ Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Customer',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                context.read<ReceivableProvider>().updateSearch(value);
              },
            ),

            const SizedBox(height: 15),

            // ✅ List View
            Expanded(
              child: Consumer<ReceivableProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (provider.filteredList.isEmpty) {
                    return const Center(child: Text("No Data Found"));
                  }

                  return ListView.builder(
                    itemCount: provider.filteredList.length,
                    itemBuilder: (context, index) {
                      final item = provider.filteredList[index];

                      return Card(
                        child: ListTile(
                          title: Text(item.customer),
                          subtitle: Text('Balance: ${item.balance}'),
                          leading: CircleAvatar(
                            child: Text(item.sr.toString()),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _radioItem(BuildContext context, bool value, String text) {
    final provider = context.watch<ReceivableProvider>();

    return Row(
      children: [
        Radio(
          value: value,
          groupValue: provider.withZero,
          onChanged: (v) => provider.updateWithZero(v!),
        ),
        Text(text),
      ],
    );
  }
}
