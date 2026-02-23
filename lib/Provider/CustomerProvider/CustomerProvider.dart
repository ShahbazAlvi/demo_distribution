import 'dart:convert';

import 'package:demo_distribution/model/CustomerModel/CustomerModel.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/CustomerModel/CustomersDefineModel.dart';
import '../DashBoardProvider.dart';

 class CustomerProvider with ChangeNotifier{

   List<CustomerModel> _customer = [];
   List<CustomerData> _customers = [];
   bool _isLoading = false;
   String? _error;
   int _currentPage = 1;
   int? _totalPages;
   int? _totalCount;
   bool _hasMore = true;

   // Getters
   List<CustomerModel> get customer => _customer;
   List<CustomerData> get customers => _customers;
   bool get isLoading => _isLoading;
   String? get error => _error;
   bool get hasMore => _hasMore;
   int? get totalCount => _totalCount;

   // Controllers
   final TextEditingController AreaNameController = TextEditingController();
   final TextEditingController CustomerNameController = TextEditingController();
   final TextEditingController ContactNumberController = TextEditingController();
   final TextEditingController AddressController = TextEditingController();
   final TextEditingController OpeningBalanceController = TextEditingController();
   final TextEditingController CreditDaysLimitController = TextEditingController();
   final TextEditingController CreditCashLimitController = TextEditingController();
   final TextEditingController dateController = TextEditingController();
   final TextEditingController EmailController = TextEditingController();
   final TextEditingController SubAreaController = TextEditingController();

   Future<void> fetchCustomers({bool refresh = false}) async {
     if (refresh) {
       _currentPage = 1;
       _customers.clear();
       _hasMore = true;
     }

     if (!_hasMore || _isLoading) return;

     _isLoading = true;
     _error = null;
     notifyListeners();

     try {
       final url = Uri.parse("${ApiEndpoints.baseUrl}/customers?page=$_currentPage");

       final prefs = await SharedPreferences.getInstance();
       final token = prefs.getString('token');

       if (token == null) {
         _error = "Authentication token not found";
         _isLoading = false;
         notifyListeners();
         return;
       }

       final response = await http.get(
         url,
         headers: {
           "Content-Type": "application/json",
           "Authorization": "Bearer $token",
         },
       );

       if (response.statusCode == 200) {
         final Map<String, dynamic> jsonData = jsonDecode(response.body);
         print("CUSTOMERS API Page $_currentPage => ${jsonData["data"]?["data"]?.length} customers");

         if (jsonData["success"] == true) {
           final List list = jsonData["data"]["data"] ?? [];
           final newCustomers = list.map((e) => CustomerData.fromJson(e)).toList();

           _customers.addAll(newCustomers);

           // Handle pagination info
           if (jsonData["data"]["total"] != null) {
             _totalCount = jsonData["data"]["total"];
             _currentPage = jsonData["data"]["current_page"] ?? _currentPage;
             _totalPages = jsonData["data"]["last_page"];
             _hasMore = _currentPage < (_totalPages ?? 1);
           }

           _currentPage++;
         } else {
           _error = jsonData["message"] ?? "Failed to load customers";
         }
       } else {
         _error = "Error ${response.statusCode}: Failed to load customers";
       }
     } catch (e) {
       _error = "Connection error: $e";
     }

     _isLoading = false;
     notifyListeners();
   }

   Future<void> fetchMoreCustomers() async {
     if (_hasMore && !_isLoading) {
       await fetchCustomers();
     }
   }

   Future<void> refreshCustomers() async {
     await fetchCustomers(refresh: true);
   }

   Future<CustomerData?> getCustomerById(int id) async {
     try {
       if (_customers.isNotEmpty) {
         return _customers.firstWhere((c) => c.id == id);
       }

       await fetchCustomers();
       return _customers.firstWhere((c) => c.id == id);
     } catch (e) {
       return null;
     }
   }

   void clearSearch() {
     _customers.clear();
     _currentPage = 1;
     _hasMore = true;
     fetchCustomers();
   }

   @override
   void dispose() {
     AreaNameController.dispose();
     CustomerNameController.dispose();
     ContactNumberController.dispose();
     AddressController.dispose();
     OpeningBalanceController.dispose();
     CreditDaysLimitController.dispose();
     CreditCashLimitController.dispose();
     dateController.dispose();
     EmailController.dispose();
     SubAreaController.dispose();
     super.dispose();
   }
//   List<CustomerModel>_customer=[];
//
//   List<CustomerData> _customers = [];
//
//
//   bool _isLoading=false;
//   String? _error;
//
//   // gets
// List<CustomerModel> get customer=>_customer;
//   List<CustomerData> get customers => _customers;
// bool get isLoading=>_isLoading;
//   String? get error => _error;
//
//
//
//   final TextEditingController AreaNameController=TextEditingController();
//   final TextEditingController CustomerNameController=TextEditingController();
//   final TextEditingController ContactNumberController=TextEditingController();
//   final TextEditingController AddressController=TextEditingController();
//   final TextEditingController OpeningBalanceController=TextEditingController();
//   final TextEditingController CreditDaysLimitController=TextEditingController();
//   final TextEditingController CreditCashLimitController=TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController EmailController=TextEditingController();
//   final TextEditingController SubAreaController=TextEditingController();
//
//
//
//
//
//
//
//   Future<void> fetchCustomers() async {
//     _isLoading = true;
//     _error = '';
//     notifyListeners();
//
//     try {
//       final url = Uri.parse("${ApiEndpoints.baseUrl}/customers");
//
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');
//
//       final response = await http.get(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       final Map<String, dynamic> jsonData = jsonDecode(response.body);
//       print("CUSTOMERS API => $jsonData");
//
//       if (response.statusCode == 200 && jsonData["success"] == true) {
//         final List list = jsonData["data"]["data"] ?? [];
//
//         _customers = list.map((e) => CustomerData.fromJson(e)).toList();
//       } else {
//         _error = jsonData["message"] ?? "Failed to load customers";
//       }
//     } catch (e) {
//       _error = "Error: $e";
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
//
//
//
//   // get token sharePerference
//   Future<String?> getToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("auth_token");
//     print("TOKEN => $token");
//
//   }



  // Customers add
  Future<bool> addCustomer({
    required BuildContext context,
    required String paymentType,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _error = "Token not found!";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final url = Uri.parse("${ApiEndpoints.baseUrl}/customers");

    final body = {
      "name": CustomerNameController.text.trim(),
      "phone": ContactNumberController.text.trim(),
      "email": EmailController.text.trim(), // add EmailController to form
      "address": AddressController.text.trim(),
      "paymentTerms": paymentType == "credit" ? "Credit" : "Cash",
      "aging_days": int.tryParse(CreditDaysLimitController.text) ?? 0,
      "credit_limit": int.tryParse(CreditCashLimitController.text) ?? 0,
      "opening_balance": int.tryParse(OpeningBalanceController.text) ?? 0,
      "is_active": 1,
      "sales_area_id": int.tryParse(AreaNameController.text) ?? 0,
      "sales_sub_area_id": int.tryParse(SubAreaController.text) ?? 0, // add SubAreaController to form
    };

    print("SEND BODY => $body"); // Debug

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      print("API RESPONSE => ${response.body}"); // Debug

      if (response.statusCode == 201 || response.statusCode == 200) {
        clearForm();
        fetchCustomers();

        final dashboardProvider =
        Provider.of<DashBoardProvider>(context, listen: false);
        await dashboardProvider.fetchDashboardData();

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = "Failed: ${response.body}";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearForm() {
    AreaNameController.clear();
    CustomerNameController.clear();
    ContactNumberController.clear();
    AddressController.clear();
    OpeningBalanceController.clear();
    CreditDaysLimitController.clear();
    CreditCashLimitController.clear();
    dateController.clear();

    notifyListeners();
  }



  Future<bool> DeleteCustomer(String idCustomer, DashBoardProvider dashProvider) async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final url = Uri.parse("${ApiEndpoints.baseUrl}/customers/$idCustomer");
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Customer deleted successfully");

        // Re-fetch customers
        await fetchCustomers();

        // ⭐ Refresh dashboard immediately
        await dashProvider.fetchDashboardData();
  
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = "Failed to delete: ${response.statusCode} - ${response.body}";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = "Error deleting: $e";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }



  Future<bool> updateCustomer({
    required String id,
    required String salesmanId,
    required String paymentType,
    required String openingBalanceDate,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final url = Uri.parse("${ApiEndpoints.baseUrl}/customers/$id");

      final body = {
        "salesArea": AreaNameController.text,
        "customerName": CustomerNameController.text,
        "address": AddressController.text,
        "creditLimit": CreditCashLimitController.text,
        "creditTime": CreditDaysLimitController.text,
        "openingBalanceDate": openingBalanceDate,
        "paymentTerms": paymentType,
        "phoneNumber": ContactNumberController.text,
        "salesBalance": OpeningBalanceController.text,
        "salesman": salesmanId,
      };

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        fetchCustomers();
        notifyListeners();
        return true;
      } else {
        _error = response.body;
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }



}
