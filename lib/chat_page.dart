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

  Future<void> chatWs() async {
    await channel.ready;
    channel.stream.listen(
      (message) {
        print(message);
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
    chatWs();
    super.initState();
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
              author: const types.User(
                id: '',
              ),
              id: '',
              text: val.text,
            ),
          );
        },
        user: const types.User(id: ''),
      ),
    );
  }
}
