import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider/sub_category.dart';
import '../model/ProductModel/Sub_Category_model.dart';



class SubCategoryDropdown extends StatelessWidget {
  final int? selectedSubCategoryId;
  final int? categoryId; // 👈 optional filter
  final Function(int?) onChanged;
  final bool isRequired;
  final String? hintText;

  const SubCategoryDropdown({
    super.key,
    required this.selectedSubCategoryId,
    required this.onChanged,
    this.categoryId,
    this.isRequired = false,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SubCategory>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // 👇 category filter (Purchase Order screen ke liye perfect)
        List<SubCategoryModel> list = provider.subCategories;

        if (categoryId != null) {
          list = list
              .where((e) => e.categoryId == categoryId)
              .toList();
        }

        if (list.isEmpty) {
          return const Text("No sub categories available");
        }

        return DropdownButtonFormField<int>(
          value: selectedSubCategoryId,
          decoration: InputDecoration(
            labelText: hintText ?? "Select Sub Category",
            border: const OutlineInputBorder(),
          ),
          items: list.map((SubCategoryModel sub) {
            return DropdownMenuItem<int>(
              value: sub.id,
              child: Text(sub.name),
            );
          }).toList(),
          onChanged: onChanged,
          validator: isRequired
              ? (value) {
            if (value == null) {
              return "Please select sub category";
            }
            return null;
          }
              : null,
        );
      },
    );
  }
}