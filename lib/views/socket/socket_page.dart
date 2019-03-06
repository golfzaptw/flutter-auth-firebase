// import package
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
// import file

class SocketPage extends StatefulWidget {
  final title;

  const SocketPage({Key key, this.title}) : super(key: key);
  @override
  _MySocketPageState createState() => _MySocketPageState();
}

class _MySocketPageState extends State<SocketPage> {
  WebSocketChannel channel;
  TextEditingController textEditingController;
  final List<String> list = [];
  GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
    textEditingController = TextEditingController();
    channel.stream.listen((data) => setState(() => list.add(data)));
  }

  void sendData() {
    if (textEditingController.text.isNotEmpty) {
      channel.sink.add(textEditingController.text);
      textEditingController.clear();
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Example'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _key,
              child: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                  labelText: "Send to WebSocket",
                ),
              ),
            ),
            Container(
              child: list.length == 0
                  ? Center(
                      child: Text('No data'),
                    )
                  : Column(children: list.map((data) => Text(data)).toList()),
            )

            /* show once message last 
            StreamBuilder(
              stream: channel.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Container(
                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              },
            ),
            */
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () {
          sendData();
        },
      ),
    );
  }
}
