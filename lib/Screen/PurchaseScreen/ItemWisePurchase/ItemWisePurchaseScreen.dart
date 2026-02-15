import 'package:flutter/material.dart';

import '../../../compoents/itemDropdown.dart';

class ItemFilterScreen extends StatefulWidget {
  const ItemFilterScreen({super.key});

  @override
  State<ItemFilterScreen> createState() => _ItemFilterScreenState();
}

class _ItemFilterScreenState extends State<ItemFilterScreen> {
  String? selectedItemName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filter by Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ItemDropdown(
              selectedItemName: selectedItemName,
              onSelected: (name) {
                setState(() => selectedItemName = name);
                print("API Call with Product Name: $name"); // send name to API
              },
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedItemName == null
                  ? null
                  : () {
                // Call your API with selected item ID
                print("API Call with Product ID: $selectedItemName");
              },
              child: const Text("Search"),
            ),
          ],
        ),
      ),
    );
  }
}
