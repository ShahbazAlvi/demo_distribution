
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../model/ProductModel/itemsdetailsModel.dart';
import '../Provider/ProductProvider/ItemListsProvider.dart';


class ItemDetailsDropdown extends StatefulWidget {
  final Function(ItemDetails) onItemSelected;

  const ItemDetailsDropdown({super.key, required this.onItemSelected});

  @override
  State<ItemDetailsDropdown> createState() => _ItemDetailsDropdownState();
}

class _ItemDetailsDropdownState extends State<ItemDetailsDropdown> {
  ItemDetails? selectedItem;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ItemDetailsProvider>(context, listen: false).fetchItems());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemDetailsProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Product",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),

        provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : DropdownButtonFormField<ItemDetails>(
          value: selectedItem,
          isExpanded: true,
          hint: const Text("Choose Product"),
          items: provider.items.map((item) {
            return DropdownMenuItem<ItemDetails>(
              value: item,
              child: Row(
                children: [
                  // ✅ Product Image

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      "${item.name} (${item.unitId})",  // ✅ Safe
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedItem = value;
            });
            if (value != null) widget.onItemSelected(value);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
