import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/CustomerProvider/CustomerProvider.dart';
import '../model/CustomerModel/CustomerModel.dart';
import '../model/CustomerModel/CustomerModel.dart';
import '../model/CustomerModel/CustomersDefineModel.dart'; // Your CustomerData model

class CustomerDropdown extends StatefulWidget {
  final int? selectedCustomerId; // Pre-selected customer ID
  final ValueChanged<CustomerData?> onChanged; // Callback when selection changes
  final String label;
  final bool showDetails;

  const CustomerDropdown({
    super.key,
    required this.onChanged,
    this.selectedCustomerId,
    this.label = "Select Customer",
    this.showDetails = true,
  });

  @override
  State<CustomerDropdown> createState() => _CustomerDropdownState();
}

class _CustomerDropdownState extends State<CustomerDropdown> {
  CustomerData? selectedCustomer;

  @override
  void initState() {
    super.initState();
    // Fetch customers when widget loads
    Future.microtask(() =>
        Provider.of<CustomerProvider>(context, listen: false).fetchCustomers());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error!.isNotEmpty) {
      return Text(provider.error!, style: const TextStyle(color: Colors.red));
    }

    if (provider.customers.isEmpty) {
      return const Text("No customers found");
    }

    // Set initial selection if needed
    if (widget.selectedCustomerId != null && selectedCustomer == null) {
      selectedCustomer = provider.customers.firstWhere(
              (c) => c.id == widget.selectedCustomerId,
          orElse: () => provider.customers.first);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          isExpanded: true,
          value: selectedCustomer?.id,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          hint: const Text("Choose Customer"),
          items: provider.customers.map((customer) {
            return DropdownMenuItem<int>(
              value: customer.id,
              child: Text(customer.name),
            );
          }).toList(),
          onChanged: (id) {
            if (id != null) {
              selectedCustomer = provider.customers
                  .firstWhere((c) => c.id == id,);
              widget.onChanged(selectedCustomer);
              setState(() {});
            }
          },
        ),
        const SizedBox(height: 16),
        if (widget.showDetails && selectedCustomer != null)
          _buildCustomerInfo(selectedCustomer!),
      ],
    );
  }

  Widget _buildCustomerInfo(CustomerData customer) {
    final openingBalance =
        double.tryParse(customer.openingBalance) ?? 0.0;
    final creditLimit =
        double.tryParse(customer.creditLimit) ?? 0.0;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(customer.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black)),
            const SizedBox(height: 8),
            Text("📞 Phone: ${customer.phone}"),
            Text("🏠 Address: ${customer.address}"),
            Text("💰 Balance: ${openingBalance.toStringAsFixed(2)}"),
            Text("🕓 Credit Limit: ${creditLimit.toStringAsFixed(2)}"),
            Text("📅 Created At: ${customer.createdAt}"),
          ],
        ),
      ),
    );
  }
}


