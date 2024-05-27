import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../utils/customColors.dart';

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController(); // Yeni eklendi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.appBarColor,

        title: Text('Add Employee'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField( // Yeni eklenen doğum tarihi alanı
              controller: dobController,
              decoration: InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
            ),
            ElevatedButton(
              onPressed: () async {
                final response = await http.post(
                  Uri.parse('http://10.0.2.2:8080/employee'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode({
                    'name': nameController.text,
                    'email': emailController.text,
                    'dob': dobController.text, // Yeni eklenen doğum tarihi bilgisi
                  }),
                );
                if (response.statusCode == 200) {
                  Navigator.pop(context);
                } else {
                  throw Exception('Failed to add employee');
                }
              },
              child: Text('Add Employee'),
            ),
          ],
        ),
      ),
    );
  }
}
