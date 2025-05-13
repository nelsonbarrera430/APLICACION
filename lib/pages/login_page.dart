import 'package:flutter/material.dart';
import '../appwrite/auth_service.dart';
import 'home_page.dart';
import 'register_page.dart';
import '../widgets/login_background.dart'; 
import '../widgets/login_title.dart';
import '../widgets/login_text_field.dart';
import '../widgets/login_button.dart';
import '../widgets/register_text_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _login() async {
    try {
      await _auth.login(emailController.text, passwordController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const LoginBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const LoginTitle(),
                  const SizedBox(height: 30.0),
                  LoginTextField(controller: emailController, hintText: 'USERNAME...'),
                  const SizedBox(height: 15.0),
                  LoginTextField(controller: passwordController, hintText: 'PASSWORD...', obscureText: true),
                  const SizedBox(height: 30.0), 
                  LoginButton(onPressed: _login),
                  const SizedBox(height: 20.0),
                  RegisterTextButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}