// stful
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // controllers

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // focus mode
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  // state
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Masukkan email anda'),
            ),
            Text(
              'Password',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'Masukkan kata sandi'),
            ),
            SizedBox(height: 16.0),
            Align(
                alignment: Alignment.center,
                child: RaisedButton(
                  onPressed: _isLoading ? null : () {},
                  child: Text('Masuk'),
                ))
          ],
        ),
      ),
    );
  }
}
