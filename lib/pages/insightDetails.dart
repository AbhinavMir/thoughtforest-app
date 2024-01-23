import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'insightDetails.dart';

class Summary {
  final int id;
  final String mood;
  final String summary;
  final String date;
  final int user;

  Summary(
      {required this.id,
      required this.mood,
      required this.summary,
      required this.date,
      required this.user});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      id: json['id'],
      mood: json['mood'],
      summary: json['summary'],
      date: json['date'],
      user: json['user'],
    );
  }
}

class InsightDetailsPage extends StatelessWidget {
  final Summary summary;

  InsightDetailsPage({required this.summary});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Insight Details'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                summary.summary,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Date: ${summary.date}',
                style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}