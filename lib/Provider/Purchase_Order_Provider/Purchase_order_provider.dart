import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/Purchase_Order_Model/Purchase_order_Model.dart';

class PurchaseOrderProvider with ChangeNotifier{
  List<PurchaseOrder> _orders = [];
  bool _isLoading = false;
  String _error='';

  //gets
  List<PurchaseOrder> get orders => _orders;
bool get isLoading=>_isLoading;
String get error=> _error;

Future<void>fetchPurchaseOrder()async{
  _isLoading = true;
  notifyListeners();
  try{
    final prefs = await SharedPreferences.getInstance();
    final token=prefs.getString("token");
    if(token==null){
      _error='token is null';
      _isLoading=false;
      notifyListeners();
      return;
    }
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}/purchase-orders'),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "x-company-id": "2",
        "Cache-Control": "no-cache", // prevents 304 cache response
      },
    );
    final data = jsonDecode(response.body);
    print(data);

    PurchaseOrderResponse poResponse = PurchaseOrderResponse.fromJson(data);
    _orders = poResponse.orders;

  }catch(e){
    _error = "Error fetching orders: $e";
  }
  _isLoading=false;
  notifyListeners();
}

Future<void>AddPurchaseOrder(
  {
    required String orderid,
    required String Supplierid,
    required String status,
    required List<Map<String, dynamic>> products,
}
    )async{
  try{
  _isLoading =true;
  _error='';
  notifyListeners();
  final prefs= await SharedPreferences.getInstance();
  final token=prefs.getString("token");
  if(token == null){
    _error='token is null again login';
    _isLoading = false;
    return;
  }
  final response=await http.post(Uri.parse('${ApiEndpoints.baseUrl}/purchase-orders'));

  }catch(e){

  }


}



}