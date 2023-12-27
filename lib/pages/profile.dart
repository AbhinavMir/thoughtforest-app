import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatefulWidget {
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final storage = FlutterSecureStorage();
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    String accessToken = await storage.read(key: 'accessToken') ?? '';
    final response = await http.get(
      Uri.parse('https://vrec.onrender.com/api/user-details/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        userDetails = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load user details');
    }
  }
@override
Widget build(BuildContext context) {
  return CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(
      middle: Text('User Details'),
    ),
    child: userDetails == null
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.email),
                      subtitle: Text('Email'),
                      title: Text('${userDetails?['email']}'),
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      subtitle: Text('Name'),
                      title: Text('${userDetails?['name']}'),
                    ),
                    ListTile(
                      leading: Icon(Icons.verified_user),
                      title: Text('Email Verified'),
                      subtitle: Text('${userDetails?['is_email_verified']}'),
                    ),
                    ListTile(
                      leading: Icon(Icons.subscriptions),
                      subtitle: Text('Subscription Active'),
                      title: Text('${userDetails?['is_subscription_active']}'),
                    ),
                  ],
                ),
              ),
            ),
          ),
  );
}
}