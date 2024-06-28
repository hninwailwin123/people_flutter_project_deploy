// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:people_frontend/screens/user_list.dart';
import 'package:people_frontend/services/api.services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(String email, String password) async {
    try {
      final response = await login(email, password);
      print(response[0]);
      if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserListData(
              token: response[0],
              id: response[1],
              user_type: response[2],
            ),
          ),
        );
      }
    } catch (e) {
      // Handle errors
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _guestuser(context)
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "Login",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold,color: Color.fromRGBO(21, 101, 192, 1.0)),
        )
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Color.fromRGBO(21, 101, 192, 1.0).withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person)
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Color.fromRGBO(21, 101, 192, 1.0).withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            String email = _emailController.text;
            String password = _passwordController.text;
            _login(email, password);
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromRGBO(21, 101, 192, 1.0),
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        )
      ],
    );
  }

  _guestuser(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("If you are a guest user ,"),
        GestureDetector(
          onTap: () {
            String email = "guest@gmail.com";
            String password = "Password@123";
            _login(email, password);
          },
          child: Text(" click here!",style: TextStyle(color: Color.fromRGBO(21, 101, 192, 1.0),fontWeight: FontWeight.bold),)
        )
      ],
    );
  }
}
