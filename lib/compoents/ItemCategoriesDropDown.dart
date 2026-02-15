import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/ProductModel/ItemCategoriesModel.dart';
import '../Provider/ProductProvider/ItemCategoriesProvider.dart';

class CategoriesDropdown extends StatefulWidget {
  final String? selectedId;         // Selected Category ID
  final ValueChanged<String?> onChanged;  // Returns selected ID
  final String label;

  const CategoriesDropdown({
    super.key,
    required this.onChanged,
    this.selectedId,
    this.label = "Select Category",
  });

  @override
  State<CategoriesDropdown> createState() => _CategoriesDropdownState();
}

class _CategoriesDropdownState extends State<CategoriesDropdown> {
  @override
  void initState() {
    super.initState();

    // Fetch categories only once
    final provider = Provider.of<CategoriesProvider>(context, listen: false);
    if (provider.categories.isEmpty) {
      provider.fetchCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: widget.selectedId,
              isExpanded: true,
              hint: Text(widget.label),
              items: provider.categories.map((CategoriesModel category) {
                return DropdownMenuItem<String>(
                  value: category.id,
                  child: Text(category.categoryName ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                widget.onChanged(value);
              },
            ),
          ),
        );
      },
    );
  }
}
