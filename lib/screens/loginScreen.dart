import 'package:flutter/material.dart';
import 'package:spring_app/screens/employeeListScreen.dart';
import '../service/authenticationService.dart';
import '../utils/customColors.dart';
import '../widgets/customElevatedButton.dart';
import '../widgets/popup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    String logoImage = "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.appBarColor,
        title: const Text('Giriş Yap'),
      ),
      backgroundColor: CustomColors.bodyBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(26),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(hintText: "kullanıcı adı"),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(hintText: 'Şifre'),
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              CustomElevatedButton(
                onPressed: () async {
                  String uid = await AuthenticationService().signIn(
                    "${_usernameController.text}@mail.com",
                    _passwordController.text,
                  );
                  if (uid == "null") {
                    popUp(context, "Hatalı Giriş",
                        "Kullanıcı adı veya Şifreniz Hatalı");
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeListScreen(),
                      ),
                    );
                  }
                },
                buttonText: 'Giriş Yap',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container imageContainer(String logoImage, double height) {
    return Container(
      height: 180,
      width: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(logoImage),
        ),
      ),
    );
  }
}
