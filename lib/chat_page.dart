import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final channel = WebSocketChannel.connect(
    Uri.parse(
      'wss://echo.websocket.org',
    ),
  );

  final _user = const types.User(
    id: '1',
  );

  final _channel = const types.User(
    id: '2',
  );

  Future<void> chatWs() async {
    await channel.ready;
    channel.stream.listen(
      (message) {
        addMessage(
          types.TextMessage(
            author: _channel,
            id: Random().nextInt(10000).toString(),
            text: message,
          ),
        );
      },
    );
  }

  void addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  List<types.Message> _messages = [];

  @override
  void initState() {
    super.initState();
    chatWs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chat(
        messages: _messages,
        onSendPressed: (val) {
          channel.sink.add(val.text);
          addMessage(
            types.TextMessage(
              author: _user,
              id: Random().nextInt(10000).toString(),
              text: val.text,
            ),
          );
        },
        user: _user,
      ),
    );
  }
}
