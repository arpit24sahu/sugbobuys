import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sugbo/HomePage.dart';
import 'package:sugbo/chat/chatbox.dart';
import 'package:sugbo/seller/AddItem.dart';
import 'AddSeller.dart';
import 'package:sugbo/item/ItemInfo.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SellerProfile extends StatefulWidget {
  final FirebaseUser user;
  const SellerProfile({Key key, this.user}):super(key: key);
  @override
  _SellerProfileState createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {

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
  String _uemail = "Unknown User";
//  DocumentSnapshot ds;
  String data = "hello";
  Future<void> getData() async{
    FirebaseUser user = await _auth.currentUser();
    if(user!=null) {
      setState(() {
        _uid = user.uid;
        _uemail = user.email;
      });
    }

//    print("uemail: $uemail");
    await Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: user.uid)
        .snapshots()
        .listen((data) async {
//        data.documents.last;
//        print(data.documents.last['email']);
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
        _uemail = user.email;
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

                  ],
                )

            )
          ],
        ),
      ),
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