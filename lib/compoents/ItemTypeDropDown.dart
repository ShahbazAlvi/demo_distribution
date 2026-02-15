// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../Provider/ProductProvider/ItemTypeProvider.dart';
//
// class ItemTypeDropdown extends StatelessWidget {
//   final String? selectedId;               // Selected itemType id
//   final ValueChanged<String?> onChanged;  // Return selected id
//   final String label;
//
//   const ItemTypeDropdown({
//     super.key,
//     this.selectedId,
//     required this.onChanged,
//     this.label = "Select Item Type",
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ItemTypeProvider>(
//       builder: (context, provider, child) {
//         if (provider.loading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (provider.itemTypes.isEmpty) {
//           return const Text("No item types found");
//         }
//
//         return DropdownButtonFormField<String>(
//           value: selectedId,
//           decoration: InputDecoration(
//             labelText: label,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//
//           // Dropdown items
//           items: provider.itemTypes.map((itemType) {
//             return DropdownMenuItem<String>(
//               value: itemType.id,
//               child: Text(itemType.itemTypeName ?? "Unknown"),
//             );
//           }).toList(),
//
//           onChanged: (value) {
//             onChanged(value);      // send selected ID
//           },
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider/ItemTypeProvider.dart';


class ItemTypeDropdown extends StatelessWidget {
  final String? selectedId;
  final Function(String) onSelected;

  const ItemTypeDropdown({
    super.key,
    required this.onSelected,
    this.selectedId,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemTypeProvider>(context);

    return provider.loading
        ? const Center(child: CircularProgressIndicator())
        : DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Select Item Type",
        border: OutlineInputBorder(),
      ),
      value: selectedId,
      items: provider.itemTypes.map((item) {
        return DropdownMenuItem<String>(
          value: item.id,
          child: Text(item.itemTypeName ?? "Unknown"),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) onSelected(value);
      },
    );
  }
}
