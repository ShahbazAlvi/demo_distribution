import 'package:flutter/material.dart';

import '../../compoents/AppColors.dart';
import '../SalesView/AnimationCard.dart';
import '../SalesView/SetUp/supplier/SupplierScreen.dart';
import 'DateWisePurchaseScreen/DateWisePurchaseScreen.dart';
import 'GRNScreen/GRN_Screen.dart';
import 'ItemWisePurchase/ItemWisePurchaseScreen.dart';
import 'ItemWisePurchaseScreen/ItemWisePurchaseScreen.dart';
import 'PayableAmountScreen/PayableAmountScreen.dart';
import 'Payment_Supplier_Screen/PaymentSupplierScreen.dart';
import 'PurchaseOrder/PurchaseOrder.dart';
import 'StockPositionScreen/StockPositionScreen.dart';
import 'SupplierLedgerScreen/SupplierLedgerScreen.dart';
import 'SupplierWisePurchaseScreen/SupplierWisePurchaseScreen.dart';

import 'dart:ui';
import 'package:flutter/material.dart';

class PurchaseDashboard extends StatelessWidget {
  const PurchaseDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFFF6F7FB),
      backgroundColor: Color(0xFFEEEEEE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header with gradient and title
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Purchase Dashboard",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Manage purchases, ledgers, and suppliers in one place",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 🔸 Functionalities Section
              _buildSectionTitle("⚙️ Functionalities"),
              const SizedBox(height: 14),
              _buildCardGrid([
                DashboardCard(
                  icon: Icons.receipt_long_rounded,
                  title: "GRN",
                  color: Colors.tealAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>GRNScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.receipt_long_rounded,
                  title: "Purchase Order",
                  color: Colors.tealAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PurchaseOrderScreen()));
                  },
                ),
                // DashboardCard(
                //   icon: Icons.attach_money_rounded,
                //   title: "Payment to Supplier",
                //   color: Colors.amberAccent,
                //   onTap: () {
                //     Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentToSupplierScreen()));
                //   },
                // ),
              ]),


              const SizedBox(height: 30),

              // 🔸 Reports Section
              _buildSectionTitle("📊 Reports"),
              const SizedBox(height: 14),
              _buildCardGrid([
                DashboardCard(
                  icon: Icons.account_balance_wallet_rounded,
                  title: "Amount Payable",
                  color: Colors.pinkAccent,
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>PayableAmountScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.date_range_rounded,
                  title: "DateWise Purchase",
                  color: Colors.lightBlueAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DatewisePurchaseScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.shopping_bag_rounded,
                  title: "ItemsWise Purchase",
                  color: Colors.orangeAccent,
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>ItemWisePurchaseScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.people_alt_rounded,
                  title: "Supplier Ledger",
                  color: Colors.greenAccent,
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>SupplierLedgerScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.person_pin_rounded,
                  title: "SupplierWise Purchase",
                  color: Colors.cyanAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SupplierwisePurchaseScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.equalizer_rounded,
                  title: "Stock Position",
                  color: Colors.purpleAccent,
                  onTap: () {
                   // Navigator.push(context,MaterialPageRoute(builder: (context)=>StockPositionScreen()));
                  },
                ),
              ]),

              const SizedBox(height: 30),

              // 🔸 Setup Section
              _buildSectionTitle("🧩 Setup"),  
              const SizedBox(height: 14),
              _buildCardGrid([
                DashboardCard(
                  icon: Icons.local_shipping_rounded,
                  title: "Supplier",
                  color: Color(0xFF00C9A7),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SupplierListScreen()));
                  },
                ),
              ]),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333333),
      ),
    );
  }

  Widget _buildCardGrid(List<DashboardCard> cards) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: cards,
        );
      },
    );
  }
}

// 🔹 Individual Glass Card Component
class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 200),
        tween: Tween(begin: 1.0, end: 1.0),
        builder: (context, scale, _) {
          return AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 150),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                   // color: Colors.white.withOpacity(0.4),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(25),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: color.withOpacity(0.4),
                    //     blurRadius: 12,
                    //     spreadRadius: 2,
                    //     offset: const Offset(0, 3),
                    //   ),
                    // ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 40, color: color),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}