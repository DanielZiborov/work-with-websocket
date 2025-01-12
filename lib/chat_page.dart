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

  List<types.Message> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<dynamic>(
        stream: channel.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            _messages.insert(
              0,
              types.TextMessage(
                author: _channel,
                id: Random().nextInt(10000).toString(),
                text: snapshot.data.toString(),
              ),
            );
            return Chat(
              showUserAvatars: true,
              messages: _messages,
              onSendPressed: (val) {
                channel.sink.add(val.text);
                _messages.insert(
                  0,
                  types.TextMessage(
                    author: _user,
                    id: Random().nextInt(10000).toString(),
                    text: val.text,
                  ),
                );
              },
              user: _user,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
