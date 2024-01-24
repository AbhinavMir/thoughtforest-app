import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
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
          middle: Text('Bottom Nav Example'),
          backgroundColor: CupertinoColors.darkBackgroundGray,
        ),
        child: Center(
          child: Text('Content goes here'),
        ),
      ),
    );
  }
}
