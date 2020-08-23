import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilechatapp/ui/sign_in_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageNode = FocusNode();

  final DatabaseReference root = FirebaseDatabase.instance.reference();
  final User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    final DatabaseReference chatReference =
        root.child('/chats/${user.uid}/chats').reference();

    chatReference.onValue.listen((event) {
      print(event.snapshot.value);
    });
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageNode.dispose();

    super.dispose();
  }

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
                    controller: _messageController,
                    focusNode: _messageNode,
                    decoration: InputDecoration(
                      hintText: 'Masukkan pesan',
                    ),
                  ),
                ),
                FlatButton.icon(
                  textColor: Colors.blue,
                  onPressed: _onSend,
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

  void _onSend() {
    final String message = _messageController.text.trim();

    if (message.isNotEmpty) {
      final User sender = FirebaseAuth.instance.currentUser;
      final String receiver = sender.uid == 'ecIvrKTpg3PwfzGm4b7ORQTrj6F3'
          ? 'zBLOguWRlISvI5YTiq6cnpIhLB22'
          : 'ecIvrKTpg3PwfzGm4b7ORQTrj6F3';
      final DatabaseReference root = FirebaseDatabase.instance.reference();
      final DatabaseReference chats =
          root.child('/chats/${sender.uid}/chats').reference();

      final String key = chats.push().key;

      root.update({
        // sender
        '/chats/${sender.uid}/chats/$key': {
          'text': message,
          'timestamp': DateTime.now().microsecondsSinceEpoch,
          'from': sender.uid,
        },
        '/chats/${sender.uid}/with': receiver,

        // receiver
        '/chats/${sender.uid}/chats/$key': {
          'text': message,
          'timestamp': DateTime.now().microsecondsSinceEpoch,
          'from': sender.uid,
        },
        '/chats/$receiver/with': sender.uid,
      });
      // Kirim ke firebase

      _messageController.clear();
    }
  }
}
