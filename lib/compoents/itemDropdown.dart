import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/ProductProvider/ItemListsProvider.dart';
import '../../model/ProductModel/itemsdetailsModel.dart';

class ItemDropdown extends StatefulWidget {
  final String? selectedItemName;  // use name instead of id
  final Function(String) onSelected; // Returns selected item name

  const ItemDropdown({
    super.key,
    this.selectedItemName,
    required this.onSelected,
  });

  @override
  State<ItemDropdown> createState() => _ItemDropdownState();
}

class _ItemDropdownState extends State<ItemDropdown> {
  String? selectedName;

  @override
  void initState() {
    super.initState();
    selectedName = widget.selectedItemName;

    // Load items if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ItemDetailsProvider>(context, listen: false);
      if (provider.items.isEmpty) {
        provider.fetchItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemDetailsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.items.isEmpty) {
          return const Text("No items found");
        }

        return DropdownButtonFormField<String>(
          value: selectedName,
          decoration: const InputDecoration(
            labelText: "Select Product",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: provider.items.map((ItemDetails item) {
            return DropdownMenuItem<String>(
              value: item.name,  // ✅ value is item name
              child: Text(item.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedName = value;
            });
            if (value != null) {
              widget.onSelected(value); // ✅ Return selected item name
            }
          },
        );
      },
    );
  }
}
