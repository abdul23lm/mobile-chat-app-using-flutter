import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Chat App using Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignInScreen(),
    );
  }
}

// stful
class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sign In'),
      ),
      body: Column(
        children: [
          Text('Email'),
          TextField(
            decoration: InputDecoration(hintText: 'Masukkan email anda'),
          ),
          Text('Password'),
          TextField(
            decoration: InputDecoration(hintText: 'Masukkan kata sandi'),
          ),
          RaisedButton(
            onPressed: () {},
            child: Text('Masuk'),
          )
        ],
      ),
    );
  }
}
