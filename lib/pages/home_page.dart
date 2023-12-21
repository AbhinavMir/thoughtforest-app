import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText speech = SpeechToText();
  bool isListening = false; 
  String transcription = '';

  @override
  void initState() {
    super.initState();
    try {
      speech.initialize();
      print("Speech initialized");
    } catch (e) {
      print("Can't initialize speech recognition: " + e.toString());
    }
  }

  void startListening() async {
    await speech.listen(onResult: (val) {
      setState(() {
        transcription = val.recognizedWords;
      });
    });

    setState(() => isListening = true);
    print(transcription);
  }

  void stopListening() {
    speech.stop();
    setState(() => isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: isListening ? stopListening : startListening,
        child: Icon(isListening ? Icons.mic : Icons.stop),
      ),
      body: Column(
        children: [//
          Expanded(
            child: Center(
              child: Text(transcription),
            ),
          ),
        ],
      ),
    );
  }
}