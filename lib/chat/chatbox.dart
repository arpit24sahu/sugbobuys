import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sugbo/HomePage.dart';


class ChatBox extends StatefulWidget {
  String buyer;
  String seller;
  String buyerUID;
  String sellerUID;
  String chatID;
  FirebaseUser user;
  ChatBox({Key key, this.buyer, this.seller, this.chatID, this.user, this.buyerUID, this.sellerUID});

  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();


  Future<void> callback() async {
    if(messageController.text.length > 0){
      await
      _firestore.collection('chat').document(widget.chatID).collection('messages').add({
        'text': messageController.text,
        'from': widget.buyer,
        'to': widget.seller,
        'fromUID': widget.buyerUID,
        'toUID': widget.sellerUID,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
        'read': 0,
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 300),
      );
    }
  }

  Firestore _firestore2 = Firestore.instance;
  String _leftName = "Chat";
  Future<void> _getLeftdata()async{
    await _firestore2.collection('user')
        .document(widget.sellerUID)
        .snapshots()
        .listen((event) {
          print("data: ${event.data['n']}");
          setState(() {
            _leftName = event.data['n'];
          });
    });
  }




  @override
  void initState() {
    _getLeftdata();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          Material(
            color: Colors.pinkAccent,
            child: IconButton(
              icon: Icon(Icons.home),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage()
                  )
                );
              },
            ),
          )
        ],
        leading: Hero(
            tag: "logo",
            child: Container(
              height: 40.0,
              child: Image.asset("assets/icon.png"),
            )
        ),
        title: Text((_leftName.length>18)?_leftName.substring(0,18):_leftName, textScaleFactor: 0.9,),

      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('chat').document(widget.chatID).collection('messages').orderBy('timestamp').snapshots(),
                builder: (context,snapshot){
                  if (!snapshot.hasData) return Center(
                    child: CircularProgressIndicator(),
                  );

                  List<DocumentSnapshot> docs = snapshot.data.documents;
                  List<Widget> messages = docs
                      .map((doc) => Message(
                    from: doc.data['from'],
                    text: doc.data['text'],
                    me: widget.buyer == doc.data['from'],
                  )).toList();


                  return ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context,index){
                      return messages[index];
                    },
                  );
                },
              ),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Enter the message...",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: callback,
                  )
                ],
              ),

            )
          ],
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;
  final bool me;

  const Message({Key key, this.from, this.text, this.me});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2, bottom: 2, right: me?10:100, left: me?100:10),
          child: Material(
            color: me?Colors.teal:Colors.red,
            borderRadius: BorderRadius.circular(10),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                text,
              ),
            ),
          ),
        )
      ],
    );
  }
}


