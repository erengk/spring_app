import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../utils/customColors.dart';

class UpdateEmployeeScreen extends StatefulWidget {
  final int id;

  UpdateEmployeeScreen({required this.id});

  @override
  _UpdateEmployeeScreenState createState() => _UpdateEmployeeScreenState();
}

class _UpdateEmployeeScreenState extends State<UpdateEmployeeScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEmployee(context);
  }

  @override
  void dispose() {
    _idController.dispose();
    _ageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  fetchEmployee(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/employee/${widget.id}'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _idController.text = data['id'].toString();
          _ageController.text = data['age'].toString();
          _nameController.text = data['name'];
          _emailController.text = data['email'];
          _dobController.text = data['dob'] ?? '';
        });
      } else {
        print("Failed to fetch employee: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch employee details, status code: ${response.statusCode}'))
        );
      }
    } catch (e) {
      print("Error occurred while fetching employee data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred while fetching employee data'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.appBarColor,

        title: Text('Update Employee'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
              enabled: false, // ID alanı sadece görüntüleme için
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              enabled: false, // Age alanı sadece görüntüleme için
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _dobController,
              decoration: InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await http.put(
                    Uri.parse('http://10.0.2.2:8080/employee/${widget.id}'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode({
                      'name': _nameController.text,
                      'email': _emailController.text,
                      'dob': _dobController.text,
                    }),
                  );

                  if (response.statusCode == 200) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Employee updated successfully'))
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update employee, status code: ${response.statusCode}'))
                    );
                    print('Failed to update employee, status code: ${response.statusCode}');
                    print('Response body: ${response.body}');
                  }
                } catch (e) {
                  print("Error occurred while updating employee: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An error occurred while updating employee'))
                  );
                }
              },
              child: Text('Update Employee'),
            ),
          ],
        ),
      ),
    );
  }
}
