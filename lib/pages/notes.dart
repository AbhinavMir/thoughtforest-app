import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Note Model
class Note {
  final String date;
  final String transcript;
  bool isPinned;

  Note({required this.date, required this.transcript, this.isPinned = false});
}

class NotesList extends StatefulWidget {
  final List<Note> notes;

  const NotesList({Key? key, required this.notes}) : super(key: key);

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  List<Note> sortedNotes = [];

  @override
  void initState() {
    super.initState();
    sortedNotes = widget.notes;
    sortNotes(true); // sort by newest first by default
  }

  void sortNotes(bool isNewestFirst) {
    setState(() {
      sortedNotes.sort((a, b) {
        if (b.isPinned != a.isPinned) {
          return b.isPinned ? 1 : -1;
        } else {
          return isNewestFirst
              ? b.date.compareTo(a.date)
              : a.date.compareTo(b.date);
        }
      });
    });
  }

  void pinNote(int index) {
    setState(() {
      sortedNotes[index].isPinned = !sortedNotes[index].isPinned;
      sortNotes(true); // re-sort the notes
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('All your notes', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Sort'),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                title: const Text('Sort Options'),
                actions: <CupertinoActionSheetAction>[
                  CupertinoActionSheetAction(
                    child: const Text('Newest First'),
                    onPressed: () {
                      Navigator.pop(context);
                      sortNotes(true);
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('Oldest First'),
                    onPressed: () {
                      Navigator.pop(context);
                      sortNotes(false);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: Container(
          color: Colors.black,
          child: ListView.builder(
            itemCount: sortedNotes.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                color: sortedNotes[index].isPinned
                    ? Colors.grey[700]
                    : Colors.grey[850],
                child: ListTile(
                  title: Text(
                    sortedNotes[index].transcript,
                    style: TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    sortedNotes[index].date,
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      sortedNotes[index].isPinned
                          ? Icons.push_pin
                          : Icons.push_pin_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () => pinNote(index),
                  ),
                  // rest of your code
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
