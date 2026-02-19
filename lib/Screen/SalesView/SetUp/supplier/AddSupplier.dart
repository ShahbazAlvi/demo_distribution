
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
              AppTextField(controller: provider.balanceController, label: "opening balance", validator: validator),

              SizedBox(height: 10,),
        

        
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
