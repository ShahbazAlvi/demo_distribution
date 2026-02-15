
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/SaleManProvider/SaleManProvider.dart';

class SalesmanDropdown extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const SalesmanDropdown({
    super.key,
    this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaleManProvider>(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.error!.isNotEmpty) {
      return Text("Error: ${provider.error}");
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300, // Background color
        border: Border.all(
          color: Colors.black,       // Border color
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedId,
          isExpanded: true,
          hint: const Text("Select Salesman"),
          items: provider.employees.map((emp) {
            return DropdownMenuItem<String>(
              value: emp.id.toString(),
              child: Text(emp.name),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
