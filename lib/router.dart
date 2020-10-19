import 'package:mobilechatapp/ui/chat/chat_screen.dart';
import 'package:mobilechatapp/ui/session/session_screen.dart';
import 'package:mobilechatapp/ui/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';

class Router {
  static const String initialRoute = SessionScreen.routeName;

  static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    SignInScreen.routeName: (_) => SignInScreen(),
    ChatScreen.routeName: (_) => ChatScreen(),

  };
}
