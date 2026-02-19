import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/SupplierProvider/supplierProvider.dart';
import '../../../../compoents/AppColors.dart';
import '../../../../compoents/AppButton.dart';
import '../../../../compoents/AppTextfield.dart';
import '../../../../model/SupplierModel/SupplierModel.dart';

class UpdateSupplierScreen extends StatefulWidget {
  final SupplierModel supplier;

  const UpdateSupplierScreen({super.key, required this.supplier});

  @override
  State<UpdateSupplierScreen> createState() => _UpdateSupplierScreenState();
}

class _UpdateSupplierScreenState extends State<UpdateSupplierScreen> {
  String paymentType = "";

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<SupplierProvider>(context, listen: false);

    // Pre-fill existing supplier data
    provider.nameController.text = widget.supplier.name;
    provider.emailController.text = widget.supplier.email;
    provider.contactController.text = widget.supplier.phone;
    provider.addressController.text = widget.supplier.address;

  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SupplierProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Update Supplier",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 5,
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AppTextField(
                controller: provider.nameController,
                label: "Supplier Name",
                validator: (v) => null,
              ),
              const SizedBox(height: 10),

              AppTextField(
                controller: provider.emailController,
                label: "Email",
                validator: (v) => null,
              ),
              const SizedBox(height: 10),

              AppTextField(
                controller: provider.contactController,
                label: "Contact Number",
                validator: (v) => null,
              ),
              const SizedBox(height: 10),

              AppTextField(
                controller: provider.addressController,
                label: "Address",
                validator: (v) => null,
              ),
              const SizedBox(height: 10),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Payment Terms",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),

              Row(
                children: [
                  Expanded(
                      child: RadioListTile(
                        title: const Text("Credit"),
                        value: "credit",
                        groupValue: paymentType,
                        onChanged: (v) {
                          setState(() => paymentType = v.toString());
                        },
                        activeColor: AppColors.secondary,
                      )
                  ),

                  Expanded(
                    child: RadioListTile(
                      title: const Text("Cash"),
                      value: "cash",
                      groupValue: paymentType,
                      onChanged: (v) {
                        setState(() => paymentType = v.toString());
                      },
                      activeColor: AppColors.secondary,
                    ),
                  ),
                ],
              ),



              const SizedBox(height: 20),

              // AppButton(
              //   title: "Update Supplier",
              //   width: double.infinity,
              //   press: () async {
              //     if (provider.nameController.text.isEmpty) {
              //       return showMessage("Supplier Name is required");
              //     }
              //     if (provider.emailController.text.isEmpty) {
              //       return showMessage("Email is required");
              //     }
              //     if (provider.contactController.text.isEmpty) {
              //       return showMessage("Contact Number is required");
              //     }
              //     if (provider.addressController.text.isEmpty) {
              //       return showMessage("Address is required");
              //     }
              //
              //     bool success = await provider.updateSupplier(
              //       id: widget.supplier.id.toString(),
              //       name: provider.nameController.text.trim(),
              //       email: provider.emailController.text.trim(),
              //       phone: provider.contactController.text.trim(),
              //       address: provider.addressController.text.trim(),
              //       paymentTerms: paymentType == "credit" ? "Credit" : "Cash",
              //     );
              //
              //     if (success) {
              //       showMessage("Supplier Updated Successfully");
              //       Navigator.pop(context);
              //     } else {
              //       showMessage("Error updating supplier");
              //     }
              //   },
              //
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.blue),
    );
  }
}
