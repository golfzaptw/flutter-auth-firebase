import 'package:flutter/material.dart';
import 'package:flutter_firebase/views/chat/chat_message.dart';

class ChatScreen extends StatefulWidget {
  final title;
  const ChatScreen({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyChatScreenState();
  }
}

class _MyChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(9),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _textComposerWidget(),
          )
        ],
      ),
    );
  }

  void _handleSubmited(String text) {
    textEditingController.clear();
    ChatMessage chatMessage = ChatMessage(
      text: text,
    );
    setState(() {
      _messages.insert(0, chatMessage);
    });
  }

  Widget _textComposerWidget() {
    return IconTheme(
      data: IconThemeData(color: Colors.green),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                decoration: InputDecoration.collapsed(hintText: 'Send Message'),
                controller: textEditingController,
                onSubmitted: _handleSubmited,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _handleSubmited(textEditingController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
