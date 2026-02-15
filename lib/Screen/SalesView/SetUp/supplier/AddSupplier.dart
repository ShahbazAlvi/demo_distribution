
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/SupplierProvider/supplierProvider.dart';
import '../../../../compoents/AppButton.dart';
import '../../../../compoents/AppColors.dart';
import '../../../../compoents/AppTextfield.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  String? Function(dynamic value) get validator => (value) => null;
  String paymentType="";
  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<SupplierProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Add Supplier",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            )),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(controller: provider.nameController, label:'Supplier Name', validator: validator),
              SizedBox(height: 10,),
              AppTextField(controller: provider.emailController, label:"Email", validator: validator),
              SizedBox(height: 10,),
              AppTextField(controller: provider.contactController, label: "Contact Number", validator: validator),
              SizedBox(height: 10,),
              AppTextField(controller: provider.addressController, label: "Address", validator: validator),
              SizedBox(height: 10,),
              Text("Payment Terms"),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: Text("Credit"),
                        value: "credit",
                              groupValue: paymentType,
                              activeColor: AppColors.secondary,
                              onChanged: (value) {
                                setState(() {
                                  paymentType = value.toString();
                                });
                              }),
                  ),
                                Expanded(
                                child: RadioListTile(
                                title: Text("Cash"),
                                value: "cash",
                                groupValue: paymentType,
                                activeColor: AppColors.secondary,
                                onChanged: (value) {
                                  setState(() {
                                    paymentType = value.toString();
                                  });
                                }),
                                )
        
                ],
              ),
              SizedBox(height: 10,),
        
              if (paymentType == "credit") ...[
                const SizedBox(height: 10),
                AppTextField(
                  controller: provider.creditDaysController,
                  label: "Credit Days Limit",
                  validator: (v) => null,
                ),
                const SizedBox(height: 10),
        
                AppTextField(
                  controller: provider.creditLimitController,
                  label: "Credit Cash Limit",
                  validator: (v) => null,
                ),
              ],
        
              SizedBox(height: 20,),
              AppButton(
                title: "Save Supplier",
                press: () async {
                  if (provider.nameController.text.isEmpty) {
                    return showMessage("Supplier Name is required");
                  }
                  if (provider.emailController.text.isEmpty) {
                    return showMessage("Email is required");
                  }
                  if (provider.contactController.text.isEmpty) {
                    return showMessage("Contact Number is required");
                  }
                  if (provider.addressController.text.isEmpty) {
                    return showMessage("Address is required");
                  }
                  if (paymentType.isEmpty) {
                    return showMessage("Please select Payment Terms");
                  }
        
                  /// Call Add API
                  bool success = await provider.addSupplier(
                    paymentType: paymentType,
                  );
        
                  if (success) {
                    showMessage("Supplier Added Successfully");
                    Navigator.pop(context);
                  } else {
                    showMessage("Error: ${provider.error}");
                  }
                },
                width: double.infinity,
              )
        
            ],
          ),
        ),
      ),
    );
  }
  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

}
