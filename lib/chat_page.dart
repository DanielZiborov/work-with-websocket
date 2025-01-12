import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final channel = WebSocketChannel.connect(
      Uri.parse(
        'wss://echo.websocket.org',
      ),
    );

    const user = types.User(
      id: '1',
    );

    const webSocket = types.User(
      id: '2',
    );

    List<types.Message> messages = [];

    return Scaffold(
      body: StreamBuilder<dynamic>(
        stream: channel.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            messages.insert(
              0,
              types.TextMessage(
                author: webSocket,
                id: Random().nextInt(10000).toString(),
                text: snapshot.data.toString(),
              ),
            );
            return Chat(
              showUserAvatars: true,
              messages: messages,
              onSendPressed: (val) {
                channel.sink.add(val.text);
                messages.insert(
                  0,
                  types.TextMessage(
                    author: user,
                    id: Random().nextInt(10000).toString(),
                    text: val.text,
                  ),
                );
              },
              user: user,
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
