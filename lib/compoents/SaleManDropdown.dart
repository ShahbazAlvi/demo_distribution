//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../Provider/SaleManProvider/SaleManProvider.dart';
//
// class SalesmanDropdown extends StatelessWidget {
//   final String? selectedId;
//   final ValueChanged<String?> onChanged;
//
//   const SalesmanDropdown({
//     super.key,
//     this.selectedId,
//     required this.onChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<SaleManProvider>(context);
//
//     if (provider.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (provider.error != null && provider.error!.isNotEmpty) {
//       return Text("Error: ${provider.error}");
//     }
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade300, // Background color
//         border: Border.all(
//           color: Colors.black,       // Border color
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(8), // Rounded corners
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: selectedId,
//           isExpanded: true,
//           hint: const Text("Select Salesman"),
//           items: provider.employees.map((emp) {
//             return DropdownMenuItem<String>(
//               value: emp.id.toString(),
//               child: Text(emp.name),
//             );
//           }).toList(),
//           onChanged: onChanged,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../Provider/SaleManProvider/SaleManProvider.dart';

class SalesmanDropdown extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;
  final String label;
  final bool showLabel;

  const SalesmanDropdown({
    super.key,
    this.selectedId,
    required this.onChanged,
    this.label = 'Select Salesman',
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaleManProvider>(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],

        if (provider.isLoading)
          _buildShimmerDropdown()
        else if (provider.error != null && provider.error!.isNotEmpty)
          _buildErrorWidget(provider.error!)
        else if (provider.employees.isEmpty)
            _buildEmptyWidget()
          else
            _buildDropdown(theme, provider),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: Colors.red[700], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
          const SizedBox(width: 8),
          Text(
            'No salesmen available',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(ThemeData theme, SaleManProvider provider) {
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
        child: DropdownButton<String>(
          value: selectedId,
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Select Salesman',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.keyboard_arrow_down, color: Colors.grey[700]),
          ),
          items: provider.employees.map((emp) {
            return DropdownMenuItem<String>(
              value: emp.id.toString(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                      child: Text(
                        emp.name[0].toUpperCase(),
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
                            emp.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          if (emp.phone != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              emp.phone!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 4,
        ),
      ),
    );
  }
}