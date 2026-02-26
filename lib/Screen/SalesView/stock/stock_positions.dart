// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Provider/stock_provider/stock_position_provider.dart';
//
//
//
//
// class StockPositionScreen extends StatefulWidget {
//   const StockPositionScreen({super.key});
//
//   @override
//   State<StockPositionScreen> createState() => _StockPositionScreenState();
// }
//
// class _StockPositionScreenState extends State<StockPositionScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() =>
//         Provider.of<StockPositionProvider>(context, listen: false)
//             .fetchStockPosition());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Stock Position"),
//         centerTitle: true,
//       ),
//       body: Consumer<StockPositionProvider>(
//         builder: (context, provider, child) {
//           if (provider.loading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (provider.stockList.isEmpty) {
//             return Center(child: Text(provider.message));
//           }
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: provider.stockList.length,
//             itemBuilder: (context, index) {
//               final item = provider.stockList[index];
//               final itemStock = item.inQty - item.outQty;
//               final isNegative = item.balanceQty < 0;
//
//               //final isNegative = itemStock < 0;
//
//               return Card(
//                 margin: const EdgeInsets.only(bottom: 12),
//                 elevation: 3,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         item.itemName,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//
//                       const SizedBox(height: 6),
//
//                       Text("SKU: ${item.sku}"),
//                       Text("Category: ${item.category}"),
//
//
//                       const Divider(),
//
//
//
//                     Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                 Text(
//                   "Stock item : $itemStock",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: isNegative ? Colors.red : Colors.green,
//                   ),
//                 ),
//                 ],
//               ),
//
//                       const SizedBox(height: 6),
//
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Balance: ${item.balanceQty}",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: isNegative ? Colors.red : Colors.green,
//                             ),
//                           ),
//                           Text("Rate: ${item.avgRate}"),
//                           Text("Value: ${item.stockValue}"),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// extension on StockPositionProvider {
//   bool get loading => true;
//
//   get stockList => null;
//
//   String get message => '';
// }
import 'package:demo_distribution/compoents/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Add this to pubspec.yaml

import '../../../Provider/stock_provider/stock_position_provider.dart';

class StockPositionScreen extends StatefulWidget {
  const StockPositionScreen({super.key});

  @override
  State<StockPositionScreen> createState() => _StockPositionScreenState();
}

class _StockPositionScreenState extends State<StockPositionScreen>
    with SingleTickerProviderStateMixin {

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    Future.microtask(() =>
        Provider.of<StockPositionProvider>(context, listen: false)
            .fetchStockPosition());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: Consumer<StockPositionProvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return _buildShimmerLoading();
          }

          if (provider.stockList.isEmpty) {
            return _buildEmptyState(provider.message);
          }

          // Filter items based on search query
          final filteredList = provider.stockList.where((item) {
            final query = searchQuery.toLowerCase();
            return item.itemName.toLowerCase().contains(query) ||
                item.sku.toLowerCase().contains(query) ||
                item.category.toLowerCase().contains(query);
          }).toList();

          if (filteredList.isEmpty) {
            return _buildNoSearchResults();
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildStatsCard(provider),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final itemStock = item.inQty - item.outQty;
                      final isNegative = item.balanceQty < 0;

                      // Convert itemStock to double if needed, but pass as num to handle both
                      return _buildStockCard(item, itemStock, isNegative);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Modern App Bar with Search
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondary],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
      ),
      title: const Text(
        "Stock Position",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.pop(context),
        color: Colors.white,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () {
            context.read<StockPositionProvider>().fetchStockPosition();
          },
          color: Colors.white,
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search by item name, SKU, or category...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded, color: Colors.blue.shade700),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Stats Card showing summary
  Widget _buildStatsCard(StockPositionProvider provider) {
    final totalItems = provider.stockList.length;
    final lowStockItems = provider.stockList.where((item) => item.balanceQty < 10).length;
    final negativeStockItems = provider.stockList.where((item) => item.balanceQty < 0).length;
    final totalValue = provider.stockList.fold<double>(0, (sum, item) => sum + item.stockValue);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.inventory_2_rounded,
                label: "Total Items",
                value: "$totalItems",
                color: Colors.blue,
              ),
              _buildStatItem(
                icon: Icons.warning_amber_rounded,
                label: "Low Stock",
                value: "$lowStockItems",
                color: Colors.orange,
              ),
              // _buildStatItem(
              //   icon: Icons.error_rounded,
              //   label: "Negative",
              //   value: "$negativeStockItems",
              //   color: Colors.red,
              // ),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.money, color: Colors.green.shade700, size: 24),
              const SizedBox(width: 8),
              Text(
                "Total Stock Value: Rs ${totalValue.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // Modern Stock Card - Fixed to handle both int and double
  Widget _buildStockCard(item, num itemStock, bool isNegative) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Optional: Navigate to stock details
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with item name and status indicator
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isNegative
                              ? [Colors.red.shade100, Colors.red.shade50]
                              : [Colors.blue.shade100, Colors.blue.shade50],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        isNegative ? Icons.warning_rounded : Icons.inventory_rounded,
                        color: isNegative ? Colors.red : Colors.blue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.itemName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "SKU: ${item.sku}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item.category,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.purple.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Stock Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isNegative
                            ? Colors.red.withOpacity(0.1)
                            : item.balanceQty < 10
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isNegative
                              ? Colors.red.withOpacity(0.3)
                              : item.balanceQty < 10
                              ? Colors.orange.withOpacity(0.3)
                              : Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        isNegative
                            ? "Negative"
                            : item.balanceQty < 10
                            ? "Low Stock"
                            : "In Stock",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isNegative
                              ? Colors.red
                              : item.balanceQty < 10
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Progress indicator for stock level
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _calculateStockPercentage(item.balanceQty.toDouble(), 100),
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isNegative
                          ? Colors.red
                          : item.balanceQty < 50
                          ? Colors.orange
                          : Colors.green,
                    ),
                    minHeight: 6,
                  ),
                ),

                const SizedBox(height: 16),

                // Stock Metrics Grid
                Row(
                  children: [

                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricCard(
                        icon: Icons.inventory_rounded,
                        label: "Stock",
                        value: itemStock.toStringAsFixed(0),
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricCard(
                        icon: Icons.inbox_rounded,
                        label: "Rate",
                        value: item.avgRate.toStringAsFixed(2),
                        color: Colors.green,
                      ),
                    ),
                    // const SizedBox(width: 8),
                    // Expanded(
                    //   child: _buildMetricCard(
                    //     icon: Icons.outbox_rounded,
                    //     label: "total amount",
                    //     value:  item.stockValue.toStringAsFixed(0),
                    //     color: Colors.orange,
                    //   ),
                    // ),
                  ],
                ),

                const SizedBox(height: 12),

                // Balance and Value Row

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateStockPercentage(double current, double max) {
    if (current <= 0) return 0.0;
    if (current >= max) return 1.0;
    return current / max;
  }

  // Shimmer Loading Effect
  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message.isEmpty ? "No Stock Items Found" : message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          // const SizedBox(height: 24),
          // ElevatedButton.icon(
          //   onPressed: () {
          //     context.read<StockPositionProvider>().fetchStockPosition();
          //   },
          //   icon: const Icon(Icons.refresh_rounded),
          //   label: const Text("Refresh"),
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.blue,
          //     foregroundColor: Colors.white,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //   ),
          // ),
        ],
      ),
    );
  }

  // No Search Results Widget
  Widget _buildNoSearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "No items match your search",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try searching with different keywords",
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

extension on StockPositionProvider {
  bool get loading => true;
  get stockList => null;
  String get message => '';
}