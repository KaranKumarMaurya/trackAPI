import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchAlbum() async {
  final response = await http.get(Uri.parse(
      'https://www.clickpost.in/api/v2/tracking/awb-register/?format=json'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  final String key;
  final String waybill;

  Album({
    required this.key,
    required this.waybill,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      key: json['key'],
      waybill: json['waybill'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<dynamic>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<dynamic>>(
            future: futureAlbum,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(leading: Text(snapshot.data[0]))
                          ],
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
