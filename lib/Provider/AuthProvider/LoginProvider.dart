import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiLink/ApiEndpoint.dart';
import '../../Screen/DashBoardScreen.dart';



class LoginProvider with ChangeNotifier{

  bool isLoading = false;
  String message="";


//gets
  bool get _isLoading=>isLoading;
  String get _message=>message;
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  Future<void>login(BuildContext context)async{
    final email= emailController.text.trim();
    final password=passwordController.text.trim();
    if(email.isEmpty||password.isEmpty) {
      message = "Please enter email and password";
      notifyListeners();
      return;
    }
    isLoading= true;
    message="";
    notifyListeners();

    try{
      final response=await http.post(Uri.parse('${ApiEndpoints.baseUrl}/auth/login'),
          headers: {"Content-Type": "application/json"},

          body: jsonEncode({
            'identifier':email,
            'password':password
          }));


      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        message = "Login successful!";

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', data["data"]["accessToken"]);
        await prefs.setString(
            'username', data['data']['user']['username'] ?? '');
        await prefs.setString('user', jsonEncode(data["data"]["user"]));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboardscreen()),
        );
      } else {
        message = data["message"] ?? "Invalid credentials";
      }


    }catch(e){
      print(e);
      message = "Something went wrong: $e";

    }
    isLoading=false;
    notifyListeners();



  }
}