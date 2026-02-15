//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../Provider/SaleManProvider/SaleManProvider.dart';
// import '../../../../compoents/AppButton.dart';
// import '../../../../compoents/AppColors.dart';
// import '../../../../compoents/AppTextfield.dart';
// import '../../../../model/SaleManModel/EmployeesModel.dart';
//
// class EmployeeUpdateScreen extends StatefulWidget {
//   final EmployeeData employee;
//
//   const EmployeeUpdateScreen({super.key, required this.employee});
//
//   @override
//   State<EmployeeUpdateScreen> createState() => _EmployeeUpdateScreenState();
// }
//
// class _EmployeeUpdateScreenState extends State<EmployeeUpdateScreen> {
//
//   String? selectedGender;
//
//   @override
//   void initState() {
//     super.initState();
//     final provider = Provider.of<SaleManProvider>(context, listen: false);
//
//     provider.nameController.text = widget.employee.employeeName;
//     provider.departmentController.text = widget.employee.departmentName ?? "";
//     provider.addressController.text = widget.employee.address;
//     provider.cityController.text = widget.employee.city;
//     provider.phoneController.text = widget.employee.mobile;
//     provider.nicController.text = widget.employee.nicNo;
//     provider.qualificationController.text = widget.employee.qualification ?? "";
//     provider.bloodController.text = widget.employee.bloodGroup ?? "";
//
//     selectedGender = widget.employee.gender;
//     provider.gender = widget.employee.gender;
//
//     provider.dateOfBirth = DateTime.tryParse(widget.employee.dob ?? "");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<SaleManProvider>(context);
//
//     return Scaffold(
//       backgroundColor: Color(0xFFEEEEEE),
//       appBar: AppBar(
//         title: const Text("Update Salesman", style: TextStyle(color: Colors.white)),
//         iconTheme: const IconThemeData(color: Colors.white),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.secondary, AppColors.primary],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//
//             AppTextField(
//                 controller: provider.nameController,
//                 label: "Name",
//                 validator: (value) => validator(value)
//             ),
//             const SizedBox(height: 10),
//
//             AppTextField(
//                 controller: provider.departmentController,
//                 label: "Department",
//                 validator: (value) => validator(value)
//             ),
//             const SizedBox(height: 10),
//
//             AppTextField(
//                 controller: provider.addressController,
//                 label: "Address",
//                 validator: (value) => validator(value)
//             ),
//             const SizedBox(height: 10),
//
//             AppTextField(
//                 controller: provider.cityController,
//                 label: "City",
//                 validator: (value) => validator(value)
//             ),
//             const SizedBox(height: 10),
//
//             AppTextField(
//                 controller: provider.phoneController,
//                 label: "Phone Number",
//                 validator: (value) => validator(value)
//             ),
//             const SizedBox(height: 10),
//
//             AppTextField(
//                 controller: provider.nicController,
//                 label: "CNIC",
//                 validator: (value) => validator(value)
//             ),
//             const SizedBox(height: 10),
//
//             AppTextField(
//                 controller: provider.qualificationController,
//                 label: "Qualification",
//                 validator: (value) => validator(value)
//             ),
//             const SizedBox(height: 10),
//
//             AppTextField(
//                 controller: provider.bloodController,
//                 label: "Blood Group",
//                 validator: (value) => validator(value)
//             ),
//             const SizedBox(height: 20),
//
//             // GENDER
//             Row(
//               children: [
//                 Expanded(
//                   child: RadioListTile<String>(
//                     title: const Text("Male"),
//                     value: "Male",
//                     groupValue: selectedGender,
//                     onChanged: (value) {
//                       setState(() {
//                         selectedGender = value;
//                         provider.gender = value!;
//                       });
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: RadioListTile<String>(
//                     title: const Text("Female"),
//                     value: "Female",
//                     groupValue: selectedGender,
//                     onChanged: (value) {
//                       setState(() {
//                         selectedGender = value;
//                         provider.gender = value!;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//
//             // DOB Picker
//             GestureDetector(
//               onTap: () async {
//                 final date = await showDatePicker(
//                   context: context,
//                   initialDate: provider.dateOfBirth ?? DateTime.now(),
//                   firstDate: DateTime(1950),
//                   lastDate: DateTime.now(),
//                 );
//                 if (date != null) provider.setDateOfBirth(date);
//               },
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade400),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   provider.dateOfBirth == null
//                       ? "Select Date of Birth"
//                       : DateFormat('yyyy-MM-dd').format(provider.dateOfBirth!),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             AppButton(
//                 title: provider.isLoading ?"Loading...":"Update Salesman", press: ()async {
//               await provider.updateEmployee(widget.employee.id, context);
//             }, width:double.infinity),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String? validator(String? value) {
//     if (value == null || value.trim().isEmpty) return "Required";
//     return null;
//   }
// }
