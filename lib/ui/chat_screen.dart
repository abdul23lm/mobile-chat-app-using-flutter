import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilechatapp/ui/sign_in_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          FlatButton.icon(
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return SignInScreen();
                }),
                (route) => false,
              );
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app),
            label: Text('Keluar'),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Placeholder()),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Masukkan pesan',
                    ),
                  ),
                ),
                FlatButton.icon(
                  textColor: Colors.blue,
                  onPressed: () {},
                  icon: Icon(Icons.send),
                  label: Text('Kirim'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
