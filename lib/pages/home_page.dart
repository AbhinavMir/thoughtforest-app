import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.graph_circle),
                  label: 'Insights',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.book),
                  label: 'Notes',
                ),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.person), label: 'Profile'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.add), label: 'Add'),
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
                      // Return the widget for the second tab
                      break;
                    // Add more cases for more tabs
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
