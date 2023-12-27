import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Note Model
class Note {
  final String date;
  final String transcript;

  Note({required this.date, required this.transcript});
}

// NotesList Widget
class NotesList extends StatelessWidget {
  
  final List<Note> notes;

  const NotesList({Key? key, required this.notes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  }
}
