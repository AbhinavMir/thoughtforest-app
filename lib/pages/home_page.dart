import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'profile.dart';

class Note {
  final String date;
  final String transcript;

  Note({required this.date, required this.transcript});
}

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
              ],
            ),
            tabBuilder: (BuildContext context, int index) {
              return CupertinoTabView(
                builder: (BuildContext context) {
                  switch (index) {
                    case 0:
                      return CupertinoPageScaffold(
                        navigationBar: CupertinoNavigationBar(
                          middle: Text('Home Page'),
                        ),
                        child: SafeArea(
                          child: ListView.builder(
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title: Text(notes[index].transcript),
                                  subtitle: Text(notes[index].date),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    case 1:
                      return CupertinoPageScaffold(
                        navigationBar: CupertinoNavigationBar(
                          middle: Text('Insights'),
                        ),
                        child: SafeArea(
                          child: Center(
                            child: Text('Insights'),
                          ),
                        ),
                      );

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
