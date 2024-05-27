import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/employee.dart';
import '../utils/customColors.dart';
import 'addEmployee.dart';
import 'updateEmployee.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<Employee> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

   Future<void> fetchEmployees() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/employee'));
    if (response.statusCode == 200) {
      setState(() {
        Iterable list = json.decode(response.body);
        employees = list.map((model) => Employee.fromJson(model)).toList();
      });
    }
  }

  void _confirmDeletion(int employeeId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this employee?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteEmployee(employeeId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEmployee(int employeeId) async {
    final response = await http.delete(Uri.parse('http://10.0.2.2:8080/employee/$employeeId'));
    if (response.statusCode == 200) {
      setState(() {
        employees.removeWhere((element) => element.id == employeeId);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Employee deleted successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete employee')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.appBarColor,
        title: Text('Employee List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddEmployeeScreen()));
              if (result == true) {
                fetchEmployees();
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return ListTile(
            title: Text(employee.name),
            subtitle: Text(employee.email),
            onTap: () async {
              final result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => UpdateEmployeeScreen(id: employee.id)));
              if (result == true) {
                fetchEmployees();
              }
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _confirmDeletion(employee.id);
              },
            ),
          );
        },
      ),
    );
  }
}
