import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteEmployee extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DeleteEmployeeState();
  }
}

class DeleteEmployeeState extends State<DeleteEmployee> {
  final TextEditingController _idController = TextEditingController();

  Future<void> deleteEmployee(String id) async {
    final url = Uri.parse('http://10.0.2.2:8080/employee/$id');
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Successfully deleted the employee
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(title: 'Success', content: 'Employee deleted successfully.');
        },
      );
    } else {
      // Handle the error
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(title: 'Error', content: 'Failed to delete employee.');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'Employee ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Employee ID';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final id = _idController.text;
                deleteEmployee(id);
              },
              child: Text('Delete Employee'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  MyAlertDialog({
    required this.title,
    required this.content,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: this.actions,
      content: Text(
        this.content,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
