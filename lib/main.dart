import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  Map _data = await getJSON();
  List _features = _data["features"];
  runApp(MaterialApp(
    title: "Quake App",
    home: Scaffold(
      appBar: AppBar(
        title: Text(
          "Quakes",
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: _features.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Divider(height: 3),
                  ListTile(
                    title: Text(
                      showDateTime(_features[index]["properties"]["time"]),
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    subtitle: Text(
                      _features[index]["properties"]["place"],
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        _features[index]["properties"]["mag"].toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {
                      showTapMessage(
                          context, _features[index]["properties"]["title"]);
                    },
                  ),
                ],
              );
            }),
      ),
    ),
  ));
}

String showDateTime(var data) {
  DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(data);
  var format = DateFormat.yMMMd("en_US").add_jm();
  var dateString = format.format(dateTime);
  return dateString;
}

void showTapMessage(BuildContext context, String message) {
  var alertDialog = AlertDialog(
    title: Text(message),
    actions: <Widget>[
      FlatButton(
        child: Text("OK"),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (context) {
      return alertDialog;
    }
  );
}

Future<Map> getJSON() async {
  String apiURL = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(apiURL);
  return json.decode(response.body);
}
