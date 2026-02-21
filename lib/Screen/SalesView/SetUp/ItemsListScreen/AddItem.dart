
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';
import '../../../../Provider/ProductProvider/ItemCategoriesProvider.dart';
import '../../../../Provider/ProductProvider/ItemListsProvider.dart';
import '../../../../Provider/ProductProvider/ItemTypeProvider.dart';
import '../../../../Provider/ProductProvider/ItemUnitProvider.dart';
import '../../../../Provider/ProductProvider/manufactures_provider.dart';
import '../../../../Provider/ProductProvider/sub_category.dart';
import '../../../../compoents/AppButton.dart';
import '../../../../compoents/AppColors.dart';
import '../../../../compoents/AppTextfield.dart';
import '../../../../compoents/ItemCategoriesDropDown.dart';
import '../../../../compoents/ItemTypeDropDown.dart';
import '../../../../compoents/ItemUnitsDropDown.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../compoents/manufactures_dropdown.dart';
import '../../../../compoents/sub_Category.dart';

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
  int? selectedSubCategoryId;
  int? selectedManufactureId;
  final TextEditingController SKUCtrl = TextEditingController();
  final TextEditingController itemNameCtrl = TextEditingController();
  final TextEditingController salesCtrl = TextEditingController();
  final TextEditingController purchaseCtrl = TextEditingController();
  final TextEditingController qntCtrl = TextEditingController();
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
      Provider.of<SubCategory>(context, listen: false).fetchSubCategories();
      final provider =
      Provider.of<ManufacturesProvider>(context, listen: false);

      if (provider.manufactures.isEmpty) {
        provider.fetchManufactures();
      }
    });
  }


  Future pickImage() async {
    // Request permission first
    if (await Permission.photos.request().isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Get the file extension
        final ext = image.path.split('.').last.toLowerCase();

        // Only allow jpg, jpeg, png
        if (ext == 'jpg' || ext == 'jpeg' || ext == 'png') {
          setState(() => pickedImage = File(image.path));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Only PNG or JPEG images are allowed")),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Permission denied")));
    }
  }
  Future pickFromCamera() async {
    if (await Permission.camera.request().isGranted) {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        final ext = image.path.split('.').last.toLowerCase();
        if (ext == 'jpg' || ext == 'jpeg' || ext == 'png') {
          setState(() => pickedImage = File(image.path));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Only PNG or JPEG images are allowed")),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera permission denied")),
      );
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
      sku: SKUCtrl.text,
      name: itemNameCtrl.text,
      itemTypeId: selectedTypeId!,
      categoryId: selectedCategoryId!,
      subCategoryId: selectedSubCategoryId!,
      manufacturerId: selectedManufactureId!,
      unitId: selectedUnitId!,
      minQty: qntCtrl.text,
      purchasePrice: purchaseCtrl.text,
      salePrice: salesCtrl.text,
      image: pickedImage!,
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
                AppTextField(controller:SKUCtrl, label:'SKU',  validator: (value) => validator(value as String?)),
                const SizedBox(height: 10),
                AppTextField(controller:itemNameCtrl, label:'Item Name',  validator: (value) => validator(value as String?)),
                const SizedBox(height: 10),
                CategoriesDropdown(selectedId: selectedCategoryId, onChanged: (id) => setState(() => selectedCategoryId = id)),

                const SizedBox(height: 10),
            SubCategoryDropdown(
            selectedSubCategoryId: selectedSubCategoryId,
            isRequired: true,
            onChanged: (value) {
              setState(() {
                selectedSubCategoryId = value;
              });
            },
          ),
                const SizedBox(height: 10),


            ManufacturesDropdown(
            selectedManufactureId: selectedManufactureId,
            isRequired: true,
            onChanged: (value) {
              setState(() {
                selectedManufactureId = value;
              });
            },
          ),
                const SizedBox(height: 10),
                ItemTypeDropdown(selectedId: selectedTypeId, onSelected: (id) => setState(() => selectedTypeId = id)),
                const SizedBox(height: 10),
                ItemUnitDropdown(selectedId: selectedUnitId, onSelected: (id) => setState(() => selectedUnitId = id)),
                const SizedBox(height: 10),
                AppTextField(controller:qntCtrl, label: "Qnt",  validator: (value) => validator(value as String?)),
                const SizedBox(height: 10),
                AppTextField(controller: purchaseCtrl, label:"Purchase price",  validator: (value) => validator(value as String?)),
                const SizedBox(height: 10),
                AppTextField(controller: salesCtrl, label:"Sale Price",  validator: (value) => validator(value as String?)),
                const SizedBox(height: 10),


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
