import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';

class ContactUs extends StatefulWidget {
  final FirebaseUser user;
  const ContactUs({Key key, this.user}):super(key: key);
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {


@override
  void initState() {
    // TODO: implement initState
  getCurrentUser();
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  TextEditingController _nameC = TextEditingController();
  TextEditingController _messageC = TextEditingController();
  TextEditingController _emailC = TextEditingController();


  FirebaseUser user;
  String uid = "sampleUid";
  String uemail = "Please Log In first";
  getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    if(user!=null) uid = user.uid;
    if(user!=null) uemail = user.email;
    print(uid);
    print(uemail);
    _emailC.text = uemail;
    setState(() {

    });
  }



  Future<void> _callback() async {
    if((uemail!="A")&&
      _messageC.text.length>0&&
      _nameC.text.length>0
    ){
      print("All Data set");

      await _firestore.collection("userReport").add({
        'email': _emailC.text,
        'naam': _nameC.text,
        'message': _messageC.text,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
        'uid': uid,
//        convertback
//        DateTime.fromMillisecondsSinceEpoch(doc.data['timestamp'], isUtc: true),
      });
      _nameC.clear();
      _messageC.clear();
      print("All Done ");
      Flushbar(
        title: "Submitted Successfully",
        message: "We''ll reach to you on your registered Email address shortly",
        duration: Duration(seconds: 7),
        borderRadius: 10,
        backgroundColor: Colors.deepPurpleAccent,
        dismissDirection: FlushbarDismissDirection.VERTICAL,
      )..show(context);
    }
    else {
      Flushbar(
        title: "Fill All Details",
        message: "The form seems to be incomplete",
        duration: Duration(seconds: 7),
        borderRadius: 10,
        backgroundColor: Colors.deepPurpleAccent,
        dismissDirection: FlushbarDismissDirection.VERTICAL,
      )..show(context);
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send a Message"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Name",
                border: OutlineInputBorder()
              ),
              controller: _nameC,
            ),
          ),
          Text(" "),
          Container(
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder()
              ),
              controller: _emailC,
            ),
          ),
          Text(" "),
          Container(
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Enter the message",
                  border: OutlineInputBorder()
              ),
              controller: _messageC,
            ),
          ),
          Text(" "),
          Center(
            child: RaisedButton(
              onPressed: (){
                _callback();
              },
              child: Text("Submit"),
            )
          )
        ],
      ),
    );
  }
}
