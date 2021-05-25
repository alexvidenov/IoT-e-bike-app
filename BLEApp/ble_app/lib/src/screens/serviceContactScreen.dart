import 'package:ble_app/src/blocs/ServiceChatBloc.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

// FIXME: obviously this shit is highly unoptimized, fix later
class ServiceChatScreen extends StatefulWidget {
  final ServiceChatBloc _serviceChatBloc;

  const ServiceChatScreen(this._serviceChatBloc);

  @override
  _ServiceChatScreenState createState() => _ServiceChatScreenState();
}

class _ServiceChatScreenState extends State<ServiceChatScreen> {
  final _messagesController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget._serviceChatBloc.create();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Send us a message!',
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  //buildMessages(),
                  inputField(),
                ],
              )
            ],
          ),
        ),
      );

  Widget inputField() => Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      autofocus: true,
                      maxLines: 5,
                      controller: _messagesController,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Enter your message.',
                      ),
                    )),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send, size: 25),
                onPressed: () => sendMessage(_messagesController.value.text),
              ),
            ),
          ],
        ),
      ),
      width: double.infinity,
      height: 100.0);

  /*
  Widget buildMessages() => Flexible(
        child: StreamBuilder<List<MapEntry<String, String>>>(
          stream: widget._serviceChatBloc.stream,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              final messages = snapshot.data;
              return ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemBuilder: (context, index) => buildItem(
                  messages[index].key,
                  messages[index].value,
                ),
                itemCount: messages.length,
                reverse: true,
                controller: _scrollController,
              );
            } else {
              return Container();
            }
          },
        ),
      );

  */

  Widget buildItem(String from, String message) {
    if (from == widget._serviceChatBloc.curUserId) {
      return Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Bubble(
                  color: Colors.blueGrey,
                  elevation: 0,
                  padding: const BubbleEdges.all(10.0),
                  nip: BubbleNip.rightTop,
                  child: Text(message, style: TextStyle(color: Colors.white))),
              width: 200)
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Container(
                child: Bubble(
                    color: Colors.white24,
                    elevation: 0,
                    padding: const BubbleEdges.all(10.0),
                    nip: BubbleNip.leftTop,
                    child: Text(message,
                        style: TextStyle(color: Colors.lightGreen))),
                width: 200.0,
                margin: const EdgeInsets.only(left: 10.0),
              )
            ])
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  void sendMessage(String message) {
    if (message.trim() != '') {
      _messagesController.clear();
      message = message.trim();
      //  widget._serviceChatBloc.sendMessage(message);
      _scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
}
