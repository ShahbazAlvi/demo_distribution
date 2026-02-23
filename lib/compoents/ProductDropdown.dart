//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
//
// import '../../model/ProductModel/itemsdetailsModel.dart';
// import '../Provider/ProductProvider/ItemListsProvider.dart';
//
//
// class ItemDetailsDropdown extends StatefulWidget {
//   final Function(ItemDetails) onItemSelected;
//
//   const ItemDetailsDropdown({super.key, required this.onItemSelected});
//
//   @override
//   State<ItemDetailsDropdown> createState() => _ItemDetailsDropdownState();
// }
//
// class _ItemDetailsDropdownState extends State<ItemDetailsDropdown> {
//   ItemDetails? selectedItem;
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() =>
//         Provider.of<ItemDetailsProvider>(context, listen: false).fetchItems());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<ItemDetailsProvider>(context);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Select Product",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 6),
//
//         provider.isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : DropdownButtonFormField<ItemDetails>(
//           value: selectedItem,
//           isExpanded: true,
//           hint: const Text("Choose Product"),
//           items: provider.items.map((item) {
//             return DropdownMenuItem<ItemDetails>(
//               value: item,
//               child: Row(
//                 children: [
//                   // ✅ Product Image
//
//                   const SizedBox(width: 10),
//
//                   Expanded(
//                     child: Text(
//                       "${item.name} (${item.unitId})",  // ✅ Safe
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//
//                 ],
//               ),
//             );
//           }).toList(),
//           onChanged: (value) {
//             setState(() {
//               selectedItem = value;
//             });
//             if (value != null) widget.onItemSelected(value);
//           },
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.grey.shade100,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../model/ProductModel/itemsdetailsModel.dart';
import '../Provider/ProductProvider/ItemListsProvider.dart';

class ItemDetailsDropdown extends StatefulWidget {
  final Function(ItemDetails) onItemSelected;
  final ItemDetails? initialSelectedItem;
  final String label;
  final bool showDetails;
  final bool isRequired;
  final String? hintText;

  const ItemDetailsDropdown({
    super.key,
    required this.onItemSelected,
    this.initialSelectedItem,
    this.label = "Select Product",
    this.showDetails = false,
    this.isRequired = false,
    this.hintText = "Choose Product",
  });

  @override
  State<ItemDetailsDropdown> createState() => _ItemDetailsDropdownState();
}

class _ItemDetailsDropdownState extends State<ItemDetailsDropdown> {
  ItemDetails? selectedItem;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialSelectedItem;
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  void _initializeData() {
    Future.microtask(() {
      final provider = Provider.of<ItemDetailsProvider>(context, listen: false);
      provider.fetchItems();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<ItemDetailsProvider>(context, listen: false);
      if (provider.hasMore && !provider.isLoading) {
        provider.fetchMoreItems();
      }
    }
  }

  @override
  void didUpdateWidget(ItemDetailsDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedItem != oldWidget.initialSelectedItem) {
      setState(() {
        selectedItem = widget.initialSelectedItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ItemDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label.isNotEmpty) ...[
              Row(
                children: [
                  Text(
                    widget.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  if (widget.isRequired) ...[
                    const SizedBox(width: 4),
                    Text(
                      '*',
                      style: TextStyle(color: Colors.red[700], fontSize: 16),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
            ],

            if (provider.isLoading && provider.items.isEmpty)
              _buildShimmerDropdown()
            else if (provider.errorMessage != null && provider.errorMessage!.isNotEmpty)
              _buildErrorWidget(provider.errorMessage!, provider)
            else if (provider.items.isEmpty)
                _buildEmptyWidget()
              else
                _buildDropdown(theme, provider),

            if (provider.isLoading && provider.items.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),

            if (widget.showDetails && selectedItem != null) ...[
              const SizedBox(height: 16),
              _buildItemDetailsCard(selectedItem!, theme),
            ],
          ],
        );
      },
    );
  }

  Widget _buildShimmerDropdown() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error, ItemDetailsProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              color: Colors.red[700],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Failed to load products',
                  style: TextStyle(
                    color: Colors.red[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  error,
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              provider.fetchItems(refresh: true);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red[700],
              backgroundColor: Colors.red[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: Colors.grey[600],
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No products found',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add a product to get started',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(ThemeData theme, ItemDetailsProvider provider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<ItemDetails>(
          value: selectedItem,
          isExpanded: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          hint: Text(
            widget.hintText!,
            style: TextStyle(color: Colors.grey[600]),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[700]),
          items: provider.items.map((item) {
            return DropdownMenuItem<ItemDetails>(
              value: item,
              child: Row(
                children: [
                  // Product Icon/Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Unit: ${item.unitId}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (item.salePrice != null)
                              Text(
                                '₹${item.salePrice!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedItem = value;
            });
            if (value != null) widget.onItemSelected(value);
          },
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 4,
        ),
      ),
    );
  }

  Widget _buildItemDetailsCard(ItemDetails item, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primaryColor.withOpacity(0.05),
            theme.primaryColor.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.primaryColor.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.inventory,
                    color: theme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Item Code: ${item.id ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[300], height: 1),
            const SizedBox(height: 16),

            // Item Details Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _buildDetailChip(
                  Icons.category,
                  'Category',
                  item.name ?? 'N/A',
                  theme,
                ),
                _buildDetailChip(
                  Icons.inventory,
                  'Unit',
                  item.unitId.toString(),
                  theme,
                ),
                _buildDetailChip(
                  Icons.sell,
                  'Sale Price',
                  '₹${item.salePrice?.toStringAsFixed(2) ?? '0.00'}',
                  theme,
                ),
                _buildDetailChip(
                  Icons.shopping_cart,
                  'Purchase Price',
                  '₹${item.purchasePrice?.toStringAsFixed(2) ?? '0.00'}',
                  theme,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Additional Info
            if (item.minLevelQty != null) ...[
              const SizedBox(height: 8),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.minLevelQty.toString()!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label, String value, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: theme.primaryColor),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}