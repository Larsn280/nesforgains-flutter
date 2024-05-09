import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApiPage extends StatefulWidget {
  @override
  _MyApiPageState createState() => _MyApiPageState();
}

class _MyApiPageState extends State<MyApiPage> {
  String _data = '';

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the method to fetch data when the widget initializes
  }

  Future<void> fetchData() async {
    try {
      // Create a map containing the username and password
      Map<String, String> credentials = {
        'username': 'Larsn280',
        'password': 'LarsN280',
      };

      // Convert the credentials map to JSON
      String requestBody = json.encode(credentials);

      // Make a POST request to the login endpoint with the JSON-encoded credentials in the request body
      final response = await http.post(
        Uri.parse('http://localhost:5017/api/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _data = data['your_data_key'];
        });
      } else {
        // Display error message in console
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      // Display error message in console
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Example'),
      ),
      body: Center(
        child: Text(_data),
      ),
    );
  }
}
