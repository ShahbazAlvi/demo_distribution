import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider/ItemUnitProvider.dart';


class ItemUnitDropdown extends StatelessWidget {
  final String? selectedId;             // Selected ID
  final Function(String) onSelected;    // Return ID to screen
  final String label;

  const ItemUnitDropdown({
    super.key,
    required this.onSelected,
    this.selectedId,
    this.label = "Select Item Unit",
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemUnitProvider>(context);

    return provider.loading
        ? const Center(child: CircularProgressIndicator())
        : DropdownButtonFormField<String>(
      value: selectedId,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: provider.units.map((unit) {
        return DropdownMenuItem<String>(
          value: unit.id,
          child: Text(unit.unitName ?? "Unnamed Unit"),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onSelected(value); // Return selected ID
        }
      },
    );
  }
}
