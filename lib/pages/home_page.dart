import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'profile.dart';
import 'notes.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Note> notes = [];
  final storage = new FlutterSecureStorage();

  int _currentIndex = 0;

  final List<Widget> _children = [
    Text('Home'),
    Text('Insights'),
    UserDetailsPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    String? token = await storage.read(key: "accessToken");
    final response = await http.get(
      Uri.parse('https://vrec.onrender.com/api/get-transcriptions/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        notes.clear();
        for (var item in data) {
          notes.add(Note(
            date: item['date'],
            transcript: item['transcript'],
          ));
        }
      });
    } else {
      Fluttertoast.showToast(
          msg: "Error fetching notes",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;

    return MaterialApp(
      home: CupertinoTheme(
        data: CupertinoThemeData(
            brightness: darkModeOn ? Brightness.dark : Brightness.light),
        child: CupertinoApp(
          home: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.chart_bar),
                  label: 'Insights',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.add_circled),
                  label: 'New Note',
                ),
              ],
            ),
            tabBuilder: (BuildContext context, int index) {
              return CupertinoTabView(
                builder: (BuildContext context) {
                  switch (index) {
                    case 0:
                      return NotesList(notes: notes); // Updated line
                    case 1:
                      return Text('Iansights');

                    case 2:
                      return UserDetailsPage();
                  }
                  return Container();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
