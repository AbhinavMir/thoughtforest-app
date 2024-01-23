import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'insightDetails.dart';

Future<List<Summary>> fetchSummaries() async {
  final storage = new FlutterSecureStorage();
  String? accessToken = await storage.read(key: 'accessToken');

  final response = await http.get(
    Uri.parse('https://vrec.onrender.com/api/all-summaries/'),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((item) => Summary.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load summaries');
  }
}

class InsightCard extends StatelessWidget {
  final Summary summary;

  InsightCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => InsightDetailsPage(summary: summary),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              summary.summary,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
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
    );
  }
}
