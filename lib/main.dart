//flutter pub run build_runner build НЕ ЗАБУДЬ!!!!

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final Dio _dio = Dio();

  Future<dynamic> fetchPosts() async {
    final response =
        await _dio.get('https://jsonplaceholder.typicode.com/posts');
    return response.data;
  }

  Future<dynamic> fetchPost() async {
    final response =
        await _dio.get('https://jsonplaceholder.typicode.com/posts/1');
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _navigateToShowDataScreen(context, fetchPosts),
              child: Text('Text1'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToShowDataScreen(context, fetchPost),
              child: Text('Text21'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToShowDataScreen(
      BuildContext context, Future<dynamic> Function() fetchData) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ShowDataScreen(fetchData: fetchData)));
  }
}

class ShowDataScreen extends StatelessWidget {
  final Future<dynamic> Function() fetchData;

  const ShowDataScreen({Key? key, required this.fetchData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('baza'),
      ),
      body: FutureBuilder<dynamic>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              child: snapshot.data is List
                  ? Column(
                      children: (snapshot.data as List)
                          .map((post) => Text(post['title'],
                              style: TextStyle(fontSize: 18)))
                          .toList(),
                    )
                  : Text(snapshot.data['title'],
                      style: TextStyle(fontSize: 24)),
            );
          }
        },
      ),
    );
  }
}
