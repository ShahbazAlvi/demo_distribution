
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';
import '../../../../Provider/ProductProvider/ItemCategoriesProvider.dart';
import '../../../../Provider/ProductProvider/ItemListsProvider.dart';
import '../../../../Provider/ProductProvider/ItemTypeProvider.dart';
import '../../../../Provider/ProductProvider/ItemUnitProvider.dart';
import '../../../../compoents/AppButton.dart';
import '../../../../compoents/AppColors.dart';
import '../../../../compoents/AppTextfield.dart';
import '../../../../compoents/ItemCategoriesDropDown.dart';
import '../../../../compoents/ItemTypeDropDown.dart';
import '../../../../compoents/ItemUnitsDropDown.dart';
import 'package:image_picker/image_picker.dart';

class AddItemScreen extends StatefulWidget {
  final String nextItemId; // Pass itemId from ItemListScreen

  const AddItemScreen({super.key, required this.nextItemId});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  String? selectedCategoryId;
  String? selectedTypeId;
  String? selectedUnitId;

  final TextEditingController itemNameCtrl = TextEditingController();
  final TextEditingController perUnitCtrl = TextEditingController();
  final TextEditingController reorderCtrl = TextEditingController();
  final TextEditingController itemKindCtrl = TextEditingController();

  File? pickedImage;


  @override
  // void initState() {
  //   super.initState();
  //   Future.microtask(() {
  //     final unitProvider =
  //     Provider.of<ItemUnitProvider>(context, listen: false);
  //
  //     if (unitProvider.units.isEmpty) {
  //       unitProvider.fetchItemUnits();
  //     }
  //
  //     Provider.of<CategoriesProvider>(context, listen: false).fetchCategories();
  //     Provider.of<ItemTypeProvider>(context, listen: false).fetchItemTypes();
  //   });
  // }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final unitProvider = Provider.of<ItemUnitProvider>(context, listen: false);

      if (unitProvider.units.isEmpty) {
        unitProvider.fetchItemUnits();
      }

      Provider.of<CategoriesProvider>(context, listen: false).fetchCategories();
      Provider.of<ItemTypeProvider>(context, listen: false).fetchItemTypes();
    });
  }


  Future pickImage() async {
    // Request permission first
    if (await Permission.photos.request().isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() => pickedImage = File(image.path));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Permission denied")));
    }
  }

  void submit() async {
    final provider = Provider.of<ItemDetailsProvider>(context, listen: false);

    if (itemNameCtrl.text.isEmpty ||
        selectedCategoryId == null ||
        selectedTypeId == null ||
        selectedUnitId == null ||
        pickedImage == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    bool success = await provider.addItem(
      context: context,
      itemId: widget.nextItemId,
      itemName: itemNameCtrl.text,
      itemCategory: selectedCategoryId!,
      itemType: selectedTypeId!,
      itemUnit: selectedUnitId!,
      perUnit: perUnitCtrl.text,
      reorder: reorderCtrl.text,
      itemKind: itemKindCtrl.text,
      itemImage: pickedImage!,
    );

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Item added successfully")));

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(provider.errorMessage ?? "Error")));
    }
  }
  String? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            "Add Items",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            ),
          ),
        ),

        centerTitle: true,
        elevation: 6,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Consumer<ItemDetailsProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AppTextField(controller:itemNameCtrl, label:'Item Name',  validator: (value) => validator(value as String?)),
                const SizedBox(height: 10),
                CategoriesDropdown(selectedId: selectedCategoryId, onChanged: (id) => setState(() => selectedCategoryId = id)),
                const SizedBox(height: 10),
                ItemTypeDropdown(selectedId: selectedTypeId, onSelected: (id) => setState(() => selectedTypeId = id)),
                const SizedBox(height: 10),
                ItemUnitDropdown(selectedId: selectedUnitId, onSelected: (id) => setState(() => selectedUnitId = id)),
                const SizedBox(height: 10),
                AppTextField(controller: perUnitCtrl, label:"Per Unit Price",  validator: (value) => validator(value as String?)),
                const SizedBox(height: 10),
                AppTextField(controller:reorderCtrl, label: "Reorder Level",  validator: (value) => validator(value as String?)),
                const SizedBox(height: 10),
                AppTextField(controller: itemKindCtrl, label: "Item Kind" ,  validator: (value) => validator(value as String?)),
                const SizedBox(height: 20),

                // Row(
                //   children: [
                //     ElevatedButton(
                //       onPressed: pickImage,
                //       child: const Text("Pick Image"),
                //     ),
                //     const SizedBox(width: 10),
                //     Expanded(
                //       child: pickedImage == null
                //           ? const Text("No image selected")
                //           : Text(
                //         pickedImage!.path,
                //         overflow: TextOverflow.ellipsis,
                //       ),
                //     ),
                //   ],
                // ),
                // IMAGE PREVIEW + PICKER
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Item Image",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),

                    // IMAGE PREVIEW BOX
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200,
                      ),
                      child: pickedImage == null
                          ? const Center(child: Text("No Image Selected"))
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          pickedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // PICK IMAGE BUTTON
                    ElevatedButton.icon(
                      onPressed: pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text("Pick Image"),
                    ),
                  ],
                ),


                const SizedBox(height: 30),
                provider.isLoading
                    ? const CircularProgressIndicator()

                :AppButton(title: "Save Item", press:(){
                  submit();
                }, width:double.infinity)
                //     : ElevatedButton(
                //   onPressed: submit,
                //   style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(16)),
                //   child: const Text("Submit Item", style: TextStyle(fontSize: 18)),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
