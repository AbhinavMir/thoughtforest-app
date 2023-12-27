import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home_page.dart'; // Import home page component
import 'package:flutter/material.dart';
import 'profile.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final storage = FlutterSecureStorage();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void navigateToHomePage(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => HomePage()),
    );
  }

  void showErrorToast() {
    Fluttertoast.showToast(
      msg: "Error logging in!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: CupertinoColors.systemRed,
      textColor: CupertinoColors.white,
      fontSize: 16.0
    );
  }

  ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.white,
  primary: Colors.blue[800],
  minimumSize: Size(200, 50),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

  // For TextButton
  ButtonStyle textButtonStyle = TextButton.styleFrom(
    primary: Colors.white,
    minimumSize: Size(200, 50),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      side: BorderSide(color: Colors.blue, width: 2),
    ),
  );


  void showLoggedInToast() {
    Fluttertoast.showToast(
      msg: "Logging you in!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: CupertinoColors.systemGreen,
      textColor: CupertinoColors.white,
      fontSize: 16.0
    );
  }
  void showLogInToast() {
      Fluttertoast.showToast(
        msg: "Please wait",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.white,
        textColor: CupertinoColors.systemGrey,
        fontSize: 16.0
      );
    }

  void showRegisterToast() {
    Fluttertoast.showToast(
      msg: "Registering!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: CupertinoColors.systemGrey,
      textColor: CupertinoColors.white,
      fontSize: 16.0
    );
  }

  Future<void> loginUser(String email, String password, BuildContext context) async {

  showLogInToast();

  var url = Uri.parse('https://vrec.onrender.com/token/');
  var response = await http.post(url, body: {
    'email': email,
    'password': password,
  });

  if (response.statusCode == 200) {

    var jsonResponse = json.decode(response.body);
    if (jsonResponse.containsKey('access') && jsonResponse.containsKey('refresh')) {
      // Handle the response, such as storing the tokens or navigating to another screen
      await storage.write(key: 'accessToken', value: jsonResponse['access']);
      await storage.write(key: 'refreshToken', value: jsonResponse['refresh']);

      showLoggedInToast();
      navigateToHomePage(context);
    } else {
      showErrorToast();
    }
  } else {
    showErrorToast();
  }
}
  
  // Function to handle login
  void handleLogin(BuildContext context) async {
    showLogInToast();

    String username = _usernameController.text;
    String password = _passwordController.text;

    // Call loginUser with username and password
    await loginUser(username, password, context);
    
  }


  // Custom styles
  final TextStyle textStyle = TextStyle(
    fontSize: 30,
    color: Colors.white,
    shadows: <Shadow>[
      Shadow(
        offset: Offset(0, 0),
        blurRadius: 10.0,
        color: Colors.black.withOpacity(0.5),
      ),
    ],
  );

  final InputDecoration inputDecoration = InputDecoration(
    labelText: 'Enter text',
    labelStyle: TextStyle(color: Colors.white),
    fillColor: Colors.white.withOpacity(0.2),
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
    ),
  );


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/login-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60),
                
                  SizedBox(height: 30),
                
                  SizedBox(height: 40),

                  // username
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CupertinoTextField(
                      controller: _usernameController,
                      placeholder: 'Username',
                      placeholderStyle: TextStyle(color: CupertinoColors.systemGrey),
                      decoration: BoxDecoration(
                        color: CupertinoColors.black.withOpacity(0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      style: TextStyle(color: CupertinoColors.white),
                    ),
                  ),
                  SizedBox(height: 20),

                  // password
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CupertinoTextField(
                      controller: _passwordController,
                      placeholder: 'Password',
                      obscureText: true,
                      placeholderStyle: TextStyle(color: CupertinoColors.systemGrey),
                      decoration: BoxDecoration(
                        color: CupertinoColors.black.withOpacity(0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      style: TextStyle(color: CupertinoColors.white),
                    ),
                  ),
                  SizedBox(height: 40),

                  // login button
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: CupertinoButton(
                      color: Colors.green.withOpacity(0.2),
                      onPressed: () => handleLogin(context),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          // bold
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),

                  // register button
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: CupertinoButton(
                      child: Text('REGISTER',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[200],
                        ),),
                      onPressed: showRegisterToast,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}