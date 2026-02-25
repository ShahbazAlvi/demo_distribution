import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/BankProvider/BankListProvider.dart';
import '../../../Provider/customer_Payment/customer_payment_provider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/BankDropDown.dart';
import '../../../compoents/Customerdropdown.dart';
import '../../../model/BankModel/BankListModel.dart';
import '../../../model/CustomerModel/CustomersDefineModel.dart';
import '../../../model/customer_payment_model/InvoicePaymentModel.dart';

class AddCustomerPaymentScreen extends StatefulWidget {
  final String paymentNo;
  const AddCustomerPaymentScreen({super.key, required this.paymentNo});

  @override
  State<AddCustomerPaymentScreen> createState() => _AddCustomerPaymentScreenState();
}

class _AddCustomerPaymentScreenState extends State<AddCustomerPaymentScreen> {
  final TextEditingController _searchController = TextEditingController();
  BankData? selectedBank;
  String paymentMode = "CASH";
  String searchQuery = '';
  CustomerData? selectedCustomer;
  String selectedStatus = "DRAFT";
  CustomerInvoice? selectedInvoice;

  final TextEditingController invoiceAmountController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();

  final List<String> orderStatusList = [
    "DRAFT",
    "APPROVED",
    "CLOSED",
    "CANCELLED",
  ];
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<BankProvider>().fetchBanks();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSectionTitle('Customer Information'),
            const SizedBox(height: 12),
            _buildCustomerField(),
            const SizedBox(height: 24),

            // Order Status Section
            _buildSectionTitle('Order Status'),
            const SizedBox(height: 12),
            _buildStatusField(),
            const SizedBox(height: 24),
            _buildSectionTitle('Invoice'),
            const SizedBox(height: 24),
            _buildSectionTitle('Payment Mode'),
            const SizedBox(height: 12),
            _buildPaymentModeField(),

            if (paymentMode == "BANK") ...[
              const SizedBox(height: 16),
              _buildSectionTitle('Select Bank'),
              const SizedBox(height: 12),
              _buildBankField(),
            ],
            const SizedBox(height: 12),
            _buildInvoiceField(),

            const SizedBox(height: 16),
            _buildInvoiceAmountField(),

            const SizedBox(height: 16),
            _buildPaymentField(),

            const SizedBox(height: 16),
            _buildBalanceField(),
            const SizedBox(height: 30),
            _buildSubmitButton(),
            const SizedBox(height: 40),

          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.secondary, AppColors.primary],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      title: const Text("Customer Payments",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: const InputDecoration(
                hintText: "Search payments...",
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
  // customer field dropdown
  Widget _buildCustomerField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomerDropdown(
        selectedCustomerId: selectedCustomer?.id,
        onChanged: (customer) {
          setState(() {
            selectedCustomer = customer;
            selectedInvoice = null;
            invoiceAmountController.clear();
            paymentController.clear();
            balanceController.clear();
          });

          context.read<CustomerPaymentProvider>()
              .fetchCustomerInvoices(customer!.id);
        },
      ),
    );
  }
  Widget _buildStatusField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStatus,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.primary,
          ),
          items: orderStatusList.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getStatusColor(status),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => selectedStatus = value!);
          },
        ),
      ),
    );
  }
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  Color _getStatusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return Colors.green;
      case 'CLOSED':
        return Colors.blue;
      case 'CANCELLED':
        return Colors.red;
      case 'DRAFT':
      default:
        return Colors.orange;
    }
  }
  Widget _buildInvoiceField() {
    final provider = context.watch<CustomerPaymentProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      //decoration: _boxDecoration(),
      child: provider.invoiceLoading
          ? const Padding(
        padding: EdgeInsets.all(12),
        child: CircularProgressIndicator(),
      )
          : DropdownButtonHideUnderline(
        child: DropdownButton<CustomerInvoice>(
          hint: const Text("Select Invoice"),
          value: selectedInvoice,
          isExpanded: true,
          items: provider.customerInvoices.map((inv) {
            return DropdownMenuItem(
              value: inv,
              child: Row(
                children: [
                  Expanded(child: Text(inv.invNo)),
                  Text("Rs ${inv.netTotal.toStringAsFixed(0)}"),
                ],
              ),
            );
          }).toList(),
          onChanged: (invoice) {
            setState(() {
              selectedInvoice = invoice;
              invoiceAmountController.text =
                  invoice!.netTotal.toStringAsFixed(0);

              paymentController.text = "0";
              balanceController.text =
                  invoice.netTotal.toStringAsFixed(0);
            });
          },
        ),
      ),
    );
  }
  void _calculateBalance() {
    final invoiceAmount =
        double.tryParse(invoiceAmountController.text) ?? 0;

    final payment =
        double.tryParse(paymentController.text) ?? 0;

    final balance = invoiceAmount - payment;

    balanceController.text = balance.toStringAsFixed(0);
  }
  Widget _buildPaymentField() {
    return TextField(
      controller: paymentController,
      keyboardType: TextInputType.number,
      onChanged: (_) => _calculateBalance(),
      decoration: const InputDecoration(
        labelText: "Payment Amount",
        border: OutlineInputBorder(),
      ),
    );
  }
  Widget _buildInvoiceAmountField() {
    return TextField(
      controller: invoiceAmountController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Invoice Amount",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildBalanceField() {
    return TextField(
      controller: balanceController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Balance",
        border: OutlineInputBorder(),
      ),
    );
  }
  Widget _buildPaymentModeField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 6,
          )
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: paymentMode,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: "CASH", child: Text("Cash")),
            DropdownMenuItem(value: "BANK", child: Text("Bank")),
          ],
          onChanged: (value) {
            setState(() {
              paymentMode = value!;
              selectedBank = null; // reset
            });
          },
        ),
      ),
    );
  }
  Widget _buildBankField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 6,
          )
        ],
      ),
      child: BankDropdown(
        selectedBank: selectedBank,
        onChanged: (bank) {
          setState(() => selectedBank = bank);
        },
      ),
    );
  }
  Widget _buildSubmitButton() {
    final provider = context.watch<CustomerPaymentProvider>();

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: provider.isLoading ? null : _submitPayment,
        child: provider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          "Save Payment",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  Future<void> _submitPayment() async {
    if (selectedCustomer == null) {
      _showMsg("Please select customer");
      return;
    }

    if (selectedInvoice == null) {
      _showMsg("Please select invoice");
      return;
    }

    if (paymentMode == "BANK" && selectedBank == null) {
      _showMsg("Please select bank");
      return;
    }

    final paymentAmount =
        double.tryParse(paymentController.text.trim()) ?? 0;

    if (paymentAmount <= 0) {
      _showMsg("Enter valid payment amount");
      return;
    }

    final provider = context.read<CustomerPaymentProvider>();

    final success = await provider.submitCustomerPayment(
      paymentNo: widget.paymentNo,
      paymentDate: DateTime.now().toString().split(" ").first,
      customerId: selectedCustomer!.id,
      invoice: selectedInvoice!,
      paymentAmount: paymentAmount,
      status: selectedStatus,
      paymentMode: paymentMode,
      bankId: selectedBank?.id,
    );

    if (!mounted) return;

    if (success) {
      _showMsg("Payment saved successfully ✅");
      Navigator.pop(context, true);
    } else {
      _showMsg(provider.error.isEmpty
          ? "Payment failed ❌"
          : provider.error);
    }
  }
  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
