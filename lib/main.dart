import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spring_app/screens/employeeListScreen.dart';
import 'package:spring_app/screens/loginScreen.dart';
import 'package:spring_app/utils/customColors.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: CustomColors.bodyBackgroundColor,
      ),
      home: Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
