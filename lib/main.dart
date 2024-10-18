import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(GenderizeApp());
}

class GenderizeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genderize App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GenderizeHomePage(),
    );
  }
}

class GenderizeHomePage extends StatefulWidget {
  @override
  _GenderizeHomePageState createState() => _GenderizeHomePageState();
}

class _GenderizeHomePageState extends State<GenderizeHomePage> {
  final TextEditingController _controller = TextEditingController();
  String? _gender;
  double? _probability;

  Future<void> fetchGender(String name) async {
    final url = Uri.parse('https://api.genderize.io?name=$name');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _gender = data['gender'];
          _probability = data['probability'];
        });
      } else {
        setState(() {
          _gender = null;
          _probability = null;
        });
      }
    } catch (e) {
      setState(() {
        _gender = null;
        _probability = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Genderize App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Введите имя'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fetchGender(_controller.text);
              },
              child: Text('Узнать пол'),
            ),
            SizedBox(height: 20),
            if (_gender != null)
              Text('Предполагаемый пол: $_gender Вероятность: ${(_probability! * 100).toStringAsFixed(2)}%'),
          ],
        ),
      ),
    );
  }
}
