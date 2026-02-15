
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/SaleManProvider/SaleManProvider.dart';
import '../../../../compoents/AppButton.dart';
import '../../../../compoents/AppColors.dart';
import '../../../../compoents/AppTextfield.dart';

class EmployeeAddScreen extends StatefulWidget {
  const EmployeeAddScreen({super.key});

  @override
  State<EmployeeAddScreen> createState() => _EmployeeAddScreenState();
}

class _EmployeeAddScreenState extends State<EmployeeAddScreen> {
  String? selectedGender;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaleManProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            "Add Salesman",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AppTextField(controller: provider.nameController, label: 'Name', validator: (value) => validator(value as String?)),
              const SizedBox(height: 10),
              AppTextField(controller: provider.departmentController, label: "Department", validator: (value) => validator(value as String?)),
              const SizedBox(height: 10),
              AppTextField(controller: provider.addressController, label: "Address", validator: (value) => validator(value as String?)),
              const SizedBox(height: 10),
              AppTextField(controller: provider.cityController, label: 'City', validator: (value) => validator(value as String?)),
              const SizedBox(height: 10),
              AppTextField(controller: provider.phoneController, label: " Phone Number ",validator: (value) => validator(value as String?)),
              const SizedBox(height: 10),
              AppTextField(controller: provider.nicController, label: 'NiC',validator: (value) => validator(value as String?)),
              const SizedBox(height: 10),
              AppTextField(controller: provider.qualificationController, label: 'Qualification', validator: (value) => validator(value as String?)),
              const SizedBox(height: 10),
              AppTextField(controller: provider.bloodController, label: 'Blood Group', validator: (value) => validator(value as String?)),
              const SizedBox(height: 20),

              // 🔘 Gender selection radio buttons
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Gender",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text("Male"),
                            value: "Male",
                            groupValue: selectedGender,
                            activeColor: AppColors.primary,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                              provider.setGender(value!);

                              //provider.gender = value ?? "";
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text("Female"),
                            value: "Female",
                            groupValue: selectedGender,
                            activeColor: AppColors.primary,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                              provider.gender = value ?? "";
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 🔹 Date of Birth Picker
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Date of Birth",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              GestureDetector(
                // onTap: () async {
                //   final DateTime? picked = await showDatePicker(
                //     context: context,
                //     initialDate: provider.dateOfBirth ?? DateTime.now(),
                //     firstDate: DateTime(1950),
                //     lastDate: DateTime.now(),
                //   );
                //   if (picked != null) {
                //     provider.setDateOfBirth(picked);
                //   }
                // },
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: provider.dateOfBirth ?? DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );

                  if (picked != null) {
                    // ---- AGE VALIDATION (15+ years) ----
                    int age = DateTime.now().year - picked.year;

                    if (DateTime.now().month < picked.month ||
                        (DateTime.now().month == picked.month &&
                            DateTime.now().day < picked.day)) {
                      age--;
                    }

                    if (age < 15) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("⚠️ Age must be at least 15 years old."),
                        ),
                      );
                      return; // ❌ Don't update provider
                    }

                    // ✔ Valid age, save to provider
                    provider.setDateOfBirth(picked);
                  }
                },

                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    provider.dateOfBirth == null
                        ? 'Select Date of Birth'
                        : DateFormat('dd-MM-yyyy').format(provider.dateOfBirth!),
                    style: TextStyle(
                      color: provider.dateOfBirth == null ? Colors.grey : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AppButton(title: provider.isLoading
                  ? "Loading...":"Save Salesman", press: () async {
                await provider.createEmployee(context);
              }, width:double.infinity),



            ],
          ),
        ),
      ),

    );
  }
  String? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }
    return null;
  }

}
