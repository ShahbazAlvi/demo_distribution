import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Provider/CustomerProvider/CustomerProvider.dart';
import '../../Provider/SaleManProvider/SaleManProvider.dart';
import '../../compoents/AppButton.dart';
import '../../compoents/AppColors.dart';
import '../../compoents/AppTextfield.dart';
import '../../compoents/SaleManDropdown.dart';

class UpdateCustomerScreen extends StatefulWidget {
  final Map customer;

  const UpdateCustomerScreen({super.key, required this.customer});

  @override
  State<UpdateCustomerScreen> createState() => _UpdateCustomerScreenState();
}

class _UpdateCustomerScreenState extends State<UpdateCustomerScreen> {
  String? selectedSalesmanId;
  String paymentType = "Credit";
  String? selectedDate;

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<CustomerProvider>(context, listen: false);

    provider.AreaNameController.text = widget.customer["salesArea"];
    provider.CustomerNameController.text = widget.customer["customerName"];
    provider.AddressController.text = widget.customer["address"];
    provider.ContactNumberController.text = widget.customer["phoneNumber"];
    provider.OpeningBalanceController.text = widget.customer["salesBalance"].toString();
    provider.CreditCashLimitController.text = widget.customer["creditLimit"].toString();
    provider.CreditDaysLimitController.text = widget.customer["creditTime"].toString();

    selectedSalesmanId = widget.customer["salesman"];
    selectedDate = widget.customer["openingBalanceDate"];
    paymentType = widget.customer["paymentTerms"];

    Future.microtask(() =>
        Provider.of<SaleManProvider>(context, listen: false).fetchEmployees());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.text),
        title: const Text("Update Customer",style: TextStyle(color: AppColors.text),),
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(controller: provider.AreaNameController, label: "Area Name", validator: (value) {  },),
            SizedBox(height: 10),

            Text("Select Salesman"),
            SalesmanDropdown(
              selectedId: selectedSalesmanId,
              onChanged: (value) {
                setState(() => selectedSalesmanId = value);
              },
            ),
            SizedBox(height: 10),

            AppTextField(controller: provider.CustomerNameController, label: "Customer Name", validator: (value) {  },),
            SizedBox(height: 10),

            AppTextField(controller: provider.ContactNumberController, label: "Phone Number", validator: (value) {  },),
            SizedBox(height: 10),

            AppTextField(controller: provider.AddressController, label: "Address", validator: (value) {  },),
            SizedBox(height: 10),

            AppTextField(controller: provider.OpeningBalanceController, label: "Sales Balance", validator: (value) {  },),
            SizedBox(height: 10),

            // GestureDetector(
            //   onTap: () async {
            //     DateTime? picked = await showDatePicker(
            //       context: context,
            //       initialDate: DateTime.parse(selectedDate!),
            //       firstDate: DateTime(2020),
            //       lastDate: DateTime(2030),
            //     );
            //
            //     if (picked != null) {
            //       selectedDate = DateFormat('yyyy-MM-dd').format(picked);
            //       setState(() {});
            //     }
            //   },
            //   child: Container(
            //     padding: EdgeInsets.all(14),
            //     decoration: BoxDecoration(
            //       color: Colors.grey.shade200,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(selectedDate ?? "Select Date"),
            //         Icon(Icons.calendar_month),
            //       ],
            //     ),
            //   ),
            // ),
          GestureDetector(
            onTap: () async {
              DateTime initialDate;

              // Safely convert your selectedDate (String) to DateTime
              try {
                initialDate = DateTime.parse(selectedDate ?? "");
              } catch (e) {
                initialDate = DateTime.now();
              }

              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );

              if (picked != null) {
                selectedDate = DateFormat('yyyy-MM-dd').format(picked); // backend-friendly
                setState(() {});
              }
            },
            child: Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate == null
                        ? "Select Date"
                        : DateFormat('dd-MM-yyyy').format(
                      DateTime.parse(selectedDate!), // simple date for UI
                    ),
                  ),
                  Icon(Icons.calendar_month),
                ],
              ),
            ),
          ),


          SizedBox(height: 10),

            Text("Payment Terms"),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text("Credit"),
                    value: "Credit",
                    activeColor: AppColors.secondary,
                    groupValue: paymentType,
                    onChanged: (v) {
                      setState(() => paymentType = v.toString());
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text("Cash"),
                    value: "Cash",
                    activeColor: AppColors.secondary,
                    groupValue: paymentType,
                    onChanged: (v) {
                      setState(() => paymentType = v.toString());
                    },
                  ),
                ),
              ],
            ),

            AppTextField(controller: provider.CreditDaysLimitController, label: "Credit Days", validator: (value) {  },),
            SizedBox(height: 10),

            AppTextField(controller: provider.CreditCashLimitController, label: "Credit Limit", validator: (value) {  },),
            SizedBox(height: 20),

            AppButton(
              title:provider.isLoading ?"Loading...": "Update Customer",
              press: () async {
                final success = await provider.updateCustomer(
                  id: widget.customer["_id"],
                  salesmanId: selectedSalesmanId!,
                  paymentType: paymentType,
                  openingBalanceDate: selectedDate!,
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Customer Updated Successfully")),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed: ${provider.error}")),
                  );
                }
              }, width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
