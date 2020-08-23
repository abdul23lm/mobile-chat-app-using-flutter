// stful
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilechatapp/ui/chat_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // controllers

  final TextEditingController _emailController =
      TextEditingController(text: 'user1@email.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '123456');

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
              decoration: InputDecoration(hintText: 'Masukkan email'),
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
                  onPressed: _isLoading ? null : _onSignIn,
                  child: Text('Masuk'),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> _onSignIn() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      final UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential != null) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ChatScreen();
        }), (route) => false);
      }
    } catch (e) {
      print(e);
    }
  }
}
