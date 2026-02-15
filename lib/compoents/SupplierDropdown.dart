import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/SupplierProvider/supplierProvider.dart';
import '../../model/SupplierModel/SupplierModel.dart';

class SupplierDropdown extends StatefulWidget {
  final String? selectedSupplierId;
  final Function(String) onSelected; // ✅ Returns supplier ID

  const SupplierDropdown({
    super.key,
    this.selectedSupplierId,
    required this.onSelected,
  });

  @override
  State<SupplierDropdown> createState() => _SupplierDropdownState();
}

class _SupplierDropdownState extends State<SupplierDropdown> {
  String? selectedId;

  @override
  void initState() {
    super.initState();
    selectedId = widget.selectedSupplierId;

    // Load supplier list if not loaded yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SupplierProvider>(context, listen: false);
      if (provider.suppliers.isEmpty) {
        provider.loadSuppliers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SupplierProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.suppliers.isEmpty) {
          return const Text("No suppliers found");
        }

        return DropdownButtonFormField<String>(
          value: selectedId,
          decoration: const InputDecoration(
            labelText: "Select Supplier",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: provider.suppliers.map((SupplierModel supplier) {
            return DropdownMenuItem<String>(
              value: supplier.id,
              child: Text(supplier.supplierName),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedId = value;
            });
            if (value != null) {
              widget.onSelected(value); // ✅ Return selected ID
            }
          },
        );
      },
    );
  }
}
