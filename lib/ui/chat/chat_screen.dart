import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobilechatapp/ui/sign_in/sign_in_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key}) : super(key: key);

  static const String routeName = 'chat-screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final User user = FirebaseAuth.instance.currentUser;
  final DatabaseReference root = FirebaseDatabase.instance.reference();

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  List<Map<dynamic, dynamic>> messages = [];

  bool _isSigningOut = false;
  Map<dynamic, dynamic> _lastMessage;

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference chatReference =
        root.child('/chats/${user.uid}/chats').reference();

    return Scaffold(
      appBar: AppBar(
        title: Text('ChatScreen'),
        actions: [
          FlatButton.icon(
            onPressed: _onSignOut,
            icon: _isSigningOut
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Icon(Icons.exit_to_app, color: Colors.white),
            label: Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<Event>(
                // TODO(lucky): should use standalone events
                stream: chatReference.onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.active) {
                    final Event event = snapshot.data;
                    final Map<dynamic, dynamic> collection =
                        event.snapshot.value as Map<dynamic, dynamic>;

                    if (collection != null) {
                      final List<dynamic> messages = collection
                          .map((key, item) {
                            final Map<dynamic, dynamic> modifiedItem = (item
                                as Map<dynamic, dynamic>)
                              ..addAll({'key': key});

                            return MapEntry(key, modifiedItem);
                          })
                          .values
                          .toList()
                            ..sort((prev, next) {
                              final prevTime = prev['timestamp'];
                              final nextTime = next['timestamp'];

                              return nextTime - prevTime;
                            });

                      return ListView.builder(
                        padding: EdgeInsets.all(16.0),
                        reverse: true,
                        itemBuilder: (BuildContext context, int index) {
                          final Map<dynamic, dynamic> message = messages[index];
                          final String text = message['text'];
                          final String from = message['from'];

                          final DateTime time =
                              DateTime.fromMicrosecondsSinceEpoch(
                                  message['timestamp']);
                          final bool isMe = from == user.uid;

                          return GestureDetector(
                            onTap: () {
                              if (isMe) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SimpleDialog(
                                      title: Text('Actions'),
                                      children: [
                                        SimpleDialogOption(
                                          onPressed: () => _editMode(message),
                                          child: Text('Edit'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () =>
                                              _deleteMessage(message),
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 16.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color:
                                    isMe ? Colors.teal[200] : Colors.blueGrey,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Column(
                                crossAxisAlignment: isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    text,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(height: 2.0),
                                  Text(
                                    time.toIso8601String(),
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: messages.length,
                      );
                    }
                  }

                  return SizedBox.shrink();
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Enter a message'),
                      controller: _messageController,
                      focusNode: _messageFocusNode,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) {
                        _sendMessage();
                      },
                    ),
                  ),
                ),
                FlatButton.icon(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send, color: Colors.teal),
                  label: Text('Send', style: TextStyle(color: Colors.teal)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteMessage(Map<dynamic, dynamic> message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hapus pesan'),
            content: Text('Yakin untuk menghapus pesan ini?'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  final String key = message['key'];

                  final String to = user.uid == 'ecIvrKTpg3PwfzGm4b7ORQTrj6F3'
                      ? 'zBLOguWRlISvI5YTiq6cnpIhLB22'
                      : 'ecIvrKTpg3PwfzGm4b7ORQTrj6F3';

                  FirebaseDatabase.instance.reference()
                    ..child('/chats/${user.uid}/chats/$key').remove()
                    ..child('/chats/$to/chats/$key').remove();
                },
                textColor: Colors.grey,
                child: Text('Ya'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Tidak'),
              ),
            ],
          );
        });
  }

  void _editMode(Map<dynamic, dynamic> message) {
    Navigator.pop(context);

    final String text = message['text'];

    _lastMessage = message;
    _messageController.text = text;
    _messageFocusNode.requestFocus();
  }

  void _sendMessage() {
    final String message = _messageController.text;

    if (message.isNotEmpty) {
      if (_lastMessage != null &&
          _lastMessage['text'] != null &&
          _lastMessage['text'] != _messageController.text) {
        _messageController.clear();

        final String from = _lastMessage['from'];
        final String key = _lastMessage['key'];
        final int timestamp = _lastMessage['timestamp'];

        final String to = user.uid == 'ecIvrKTpg3PwfzGm4b7ORQTrj6F3'
            ? 'zBLOguWRlISvI5YTiq6cnpIhLB22'
            : 'ecIvrKTpg3PwfzGm4b7ORQTrj6F3';

//        // update
        Map<String, dynamic> chatData = {
          '/chats/${user.uid}/with': to,
          '/chats/${user.uid}/chats/$key': {
            'text': message,
            'timestamp': timestamp,
            'from': from,
          },
//
          /// destination
          '/chats/$to/with': user.uid,
          '/chats/$to/chats/$key': {
            'text': message,
            'timestamp': timestamp,
            'from': from,
          },
        };

        root.update(chatData);
        _lastMessage = null;
        _messageFocusNode.unfocus();
      } else {
        _messageController.clear();
        final DatabaseReference chatReference =
            root.child('/chats/${user.uid}/chats').reference();

        final String chatKey = chatReference.push().key;

        final String to = user.uid == 'ecIvrKTpg3PwfzGm4b7ORQTrj6F3'
            ? 'zBLOguWRlISvI5YTiq6cnpIhLB22'
            : 'ecIvrKTpg3PwfzGm4b7ORQTrj6F3';

        // add
        Map<String, dynamic> chatData = {
          '/chats/${user.uid}/with': to,
          '/chats/${user.uid}/chats/$chatKey': {
            'text': message,
            'timestamp': DateTime.now().microsecondsSinceEpoch,
            'from': user.uid,
          },

          /// destination
          '/chats/$to/with': user.uid,
          '/chats/$to/chats/$chatKey': {
            'text': message,
            'timestamp': DateTime.now().microsecondsSinceEpoch,
            'from': user.uid,
          },
        };

        root.update(chatData);
      }
    }
  }

  void _onSignOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Keluar'),
          content: Text('Anda yakin akan keluar?'),
          actions: [
            FlatButton(
              textColor: Colors.grey,
              child: Text('Ya'),
              onPressed: () async {
                setState(() {
                  _isSigningOut = true;
                });

                try {
                  await FirebaseAuth.instance.signOut();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    SignInScreen.routeName,
                    (_) => false,
                  );
                } catch (e) {
                  setState(() {
                    _isSigningOut = false;
                  });

                  print('Failed to sign out');
                }
              },
            ),
            FlatButton(
              child: Text('Tidak'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
