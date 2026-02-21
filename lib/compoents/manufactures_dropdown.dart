import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider/manufactures_provider.dart';
import '../model/ProductModel/manufactures_Model.dart';

class ManufacturesDropdown extends StatelessWidget {
  final int? selectedManufactureId;
  final Function(int?) onChanged;
  final bool isRequired;
  final String? hintText;

  const ManufacturesDropdown({
    super.key,
    required this.selectedManufactureId,
    required this.onChanged,
    this.isRequired = false,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ManufacturesProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.manufactures.isEmpty) {
          return const Text("No manufacturers available");
        }

        return DropdownButtonFormField<int>(
          value: selectedManufactureId,
          decoration: InputDecoration(
            labelText: hintText ?? "Select Manufacturer",
            border: const OutlineInputBorder(),
          ),
          items: provider.manufactures.map((ManufacturesModel m) {
            return DropdownMenuItem<int>(
              value: m.id,
              child: Text(m.name),
            );
          }).toList(),
          onChanged: onChanged,
          validator: isRequired
              ? (value) {
            if (value == null) {
              return "Please select manufacturer";
            }
            return null;
          }
              : null,
        );
      },
    );
  }
}