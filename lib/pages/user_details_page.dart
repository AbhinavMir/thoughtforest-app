import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        brightness: Brightness.dark, // This will make your background dark
        barBackgroundColor: CupertinoColors
            .darkBackgroundGray, // This will make your AppBar dark
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("User Details"),
          backgroundColor: CupertinoColors.darkBackgroundGray,
        ),
        child: Center(
          child: Container(
            color: CupertinoColors.darkBackgroundGray,
            child: Text("User Details"),
          ),
        ),
      ),
    );
  }
}
