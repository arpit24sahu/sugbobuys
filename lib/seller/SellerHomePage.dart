import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sugbo/HomePage.dart';
import 'package:sugbo/chat/chatbox.dart';
import 'package:sugbo/seller/AddItem.dart';
//import 'package:sugbo/browse/ItemInfo.dart';
import 'AddSeller.dart';
import 'package:sugbo/item/ItemInfo.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:admob_flutter/admob_flutter.dart';
import 'package:sugbo/data.dart';

class SellerHomePage extends StatefulWidget {
  final FirebaseUser user;

  const SellerHomePage({Key key, this.user}):super(key: key);
  @override
  _SellerHomePageState createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {



  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  String name;
  String city;
  String address;
  String age;
  String email;
  String password;
  String phone;
  String photourl;
  int _noOFMessages=0;
//  String photourl;

  @override
  void initState() {
    _noOFMessages = 0;

    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getData();
  }




  FirebaseUser user;
  String _uid = "Unknown id";
  String _uemail;
//  DocumentSnapshot ds;
  String data = "hello";
  Future<void> getData() async{
    FirebaseUser user = await _auth.currentUser();
    if(user!=null) {
      setState(() {
        _uid = user.uid;
//        _uemail = user.email;
      });
    }

//    print("uemail: $uemail");
    await Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .snapshots()
        .listen((data) async {
      DocumentSnapshot ds = data.documents.last;
      setState(() {

      });
      name = (ds['n']!=null)?ds['n']:null;
      city= (ds['city']!=null)?ds['city']:null;
      address = (ds['city']!=null)?ds['address']:null;
      age = (ds['age']!=null)?ds['age']:null;
      email = (ds['email']!=null)?ds['email']:null;//ds['email'];
      password = (ds['passw']!=null)?ds['passw']:null;
      phone = (ds['phone']!=null)?ds['phone']:null;
      photourl = (ds['photourl']!=null)?ds['photourl']:"https://i.imgur.com/G3j4Piv.jpg";
    });
    setState(() {

    });
  }

  getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    if(user!=null) {
      setState(() {
        _uid = user.uid;
      });
      _firestore.collection('user').where('uid', isEqualTo: _uid).snapshots().listen((event) {
        _uemail = event.documents.last.data['email'];
      });
    }
    print(_uid);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  int ind = 0;
  String sender;
  String senderUID;
  String sendername;

  @override
  Widget build(BuildContext context) {
    getData();
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage()
            )
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          actions: [
            Material(
              color: Colors.pinkAccent,
              child: IconButton(

                icon: Icon(Icons.home),
                iconSize: 30,
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage()
                      )
                  );
                },
              ),
            ),
            Material(
              child: MaterialButton(
                color: Colors.pinkAccent,
                child: Text("Sign Out", style: TextStyle(color: Colors.white),),
                onPressed: (){
                  _auth.signOut();
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
        ),

      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                  height: 60,
                  color: Colors.pink,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child:  Center(
                        child: Text("Messages", style: TextStyle(fontSize: 20, color: Colors.white),),
                      )
                  )
              ),
              Expanded(
                child: Stack(
                  children: [
                    Stack(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: _firestore.collection('chat').where('UIDs', arrayContains: _uid).snapshots(),
                            builder: (context,snapshot){

                              String sendercity;
                              int read;
                              int blocked;

                              if (!snapshot.hasData) return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.purple,
                                ),
                              );
                              if(snapshot.data.documents.length==0) return Center(
                                child: Container(
                                  height: 100,
                                  child: Center(child: Text("No messages yet"),),
                                ),
                              );

                              List<DocumentSnapshot> docs = snapshot.data.documents;
                              List<Widget> chats = docs
                                  .map((doc) => MessageBox(

                                email: (doc.data['emails'][0]==_uemail)?doc.data['emails'][1]:doc.data['emails'][0],//sendername,//doc.data['item'],
//                              name: sender,//doc.data['id'],
                                senderUID: (doc.data['UIDs'][0]==_uid)?doc.data['UIDs'][1]:doc.data['UIDs'][0],
                                uid: _uid,
                                lastMessage: "lastMessage",//doc.data['likes'],
                                unread: 1,//doc.data['views'],
                                index: 1,
                                me: _uemail,
                              )).toList();

                              return ListView(
//                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                                children: [
                                  ...chats,
                                ],
                              );
                            },
                          ),
                        ]
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black,
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: (photourl!=null)?NetworkImage(photourl):NetworkImage("https://i.pinimg.com/originals/76/47/9d/76479dd91dc55c2768ddccfc30a4fbf5.png"),//NetworkImage(photourl)//
                      )
                  ),
                  height: 100,
                  width: 100,
                ),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        shadowColor: Colors.deepPurpleAccent,
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            height: 100,
                            child: Padding(
                                padding: EdgeInsets.only(right: 10, left: 10),
                                child: ListView(
//                        mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(" "),
                                    Center(child: Text((name!=null)?name: "Name", textScaleFactor: 2,),),
                                    Center(child: Text((city!=null)?city: "City", textScaleFactor: 1.2,),),
                                  ],
                                )
                            )
                        ),
                      ),
                    )
                ),
              ],
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
//              color: Colors.grey,
                height: 150,
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(15),
                        shadowColor: Colors.deepPurpleAccent,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Stack(
                            children: [
                              ListView(
                                children: [
                                  Text("Details", textScaleFactor: 1.7,),
                                  Text(" "),
                                  Text("Address: ${(address!=null)?address:" "}", textScaleFactor: 1.2,),
                                  Text("Email: ${(email!=null)?email:" "}", textScaleFactor: 1.2,),
                                  Text("Age: ${(age!=null)?age:" "}", textScaleFactor: 1.2,),
                                  Text("Phone Number: ${(phone!=null)?phone:" "}", textScaleFactor: 1.2,),
                                ],
                              ),
                              Positioned(
                                  right: 10,
                                  top: 20,
                                  width: 70,
                                  child: InkWell(
                                      onTap: (){
                                        print("button pressed");
                                      },
                                      child: Material(
                                        borderRadius: BorderRadius.circular(10),
                                        elevation: 10,
                                        shadowColor: Colors.deepPurpleAccent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          height: 100,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Edit"),
                                              IconButton(
                                                  onPressed: (){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => AddSeller()
                                                        )
                                                    );
                                                  },
                                                  icon: Icon(Icons.add)
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  )
                              )
                            ],
                          ),
                        )
                    )
                )
            ),
            Expanded(
                child: Stack(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('item').where('uid', isEqualTo: _uid).snapshots(),
                      builder: (context,snapshot){
                        if (!snapshot.hasData) return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.purple,
                          ),
                        );
                        List<DocumentSnapshot> docs = snapshot.data.documents;
                        List<Widget> messages = docs
                            .map((doc) => SellerItemCard(
                          item: doc.data['item'],
                          id: doc.data['id'],
                          likes: doc.data['likes'],
                          views: doc.data['views'],
                          price: doc.data['price'],
                          seller: doc.data['seller'],
                          pic1: doc.data['pic1'],
                          pic2: doc.data['pic2'],
                          pic3: doc.data['pic3'],
                          pic4: doc.data['pic4'],
                          city: doc.data['city'],
                          email: doc.data['email'],
                          remarks: doc.data['remarks'],
                          timestamp: doc.data['timestamp'],
                        )).toList();

                        if(messages.length==0){
                          return Center(child: Text("No Items to show yet"));
                        }
                        return GridView(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                          children: [
                            ...messages,
                          ],
                        );

                      },
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Material(
                          elevation: 10,
                          shadowColor: Colors.deepPurpleAccent,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          child: MaterialButton(
                            onPressed: (){
                              if(email==null){
                                Flushbar(
                                  title: "Email missing",
                                  message: "Please add an Email in your account to continue",
                                )..show(context);
                              }
                              else{
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddItem()
                                    )
                                );
                              }
                            },
                            child: Text("Add new item"),
                          ),
                        )
                    )
                  ],
                )

            )
          ],
        ),
      ),
    );
  }
}

class MessageBox extends StatefulWidget {
//  String name;
  String uid, senderUID;
  String email, senderEmail;
  String me;
  String lastMessage;
  int unread;
  int index;
  MessageBox({this.uid, this.email, this.lastMessage, this.index, this.unread, this.me, this.senderUID, this.senderEmail});
  @override
  _MessageBoxState createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {

  final Firestore _firestore = Firestore.instance;

  String name=" ";
  String pic=" ";
  Future<void> getData()async{
    Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: widget.senderUID)
        .snapshots()
        .listen((data) {
      DocumentSnapshot ds = data.documents.last;
      name = ds['n'];
      pic = ds['photourl'];
    });
    setState(() {

    });
  }
  String _chatID = " ";


  Future<void> _getLastMessage()async{
    await Firestore.instance
        .collection('chat')
        .document(chatID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((event) {
      if(event.documents.last.data['text']!=null){
        setState(() {
          _lastMessage = event.documents.last.data['text'];
        });
      }
    });
  }
  String _lastMessage = " ";

//  AdmobInterstitial _interstitialAd;
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  String chatID=" ";
  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    chatID = (widget.uid.hashCode<widget.senderUID.hashCode)
        ?'${widget.uid}-${widget.senderUID}':'${widget.senderUID}-${widget.uid}';

    _getLastMessage();
    return ListTile(
      onTap: ()async{
//        if(await _interstitialAd.isLoaded){
//          _interstitialAd.show();
//        }
//        List<String> chatters = List();
//        List<String> chattersUID = List();
//        chatters.add(widget.email);
//        chatters.add(widget.senderEmail);
//        chattersUID.add(widget.uid);
//        chattersUID.add(widget.senderUID);
//        await
//        _firestore.collection('chat').document(chatID).updateData({
//          'UIDs': chattersUID,
//          'emails': chatters,
//          'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
//          'read': 0,
//          'blocked': 0,
//        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatBox(seller: widget.email, buyer: widget.me, chatID: chatID, sellerUID: widget.senderUID, buyerUID: widget.uid,)
          )
        );
      },
      leading: ClipRRect(

        borderRadius: BorderRadius.circular(20),
        child: Image.network(pic, height: 50, width: 50, fit: BoxFit.cover,),
      ),
      title: Text("${name}"),
      subtitle: (_lastMessage.length<20)?Text(_lastMessage):Text(_lastMessage.substring(0,20)+"..."),
      trailing: (widget.unread==1)?Icon(Icons.markunread, color: Colors.blue,):Icon(Icons.send),
    );
  }
}


class SellerItemCard extends StatefulWidget {
  String pic1;
  String pic2;
  String pic3;
  String pic4;
  int timestamp;
  String email, item, seller, city, price, remarks;
  int id, likes, views;
  SellerItemCard({
    this.timestamp,
    Key key, this.pic1, this.pic2, this.pic3, this.pic4,
    this.email, this.item, this.seller, this.city,
    this.id, this.likes, this.views, this.price, this.remarks
  });

  @override
  _SellerItemCardState createState() => _SellerItemCardState();
}

class _SellerItemCardState extends State<SellerItemCard> {
  Firestore _firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return InkWell(

      //long tap
      onLongPress: (){
        Alert(
            context: context,
            title: "Delete the item?",
            buttons: [
//            DialogButton(
//              child: Text("Edit"),
//              onPressed: (){
//
//              },
//            ),
              DialogButton(
                child: Text("Delete"),
                onPressed: ()async {
                  await Alert(
                      context: context,
                      title: "Are you sure you wanna delete?",
                      buttons: [
                        DialogButton(
                          child: Text("Yeah"),
                          onPressed: ()async {


                            print("started");
                            String _docID = "No doc ID";
                            try{
                              await _firestore.collection('item').
                              where('timestamp', isEqualTo: widget.timestamp)
                                  .snapshots()
                                  .listen((event) async {
                                print("${event.documents.last.documentID}");

                                FirebaseStorage _storageRef = FirebaseStorage.instance;
                                await _storageRef.getReferenceFromUrl(widget.pic1).then((value) => value.delete());
                                await _storageRef.getReferenceFromUrl(widget.pic2).then((value) => value.delete());
                                await _storageRef.getReferenceFromUrl(widget.pic3).then((value) => value.delete());
                                await _storageRef.getReferenceFromUrl(widget.pic4).then((value) => value.delete());
                                //delete function uncomment
                                await _firestore.collection('item').
                                document(event.documents.last.documentID).delete();
                              });
                            }catch(e){
                              print("error: ${e.toString()}");
                              Flushbar(
                                title: "Error",
                                message: "${e.toString()}"+"\nContact Admins",
                                duration: Duration(seconds: 5),
                              )..show(context);
                            }finally{
                              Alert(
                                context: context,
                                title: "Deleted Successfully",
                                buttons: [
                                  DialogButton(
                                    onPressed: ()async{
                                      FirebaseUser user = await _auth.currentUser();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SellerHomePage(user: user)
                                          )
                                      );
                                    },
                                    child: Text("Go to Home"),
                                  )
                                ]
                              )..show();
                            }
//                            await _firestore.collection('item').
//                            where('timestamp', isEqualTo: widget.timestamp)
//                                .snapshots()
//                                .listen((event) {
//                              print("${event.documents.last.documentID}");
//                            });


//                          .buildArguments().remove(key);
//                            Future.delayed(Duration(seconds: 3)).then((value)async{
//
//
//                            });


//                          await _firestore.collection('item').
//                          where('timestamp', isEqualTo: timestamp).
//                          snapshots().listen((event) {
//                            event.documents.remove(true);
//                          });
                            print("ended");
                          },
                        ),

                      ]
                  )..show();
//                Navigator.pop(context);
                },
              )
            ]
        )..show();
      },



      onTap: (){
        print("Tap");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemInfo(
                  item: widget.item,
                  id: widget.id,
                  likes: widget.likes,
                  views: widget.views,
                  price: widget.price,
                  seller: widget.seller,
                  pic1: widget.pic1,
                  pic2: widget.pic2,
                  pic3: widget.pic3,
                  pic4: widget.pic4,
                  city: widget.city,
                  email: widget.email,
                  remarks: widget.remarks,
                  timestamp: widget.timestamp,
                )
            )
        );
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) => ItemInfo(
//                  item: item,
//                  id: id,
//                  likes: likes,
//                  views: views,
//                  price: price,
//                  seller: seller,
//                  pic1: pic1,
//                  pic2: pic2,
//                  pic3: pic3,
//                  pic4: pic4,
//                  city: city,
//                  email: email,
//                  remarks: remarks,
//                )
//            )
//        );

      },
      child: Card(
          elevation: 12,
          shadowColor: Colors.deepPurpleAccent,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(1),
            child:  Image.network(widget.pic1),
          )
      ),
    );
  }
}
//
//
//class SellerItemCard extends StatelessWidget {
//  String pic1;
//  String pic2;
//  String pic3;
//  String pic4;
//  int timestamp;
//  String email, item, seller, city, price, remarks;
//  int id, likes, views;
//  SellerItemCard({
//    this.timestamp,
//    Key key, this.pic1, this.pic2, this.pic3, this.pic4,
//    this.email, this.item, this.seller, this.city,
//    this.id, this.likes, this.views, this.price, this.remarks
//  });
//
//  Firestore _firestore = Firestore.instance;
//
//  @override
//  Widget build(BuildContext context) {
//    return InkWell(
//
//      //long tap
//      onLongPress: (){
//        Alert(
//          context: context,
//          title: "Delete the item?",
//          buttons: [
////            DialogButton(
////              child: Text("Edit"),
////              onPressed: (){
////
////              },
////            ),
//            DialogButton(
//              child: Text("Delete"),
//              onPressed: ()async {
//                await Alert(
//                    context: context,
//                    title: "Are you sure you wanna delete?",
//                    buttons: [
//                      DialogButton(
//                        child: Text("Yeah"),
//                        onPressed: ()async {
//
//
//                          print("started");
//                          String _docID = "No doc ID";
//                          try{
//                            await _firestore.collection('item').
//                            where('timestamp', isEqualTo: timestamp)
//                                .snapshots()
//                                .listen((event) {
//                              print("${event.documents.last.documentID}");
//                              _docID = event.documents.last.documentID;
//                            });
//                          }catch(e){
//                            print("cannot find document ID: error: ${e.toString()}");
//                          }finally{
//
//                            print("Document ID got successfully: $_docID");
//                          }
//                          await _firestore.collection('item').
//                          where('timestamp', isEqualTo: timestamp)
//                          .snapshots()
//                          .listen((event) {
//                            print("${event.documents.last.documentID}");
//                          });
//
//
////                          .buildArguments().remove(key);
//                          Navigator.pop(context);
//
//
////                          await _firestore.collection('item').
////                          where('timestamp', isEqualTo: timestamp).
////                          snapshots().listen((event) {
////                            event.documents.remove(true);
////                          });
//                          print("ended");
//                        },
//                      ),
//
//                    ]
//                )..show();
////                Navigator.pop(context);
//              },
//            )
//          ]
//        )..show();
//      },
//
//
//
//      onTap: (){
//        print("Tap");
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) => ItemInfo(
//                  item: item,
//                  id: id,
//                  likes: likes,
//                  views: views,
//                  price: price,
//                  seller: seller,
//                  pic1: pic1,
//                  pic2: pic2,
//                  pic3: pic3,
//                  pic4: pic4,
//                  city: city,
//                  email: email,
//                  remarks: remarks,
//                  timestamp: timestamp,
//                )
//            )
//        );
////        Navigator.push(
////            context,
////            MaterialPageRoute(
////                builder: (context) => ItemInfo(
////                  item: item,
////                  id: id,
////                  likes: likes,
////                  views: views,
////                  price: price,
////                  seller: seller,
////                  pic1: pic1,
////                  pic2: pic2,
////                  pic3: pic3,
////                  pic4: pic4,
////                  city: city,
////                  email: email,
////                  remarks: remarks,
////                )
////            )
////        );
//
//      },
//      child: Card(
//        elevation: 12,
//        shadowColor: Colors.deepPurpleAccent,
//        color: Colors.white,
//          child: Padding(
//            padding: EdgeInsets.all(1),
//            child:  Image.network(pic1),
//          )
//      ),
//    );
//  }
//}

