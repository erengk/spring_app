class Employee {
  final int id;
  final String name;
  final String email;
  final String dob;
  final int age;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.dob,
    required this.age,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      dob: json['dob'],
      age: json['age'],
    );
  }
}