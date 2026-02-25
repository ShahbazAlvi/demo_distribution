import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Provider/customer_Payment/customer_payment_provider.dart';
import '../../../compoents/AppColors.dart';
import 'AddCustomerPaymentScreen.dart';


class CustomerPaymentScreen extends StatefulWidget {
  const CustomerPaymentScreen({super.key});

  @override
  State<CustomerPaymentScreen> createState() => _CustomerPaymentScreenState();
}

class _CustomerPaymentScreenState extends State<CustomerPaymentScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<CustomerPaymentProvider>().fetchCustomerPayments());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerPaymentProvider>();

    final payments = provider.paymentModel?.data.payments ?? [];

    final filtered = payments.where((p) {
      return p.customerName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.paymentNo.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.invoiceNo.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {
          final nextNo = provider.getNextPaymentNumber();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddCustomerPaymentScreen(paymentNo: nextNo),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("New Payment"),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : filtered.isEmpty
          ? const Center(child: Text("No Payments Found"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: filtered.length,
        itemBuilder: (_, index) {
          final p = filtered[index];
          return _paymentCard(p);
        },
      ),
    );
  }

  Widget _paymentCard(payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(payment.paymentNo,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              _statusBadge(payment.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(payment.customerName,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text("Invoice: ${payment.invoiceNo}"),
              const Spacer(),
              Text("Rs ${payment.paymentAmount.toStringAsFixed(0)}",
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final isPosted = status == "POSTED";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPosted ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12),
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
}