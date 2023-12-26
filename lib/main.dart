import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login.dart';
import 'pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool>? _checkTokenFuture;

  @override
  void initState() {
    super.initState();
    _checkTokenFuture = checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _checkTokenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.data == true) {
              return HomePage(); // Redirect to HomePage if token is valid
            } else {
              return LoginPage(); // Redirect to LoginPage if token is not valid
            }
          }
        },
      ),
    );
  }
}

Future<bool> checkToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');
  String? refreshToken = prefs.getString('refreshToken');

  if (accessToken != null && refreshToken != null) {
    return await refreshTokenRequest(refreshToken);
  }
  return false;
}

Future<bool> refreshTokenRequest(String refreshToken) async {
  final response = await http.post(
    Uri.parse('https://vrec.onrender.com/token/refresh/'),
    headers: {"Content-Type": "application/json"},
    body: json.encode({'refresh': refreshToken}),
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', jsonResponse['access']);
    return true;
  } else {
    return false;
  }
}
