import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/Purchase_Provider/Payment_TO_Supplier_Provider/PaymentSupplierProvider.dart';
import '../../../compoents/AppColors.dart';


class PaymentToSupplierScreen extends StatefulWidget {
  const PaymentToSupplierScreen({super.key});

  @override
  State<PaymentToSupplierScreen> createState() => _PaymentToSupplierScreenState();
}

class _PaymentToSupplierScreenState extends State<PaymentToSupplierScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PaymentToSupplierProvider>(context, listen: false).loadPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Payment To Supplier",
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
      body: Consumer<PaymentToSupplierProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: provider.paymentList.length,
            itemBuilder: (context, index) {
              final data = provider.paymentList[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text("Receipt: ${data.receiptId}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date: ${data.date}"),
                      Text("Supplier: ${data.supplier.supplierName}"),
                      Text("Amount Received: ${data.amountReceived}"),
                      Text("New Balance: ${data.newBalance}"),
                      Text("Remarks: ${data.remarks}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✅ Update button
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showUpdateBottomSheet(context, data),
                      ),

                      // ✅ Delete button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          provider.deletePayment(data.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// ✅ Update Bottom Sheet
  void _showUpdateBottomSheet(context, payment) {
    final provider = Provider.of<PaymentToSupplierProvider>(context, listen: false);

    TextEditingController amountCtrl =
    TextEditingController(text: payment.amountReceived.toString());
    TextEditingController remarksCtrl = TextEditingController(text: payment.remarks);
    TextEditingController supplierCtrl =
    TextEditingController(text: payment.supplier.supplierName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Update Payment",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              TextField(
                controller: supplierCtrl,
                decoration: const InputDecoration(labelText: "Supplier Name"),
              ),

              TextField(
                controller: amountCtrl,
                decoration: const InputDecoration(labelText: "Amount Received"),
                keyboardType: TextInputType.number,
              ),

              TextField(
                controller: remarksCtrl,
                decoration: const InputDecoration(labelText: "Remarks"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  provider.updatePayment(
                    id: payment.id,
                    supplierId: payment.supplier.id,
                    amountReceived: num.parse(amountCtrl.text),
                    remarks: remarksCtrl.text,
                  );

                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ],
          ),
        );
      },
    );
  }
}
