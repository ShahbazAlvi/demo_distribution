// import 'dart:convert';
//
// import 'package:distribution/ApiLink/ApiEndpoint.dart';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart'as http;
//
// import '../model/DashBoardModel.dart';
//
// class DashBoardProvider with ChangeNotifier{
//
//   Future<DashboardModel?> fetchDashboardData() async {
//     try {
//       final response = await http.get(
//         Uri.parse('${ApiEndpoints.baseUrl}/dashboard/summary'),
//       );
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         notifyListeners();
//         return DashboardModel.fromJson(jsonData);
//
//       } else {
//         print("Failed to load dashboard data: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("Error fetching dashboard data: $e");
//       return null;
//     }
//   }
//
// }
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../ApiLink/ApiEndpoint.dart';
import '../model/DashBoardModel.dart';

class DashBoardProvider with ChangeNotifier {
  DashboardModel? dashboardData;
  bool isLoading = false;

  Future<void> fetchDashboardData() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/dashboard/summary'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        /// ⭐ SAVE DATA IN PROVIDER
        dashboardData = DashboardModel.fromJson(jsonData);

        isLoading = false;
        notifyListeners();    // ⭐ UI Refresh
      } else {
        isLoading = false;
        notifyListeners();
        print("Failed to load dashboard data: ${response.statusCode}");
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("Error fetching dashboard data: $e");
    }
  }
}
