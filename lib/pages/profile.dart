import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
          ? CupertinoActivityIndicator()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('ID: ${userDetails?['id']}'),
                    Text('Email: ${userDetails?['email']}'),
                    Text('Name: ${userDetails?['name']}'),
                    Text('Email Verified: ${userDetails?['is_email_verified']}'),
                    Text('Subscription Active: ${userDetails?['is_subscription_active']}'),
                  ],
                ),
              ),
            ),
    );
  }
}
