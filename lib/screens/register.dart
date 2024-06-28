import 'package:flutter/material.dart';
import 'package:people_frontend/screens/login_screen.dart';
import 'package:people_frontend/services/api.services.dart';

class RegistrationPage extends StatefulWidget {
  final email;
  final name;
  const RegistrationPage({Key? key, required this.email, required this.name})
      : super(key: key);
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool passwordToggle = true;
  bool confrimPasswordToggle = true;
  bool passwordErr = false;
  bool confrimPasswordErr = false;
  String passwordWarning = '';
  String comfirmPasswordWarning = '';
  @override
  void initState() {
    super.initState();
    _nameController = new TextEditingController(text: widget.name);
    _emailController = new TextEditingController(text: widget.email);
  }
  bool _validateData() {
    bool isValid = true;
    if (_passwordController.text.isEmpty) {
      setState(() {
        passwordWarning = '* Please enter your password';
        passwordErr = true;
        isValid = false;
      });
    }
    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        comfirmPasswordWarning = '* Please enter your confirm password';
        confrimPasswordErr = true;
        isValid = false;
      });
    }
    if (_confirmPasswordController.text.isNotEmpty &&
        _passwordController.text != _confirmPasswordController.text) {
      setState(() {
        comfirmPasswordWarning = '* Retype ConfrimPassword to same Password';
        confrimPasswordErr = true;
        isValid = false;
      });
    }
    return isValid;
  }
  Future<void> _submitForm() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String password_confirmation = _confirmPasswordController.text;
    try {
      await updatePassword(email, password, password_confirmation);
    } catch (e) {
      SnackBar(
          content: Text(
        '${e}',
        style: const TextStyle(backgroundColor: Colors.red),
      ));
    } finally {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset : false,
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            children: [
              _header(context),
              SizedBox(height: 40),
              _inputField(context)
            ],
          ),
        ),
      ),
    );
  }
  _header(context) {
    return Text(
      "Register",
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    );
  }
  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextFormField(
          keyboardType: TextInputType.text,
          controller: _nameController,
          decoration: InputDecoration(
            hintText: "Name",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(18),
            ),
            fillColor: const Color.fromRGBO(21, 101, 192, 1.0).withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          keyboardType: TextInputType.text,
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Email",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(18),
            ),
            fillColor: const Color.fromRGBO(21, 101, 192, 1.0).withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          keyboardType: TextInputType.text,
          controller: _passwordController,
          obscureText: passwordToggle,
          decoration: InputDecoration(
              hintText: "Password",
              errorText: passwordWarning,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: passwordErr
                    ? const BorderSide(color: Colors.red)
                    : BorderSide.none, // Red border when error
              ),
              fillColor:
                  const Color.fromRGBO(21, 101, 192, 1.0).withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    passwordToggle = !passwordToggle;
                  });
                },
                child: Icon(
                  passwordToggle ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
              )),
          onChanged: (value) {
            setState(() {
              passwordErr = false;
              passwordWarning = '';
            });
          },
        ),
        TextFormField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
              hintText: "Confrim Password",
              errorText: comfirmPasswordWarning,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: passwordErr
                    ? const BorderSide(color: Colors.red)
                    : BorderSide.none, // Red border when error
              ),
              fillColor:
                  const Color.fromRGBO(21, 101, 192, 1.0).withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    confrimPasswordToggle = !confrimPasswordToggle;
                  });
                },
                child: Icon(
                  confrimPasswordToggle
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.black,
                ),
              )),
          obscureText: confrimPasswordToggle,
          onChanged: (value) {
            setState(() {
              confrimPasswordErr = false;
              comfirmPasswordWarning = '';
            });
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_validateData()) {
              _submitForm();
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromRGBO(21, 101, 192, 1.0),
          ),
          child: const Text(
            "Register",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        )
      ],
    );
  }
}





