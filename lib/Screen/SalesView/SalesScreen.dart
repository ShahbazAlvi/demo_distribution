// import 'package:distribution/Screen/SalesView/OrderTakeingscreen/OrderTakingScreen.dart';
// import 'package:distribution/Screen/SalesView/SaleInvoise/SaleInvoiseScreen.dart';
// import 'package:distribution/Screen/SalesView/SetUp/ItemsListScreen/ItemsListsScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// import '../../compoents/AppColors.dart';
// import '../CustomerScreen/CustomersDefineScreen.dart';
// import '../DashBoardScreen.dart';
// import 'AnimationCard.dart';
// import 'RecoveryScreen/Recovery.dart';
// import 'ReportsScreen/AgingScreen/AgingScreen.dart';
// import 'ReportsScreen/AmountReceivableDetails/AmountReceivableDetailsScreen.dart';
// import 'ReportsScreen/CustomerLedgerScreen/LedgerScreen.dart';
// import 'Sales/SalesScreen.dart';
// import 'SetUp/EmployeeDefine/EmployeeDefine.dart';
// import 'SetUp/SalesAreaScreen/SalesAreaScreen.dart';
// import 'SetUp/supplier/SupplierScreen.dart';
//
// class SalesScreen extends StatefulWidget {
//   const SalesScreen({super.key});
//
//   @override
//   State<SalesScreen> createState() => _SalesScreenState();
// }
//
// class _SalesScreenState extends State<SalesScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: Center(child: const Text("Sales",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 22,
//               letterSpacing: 1.2,
//             )),
//         ),
//         centerTitle: true,
//         elevation: 6,
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
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Functionalities",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: AppColors.text,
//                     borderRadius: BorderRadius.circular(20)
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Wrap(
//                       spacing: 10,
//                       runSpacing: 10,
//                       children: [
//                         GestureDetector(
//                           onTap: (){
//                             Navigator.push(context,MaterialPageRoute(builder: (context)=>OrderTakingScreen()));
//                           },
//                           child: AnimationCard(
//                             icon:Icons.add_card,
//                             title: "Order Taking ",
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: (){
//                             Navigator.push(context, MaterialPageRoute(builder: (context)=>RecoveryListScreen()));
//                           },
//                           child: AnimationCard(
//                             icon: Icons.newspaper,
//                             title: "Recovery",
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: (){
//                             Navigator.push(context,MaterialPageRoute(builder: (context)=>SaleInvoiseScreen()));
//                           },
//                           child: AnimationCard(
//                             icon: Icons.add_chart_rounded,
//                             title: "Sales Invoice ",
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: (){
//                             Navigator.push(context,MaterialPageRoute(builder: (context)=>SalessScreen()));
//                           },
//                           child: AnimationCard(
//                             icon: Icons.sim_card_alert_rounded,
//                             title: "Sales",
//                           ),
//                         ),
//                         AnimationCard(
//                           icon: Icons.wallet,
//                           title: "Cash Deposit",
//                         ),
//                         AnimationCard(
//                           icon: Icons.cloud_upload_rounded,
//                           title: "Load Return",
//                         ),
//
//
//
//
//
//                       ],
//                     ),
//                   ),
//                 ),
//               SizedBox(height: 10,),
//               Text("Reports",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     color: AppColors.text,
//                     borderRadius: BorderRadius.circular(20)
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     children: [
//                       GestureDetector(
//                         onTap: (){
//                           Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceivableScreen()));
//                         },
//                         child: AnimationCard(
//                           icon:Icons.add_card,
//                           title: "Amount Receivable",
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: (){
//                           Navigator.push(context,MaterialPageRoute(builder: (context)=>CustomerLedgerScreen()));
//                         },
//                         child: AnimationCard(
//                           icon: Icons.newspaper,
//                           title: "Customer Ledger",
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: (){
//                           Navigator.push(context,MaterialPageRoute(builder: (context)=>CreditAgingScreen()));
//                         },
//                         child: AnimationCard(
//                           icon: Icons.add_chart_rounded,
//                           title: "Credit Aging",
//                         ),
//                       ),
//
//                       AnimationCard(
//                         icon: Icons.cloud_upload_rounded,
//                         title: "Daily Sales Report",
//                       ),
//
//
//
//
//
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10,),
//               Text("Setup",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     color: AppColors.text,
//                     borderRadius: BorderRadius.circular(20)
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     children: [
//                       GestureDetector(
//                         onTap: (){
//                           Navigator.push(context,MaterialPageRoute(builder: (context)=>SalesAreaScreen()));
//                         },
//                         child: AnimationCard(
//                           icon:Icons.location_on_rounded,
//                           title: "Sales Areas ",
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: (){
//                           Navigator.push(context,MaterialPageRoute(builder: (context)=>ItemListScreen()));
//                         },
//                         child: AnimationCard(
//                           icon: Icons.newspaper,
//                           title: "List of Items",
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: (){
//                           Navigator.push(context,MaterialPageRoute(builder: (context)=>CustomersDefineScreen()));
//                         },
//                         child: AnimationCard(
//                           icon: Icons.people,
//                           title: "Define Customers ",
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: (){
//                           Navigator.push(context, MaterialPageRoute(builder: (context)=>EmployeesScreen()));
//                         },
//                         child: AnimationCard(
//                           icon: Icons.person,
//                           title: "Employee Information",
//                         ),
//                       ),
//                       AnimationCard(
//                         icon: Icons.car_crash,
//                         title: "Vehicle Information",
//                       ),
//                       GestureDetector(
//                         onTap: (){
//                           Navigator.push(context,MaterialPageRoute(builder: (context)=>SupplierListScreen()));
//                         },
//                         child: AnimationCard(
//                           icon: Icons.car_rental_sharp,
//                           title: "Supplier",
//                         ),
//                       ),
//
//
//
//
//
//
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//
//       ),
//
//     );
//   }
// }
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../compoents/AppColors.dart';
import '../CustomerScreen/CustomersDefineScreen.dart';
import 'DailysaleScreen/DailySaleScreen.dart';
import 'OrderTakeingscreen/OrderTakingScreen.dart';
import 'RecoveryScreen/Recovery.dart';
import 'ReportsScreen/AgingScreen/AgingScreen.dart';
import 'ReportsScreen/AmountReceivableDetails/AmountReceivableDetailsScreen.dart';
import 'ReportsScreen/CustomerLedgerScreen/LedgerScreen.dart';
import 'SaleInvoise/SaleInvoiseScreen.dart';
import 'Sales/SalesScreen.dart';
import 'SetUp/EmployeeDefine/EmployeeDefine.dart';
import 'SetUp/ItemsListScreen/ItemCategoriesScreen.dart';
import 'SetUp/ItemsListScreen/ItemTypeScreen.dart';
import 'SetUp/ItemsListScreen/ItemUnitScreen.dart';
import 'SetUp/ItemsListScreen/ItemsListsScreen.dart';
import 'SetUp/SalesAreaScreen/SalesAreaScreen.dart';
import 'SetUp/supplier/SupplierScreen.dart';


class SalesDashboard extends StatelessWidget {
  const SalesDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
     // backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header
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
                      "Sales Dashboard",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Manage sales, invoices, and customer data efficiently",
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
                  icon: Icons.add_card,
                  title: "Order Taking",
                  color: Colors.tealAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderTakingScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.add_chart_rounded,
                  title: "Sales Invoice",
                  color: Colors.pinkAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SaleInvoiseScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.newspaper,
                  title: "Recovery",
                  color: Colors.amberAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RecoveryListScreen()));
                  },
                ),


                // DashboardCard(
                //   icon: Icons.wallet,
                //   title: "Cash Deposit",
                //   color: Colors.greenAccent,
                //   onTap: () {},
                // ),
                // DashboardCard(
                //   icon: Icons.cloud_upload_rounded,
                //   title: "Load Return",
                //   color: Colors.orangeAccent,
                //   onTap: () {},
                // ),
              ]),

              const SizedBox(height: 30),

              // 🔸 Reports Section
              _buildSectionTitle("📊 Reports"),
              const SizedBox(height: 14),
              _buildCardGrid([
                DashboardCard(
                  icon: Icons.add_card,
                  title: "Amount Receivable",
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ReceivableScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.newspaper,
                  title: "Customer Ledger",
                  color: Colors.purpleAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerLedgerScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.add_chart_rounded,
                  title: "Credit Aging",
                  color: Colors.cyanAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CreditAgingScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.sim_card_alert_rounded,
                  title: "Daily Sales",
                  color: Colors.lightBlueAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DailySaleReportScreen()));
                  },
                ),
                // DashboardCard(
                //   icon: Icons.cloud_upload_rounded,
                //   title: "Daily Sales Report",
                //   color: Colors.indigoAccent,
                //   onTap: () {},
                // ),
              ]),

              const SizedBox(height: 30),

              // 🔸 Setup Section
              _buildSectionTitle("🧩 Setup"),
              const SizedBox(height: 14),
              _buildCardGrid([
                // DashboardCard(
                //   icon: Icons.location_on_rounded,
                //   title: "Sales Areas",
                //   color: Colors.limeAccent,
                //   onTap: () {
                //     Navigator.push(context, MaterialPageRoute(builder: (_) => const SalesAreaScreen()));
                //   },
                // ),
                // DashboardCard(
                //   icon: Icons.category,
                //   title: "Category Item",
                //   color: Colors.orangeAccent,
                //   onTap: () {
                //     Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesScreen()));
                //   },
                // ),

                // DashboardCard(
                //   icon: Icons.layers,
                //   title: "Items Type ",
                //   color: Colors.blueAccent,
                //   onTap: () {
                //     Navigator.push(context, MaterialPageRoute(builder: (_) => const ItemTypeScreen()));
                //   },
                // ),
                // DashboardCard(
                //   icon: Icons.straighten,
                //   title: "Item Unit ",
                //   color: Colors.tealAccent  ,
                //   onTap: () {
                //     Navigator.push(context, MaterialPageRoute(builder: (_) => const ItemUnitScreen()));
                //   },
                // ),
                DashboardCard(
                  icon: Icons.inventory_2,
                  title: "List of Items",
                  color: Colors.lightBlueAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ItemListScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.people,
                  title: "Define Customers",
                  color: Colors.pinkAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomersDefineScreen()));
                  },
                ),
                DashboardCard(
                  icon: Icons.person,
                  title: "Employee Information",
                  color: Colors.orangeAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeesScreen()));
                  },
                ),
                // DashboardCard(
                //   icon: Icons.local_shipping,
                //   title: "Vehicle Information",
                //   color: Colors.blueAccent,
                //   onTap: () {},
                // ),
                DashboardCard(
                  icon: Icons.store_rounded,
                  title: "Supplier",
                  color: Colors.tealAccent,
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

// 🔹 Reusable Glass Card Component
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            //  color: Colors.white.withOpacity(0.4),
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
  }
}
