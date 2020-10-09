import 'package:firebase_core/firebase_core.dart';
import 'package:mobilechatapp/router.dart';
import 'package:flutter/material.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Chat using Flutter',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Router.initialRoute,
      routes: Router.routes,
      builder: (BuildContext context, Widget widget) {
        return FutureBuilder<FirebaseApp>(
          future: Firebase.initializeApp(),
          builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return widget;
            }

            return Scaffold();
          },
        );
      },
    );
  }
}
