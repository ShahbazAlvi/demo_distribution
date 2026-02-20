// import 'package:demo_distribution/Provider/BankProvider/BankListProvider.dart';
// import 'package:demo_distribution/compoents/AppTextfield.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Provider/RecoveryProvider/RecoveryProvider.dart';
// import '../../../Provider/SaleManProvider/SaleManProvider.dart';
// import '../../../compoents/AppColors.dart';
// import '../../../compoents/BankDropDown.dart';
// import '../../../compoents/Customerdropdown.dart';
// import '../../../compoents/SaleManDropdown.dart';
// import '../../../model/BankModel/BankListModel.dart';
// import '../../../model/CustomerModel/CustomersDefineModel.dart';
//
// class AddRecoveryScreen extends StatefulWidget {
//   final String nextOrderId;
//   const AddRecoveryScreen({super.key, required this.nextOrderId});
//
//   @override
//   State<AddRecoveryScreen> createState() => _AddRecoveryScreenState();
// }
//
// class _AddRecoveryScreenState extends State<AddRecoveryScreen> {
//   CustomerData? selectedCustomer;
//   String? selectedSalesmanId;
//   BankData? selectedBank;
//   bool isLoading = false;
//   final TextEditingController amountController=TextEditingController();
//   @override
//   @override
//   void initState() {
//     super.initState();
//     final provider = Provider.of<SaleManProvider>(context, listen: false);
//     final bprovider = Provider.of<BankProvider>(context, listen: false);
//     provider.fetchEmployees(); // <-- fetch data
//     bprovider.fetchBanks();
//   }
//
//   @override
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Add Recovery",
//             style: TextStyle(color: Colors.white, fontSize: 22)),
//         centerTitle: true,
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
//
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(widget.nextOrderId),
//               CustomerDropdown(
//                 selectedCustomerId: selectedCustomer?.id, // ✅ use ?. instead of !.
//                 onChanged: (customer) {
//                   setState(() => selectedCustomer = customer);
//                 },
//               ),
//               SalesmanDropdown(
//                 selectedId: selectedSalesmanId,
//                 onChanged: (value) {
//                   setState(() => selectedSalesmanId = value);
//                 },
//               ),
//           SizedBox(height: 20,),
//           BankDropdown(
//           selectedBank: selectedBank,
//           onChanged: (bank) {
//             setState(() {
//               selectedBank = bank;
//               print("Selected Bank: ${bank?.name}");
//             });
//           },
//                 ),
//               SizedBox(height: 20,),
//
//               AppTextField(controller: amountController, label: 'Amount',validator: (v) => v!.isEmpty ? "Enter balance" : null ),
//               SizedBox(height: 40,),
//               ElevatedButton(
//                 onPressed: isLoading ? null : () async {
//                   if (selectedSalesmanId == null || selectedCustomer == null || selectedBank == null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Please fill all fields")),
//                     );
//                     return;
//                   }
//
//                   setState(() => isLoading = true);
//
//                   try {
//                     final provider = Provider.of<RecoveryProvider>(context, listen: false);
//                     final message = await provider.addRecovery(
//                       orderId: widget.nextOrderId,
//                       salesmanId: selectedSalesmanId!,
//                       customerId: selectedCustomer!.id.toString(),
//                       bankId: selectedBank!.id.toString(),
//                       amount: amountController.text,
//                       recoveryDate: DateTime.now().toIso8601String().split("T")[0], // Today
//                       mode: "BANK",
//                     );
//
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(message ?? "Recovery added")),
//                     );
//
//                     Navigator.pop(context);
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("Error: $e")),
//                     );
//                   } finally {
//                     setState(() => isLoading = false);
//                   }
//                 },
//                 child: isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text("Create Recovery"),
//               )
//
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:demo_distribution/Provider/BankProvider/BankListProvider.dart';
import 'package:demo_distribution/compoents/AppTextfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../Provider/RecoveryProvider/RecoveryProvider.dart';
import '../../../Provider/SaleManProvider/SaleManProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/BankDropDown.dart';
import '../../../compoents/Customerdropdown.dart';
import '../../../compoents/SaleManDropdown.dart';
import '../../../model/BankModel/BankListModel.dart';
import '../../../model/CustomerModel/CustomersDefineModel.dart';

class AddRecoveryScreen extends StatefulWidget {
  final String nextOrderId;
  const AddRecoveryScreen({super.key, required this.nextOrderId});

  @override
  State<AddRecoveryScreen> createState() => _AddRecoveryScreenState();
}

class _AddRecoveryScreenState extends State<AddRecoveryScreen> {
  CustomerData? selectedCustomer;
  String? selectedSalesmanId;
  BankData? selectedBank;
  bool isLoading = false;
  final TextEditingController amountController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now(); // Set default date to today
    final provider = Provider.of<SaleManProvider>(context, listen: false);
    final bprovider = Provider.of<BankProvider>(context, listen: false);
    provider.fetchEmployees();
    bprovider.fetchBanks();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          "Add Recovery",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card with Order ID
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recovery Voucher Number",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.nextOrderId,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add_chart,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "New Entry",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Form Title
              const Text(
                "Recovery Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Fill in the information below to create a new recovery",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 24),

              // Customer Selection Card
              _buildSectionCard(
                icon: Icons.person_outline,
                title: "Customer Information",
                child: CustomerDropdown(
                  selectedCustomerId: selectedCustomer?.id,
                  onChanged: (customer) {
                    setState(() => selectedCustomer = customer);
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Salesman Selection Card
              _buildSectionCard(
                icon: Icons.business_center_outlined,
                title: "Salesman Information",
                child: SalesmanDropdown(
                  selectedId: selectedSalesmanId,
                  onChanged: (value) {
                    setState(() => selectedSalesmanId = value);
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Bank Selection Card
              _buildSectionCard(
                icon: Icons.account_balance_outlined,
                title: "Bank Information",
                child: BankDropdown(
                  selectedBank: selectedBank,
                  onChanged: (bank) {
                    setState(() {
                      selectedBank = bank;
                      print("Selected Bank: ${bank?.name}");
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Amount and Date Card
              _buildSectionCard(
                icon: Icons.payment_outlined,
                title: "Payment Details",
                child: Column(
                  children: [
                    // Amount Field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1.5,
                        ),
                      ),
                      child: AppTextField(
                        controller: amountController,
                        label: 'Amount',
                        validator: (v) => v!.isEmpty ? "Enter amount" : null,
                        keyboardType: TextInputType.number,

                      ),
                    ),

                    const SizedBox(height: 16),

                    // Date Selection
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppColors.primary,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: Color(0xFF1E293B),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Recovery Date",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      selectedDate != null
                                          ? DateFormat('dd MMMM yyyy').format(selectedDate!)
                                          : "Select Date",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: selectedDate != null
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: selectedDate != null
                                            ? const Color(0xFF1E293B)
                                            : Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Payment Mode Info (Static since it's set to BANK)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.blue.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.payment,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Payment Mode",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            "BANK TRANSFER",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Active",
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: isLoading || selectedCustomer == null ||
                      selectedSalesmanId == null || selectedBank == null
                      ? null
                      : _submitRecovery,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.zero,
                    disabledBackgroundColor: Colors.transparent,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: (isLoading || selectedCustomer == null ||
                          selectedSalesmanId == null || selectedBank == null)
                          ? LinearGradient(
                        colors: [
                          Colors.grey.shade300,
                          Colors.grey.shade400,
                        ],
                      )
                          : const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: (isLoading || selectedCustomer == null ||
                          selectedSalesmanId == null || selectedBank == null)
                          ? []
                          : [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: isLoading
                          ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Creating...",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Create Recovery",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Required Fields Note
              if (selectedCustomer == null ||
                  selectedSalesmanId == null ||
                  selectedBank == null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _getMissingFieldsMessage(),
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  String _getMissingFieldsMessage() {
    List<String> missing = [];
    if (selectedCustomer == null) missing.add("Customer");
    if (selectedSalesmanId == null) missing.add("Salesman");
    if (selectedBank == null) missing.add("Bank");

    return "Please select: ${missing.join(', ')}";
  }

  Future<void> _submitRecovery() async {
    setState(() => isLoading = true);

    try {
      final provider = Provider.of<RecoveryProvider>(context, listen: false);
      final message = await provider.addRecovery(
        orderId: widget.nextOrderId,
        salesmanId: selectedSalesmanId!,
        customerId: selectedCustomer!.id.toString(),
        bankId: selectedBank!.id.toString(),
        amount: amountController.text,
        recoveryDate: selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
            : DateTime.now().toIso8601String().split("T")[0],
        mode: "BANK",
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Text(message ?? "Recovery added successfully")),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Text("Error: $e")),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
}