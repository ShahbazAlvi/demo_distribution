// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../Provider/CustomerProvider/CustomerProvider.dart';
// import '../model/CustomerModel/CustomerModel.dart';
// import '../model/CustomerModel/CustomerModel.dart';
// import '../model/CustomerModel/CustomersDefineModel.dart'; // Your CustomerData model
//
// class CustomerDropdown extends StatefulWidget {
//   final int? selectedCustomerId; // Pre-selected customer ID
//   final ValueChanged<CustomerData?> onChanged; // Callback when selection changes
//   final String label;
//   final bool showDetails;
//
//   const CustomerDropdown({
//     super.key,
//     required this.onChanged,
//     this.selectedCustomerId,
//     this.label = "Select Customer",
//     this.showDetails = true,
//   });
//
//   @override
//   State<CustomerDropdown> createState() => _CustomerDropdownState();
// }
//
// class _CustomerDropdownState extends State<CustomerDropdown> {
//   CustomerData? selectedCustomer;
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch customers when widget loads
//     Future.microtask(() =>
//         Provider.of<CustomerProvider>(context, listen: false).fetchCustomers());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CustomerProvider>(context);
//
//     if (provider.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (provider.error!.isNotEmpty) {
//       return Text(provider.error!, style: const TextStyle(color: Colors.red));
//     }
//
//     if (provider.customers.isEmpty) {
//       return const Text("No customers found");
//     }
//
//     // Set initial selection if needed
//     if (widget.selectedCustomerId != null && selectedCustomer == null) {
//       selectedCustomer = provider.customers.firstWhere(
//               (c) => c.id == widget.selectedCustomerId,
//           orElse: () => provider.customers.first);
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(widget.label,
//             style: const TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         DropdownButtonFormField<int>(
//           isExpanded: true,
//           value: selectedCustomer?.id,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.grey.shade100,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           hint: const Text("Choose Customer"),
//           items: provider.customers.map((customer) {
//             return DropdownMenuItem<int>(
//               value: customer.id,
//               child: Text(customer.name),
//             );
//           }).toList(),
//           onChanged: (id) {
//             if (id != null) {
//               selectedCustomer = provider.customers
//                   .firstWhere((c) => c.id == id,);
//               widget.onChanged(selectedCustomer);
//               setState(() {});
//             }
//           },
//         ),
//         const SizedBox(height: 16),
//         if (widget.showDetails && selectedCustomer != null)
//           _buildCustomerInfo(selectedCustomer!),
//       ],
//     );
//   }
//
//   Widget _buildCustomerInfo(CustomerData customer) {
//     final openingBalance =
//         double.tryParse(customer.openingBalance) ?? 0.0;
//     final creditLimit =
//         double.tryParse(customer.creditLimit) ?? 0.0;
//
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(14.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(customer.name,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     color: Colors.black)),
//             const SizedBox(height: 8),
//             Text("📞 Phone: ${customer.phone}"),
//             Text("🏠 Address: ${customer.address}"),
//             Text("💰 Balance: ${openingBalance.toStringAsFixed(2)}"),
//             Text("🕓 Credit Limit: ${creditLimit.toStringAsFixed(2)}"),
//             Text("📅 Created At: ${customer.createdAt}"),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../Provider/CustomerProvider/CustomerProvider.dart';
import '../model/CustomerModel/CustomersDefineModel.dart';

class CustomerDropdown extends StatefulWidget {
  final int? selectedCustomerId;
  final ValueChanged<CustomerData?> onChanged;
  final String label;
  final bool showDetails;
  final bool isRequired;
  final String? hintText;

  const CustomerDropdown({
    super.key,
    required this.onChanged,
    this.selectedCustomerId,
    this.label = "Select Customer",
    this.showDetails = true,
    this.isRequired = false,
    this.hintText = "Choose Customer",
  });

  @override
  State<CustomerDropdown> createState() => _CustomerDropdownState();
}

class _CustomerDropdownState extends State<CustomerDropdown> {
  CustomerData? selectedCustomer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  void _initializeData() {
    Future.microtask(() {
      final provider = Provider.of<CustomerProvider>(context, listen: false);
      provider.fetchCustomers();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<CustomerProvider>(context, listen: false);
      if (provider.hasMore && !provider.isLoading) {
        provider.fetchMoreCustomers();
      }
    }
  }

  @override
  void didUpdateWidget(CustomerDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCustomerId != oldWidget.selectedCustomerId) {
      _updateSelectedCustomer();
    }
  }

  void _updateSelectedCustomer() {
    final provider = Provider.of<CustomerProvider>(context, listen: false);
    if (widget.selectedCustomerId != null && provider.customers.isNotEmpty) {
      selectedCustomer = provider.customers.firstWhere(
            (c) => c.id == widget.selectedCustomerId,
        orElse: () => provider.customers.first,
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<CustomerProvider>(
      builder: (context, provider, child) {
        // Update selected customer if needed
        if (widget.selectedCustomerId != null &&
            selectedCustomer == null &&
            provider.customers.isNotEmpty) {
          _updateSelectedCustomer();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label.isNotEmpty) ...[
              Row(
                children: [
                  Text(
                    widget.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  if (widget.isRequired) ...[
                    const SizedBox(width: 4),
                    Text(
                      '*',
                      style: TextStyle(color: Colors.red[700], fontSize: 16),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
            ],

            if (provider.isLoading && provider.customers.isEmpty)
              _buildShimmerDropdown()
            else if (provider.error != null && provider.error!.isNotEmpty)
              _buildErrorWidget(provider.error!)
            else if (provider.customers.isEmpty)
                _buildEmptyWidget()
              else
                _buildDropdown(theme, provider),

            if (widget.showDetails && selectedCustomer != null) ...[
              const SizedBox(height: 16),
              _buildCustomerInfoCard(selectedCustomer!, theme),
            ],

            if (provider.isLoading && provider.customers.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerDropdown() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              color: Colors.red[700],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Failed to load customers',
                  style: TextStyle(
                    color: Colors.red[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  error,
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<CustomerProvider>().fetchCustomers();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red[700],
              backgroundColor: Colors.red[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              color: Colors.grey[600],
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No customers found',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add a customer to get started',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(ThemeData theme, CustomerProvider provider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<int>(
          value: selectedCustomer?.id,
          isExpanded: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          hint: Text(
            widget.hintText!,
            style: TextStyle(color: Colors.grey[600]),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[700]),
          items: provider.customers.map((customer) {
            return DropdownMenuItem<int>(
              value: customer.id,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: theme.primaryColor.withOpacity(0.1),
                    child: Text(
                      customer.name[0].toUpperCase(),
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (customer.phone.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                size: 12,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  customer.phone,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (id) {
            if (id != null) {
              setState(() {
                selectedCustomer = provider.customers
                    .firstWhere((c) => c.id == id);
              });
              widget.onChanged(selectedCustomer);
            }
          },
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 4,
        ),
      ),
    );
  }

  Widget _buildCustomerInfoCard(CustomerData customer, ThemeData theme) {
    final openingBalance = double.tryParse(customer.openingBalance) ?? 0.0;
    final creditLimit = double.tryParse(customer.creditLimit) ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primaryColor.withOpacity(0.05),
            theme.primaryColor.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.primaryColor.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.business_center,
                    color: theme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Customer ID: ${customer.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.phone, 'Phone', customer.phone),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.location_on, 'Address', customer.address),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.account_balance_wallet,
              'Balance',
              '₹ ${openingBalance.toStringAsFixed(2)}',
              valueColor: openingBalance < 0 ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.credit_card,
              'Credit Limit',
              '₹ ${creditLimit.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.calendar_today,
              'Created',
              _formatDate(customer.createdAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}