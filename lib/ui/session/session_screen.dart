import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobilechatapp/ui/chat/chat_screen.dart';
import 'package:mobilechatapp/ui/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({Key key}) : super(key: key);

  static const String routeName = 'session-screen';

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;

      Navigator.pushNamedAndRemoveUntil(
        context,
        user != null ? ChatScreen.routeName : SignInScreen.routeName,
        (_) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
