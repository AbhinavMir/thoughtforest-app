import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:intl/intl.dart';


class NewNotePage extends StatefulWidget {
  final Function? onNoteAdded;

  NewNotePage({Key? key, required this.onNoteAdded}) : super(key: key);

  @override
  _NewNotePageState createState() => _NewNotePageState();
}


class _NewNotePageState extends State<NewNotePage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> sendTranscript() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    // Get the current date and time, flutter: {"date":["Date has wrong format. Use one of these formats instead: YYYY-MM-DD."]}
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // get user ID from thoughtforest_userid in storage access
    String? userId = await storage.read(key: 'thoughtforest_userid');

    // Calculate the length of the transcript
    int length = _controller.text.length;

    var response = await http.post(
      Uri.parse('https://vrec.onrender.com/api/add-transcription/'),
      headers: {'Authorization': 'Bearer $accessToken'},
      body: {
        'transcript': _controller.text,
        'date': date,
        'user': userId.toString(),
        'length': length.toString(),
      },
    );

    if (response.statusCode == 201) {
      Fluttertoast.showToast(
        msg: 'Transcript sent successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      // empty the tab
      _controller.clear();
    } else {
      Fluttertoast.showToast(
        msg: 'Failed to send transcript',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('New Note'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.mic),
              onPressed: () {
                // This is where the record button action goes
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.paperplane),
              onPressed: sendTranscript,
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CupertinoTextField(
            controller: _controller,
            maxLines: null,
            placeholder: 'Write your note here...',
            decoration: null,
          ),
        ),
      ),
    );
  }
}
