import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sugbo/item/itemSearch.dart';
import 'package:sugbo/seller/AddItem.dart';
import 'package:sugbo/seller/SellerHomePage.dart';
import 'package:sugbo/seller/SellerLogin.dart';
import 'HomePageBody.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flushbar/flushbar.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;
  const HomePage({Key key, this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _uid;
  String _uemail;
  String _uname = "Please Login";
  Future<void> getData() async{
    FirebaseUser user = await _auth.currentUser();
    if (user!= null) {
      _uid = user.uid;
      _uemail = user.email;
    }

    if(user!=null){
      await Firestore.instance
          .collection('user')
          .where('uid', isEqualTo: _uid)
          .snapshots()
          .listen((data) {
        DocumentSnapshot ds = data.documents.last;
        _uname = ds['n'];
        _uemail = ds['email'];
      });
    }
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Sugbo Buys", style: TextStyle(color: Colors.white),),
//        shadowColor: Colors.pinkAccent,
//        centerTitle: false,
        backgroundColor: Colors.pinkAccent,
        actions: [
          AspectRatio(
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemSearch()
                  )
                );
              },
            ),
            aspectRatio: 1,
          ),
        ],
      ),
      drawer: Drawer(
        elevation: 10,
        child: ListView(
          children: [
            Container(
              color: Colors.pinkAccent,
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(1),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        child: Icon(Icons.account_circle, size: 30, color: Colors.white,),
                      ),
                    )
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.all(1),
                      child: Container(
                        child: Text("Hello, "+_uname, textScaleFactor: 1.2, style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    onTap: () async {

                      if (await FirebaseAuth.instance.currentUser() != null) {
                      // signed in
                        FirebaseUser user = await _auth.currentUser();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SellerHomePage(user: user)
                            )
                        );
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SellerLogin()
                            )
                        );
                      }
                    },
                  )
                ],
                )
              ),

            DrawerTile(title: "Home", pushName: "/HomePage",),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              title: Text("Profile", style: TextStyle(color: Colors.pink), textScaleFactor: 1.2,),
              onTap: () async {
                if (await FirebaseAuth.instance.currentUser() != null) {
                  // signed in
                  FirebaseUser user = await _auth.currentUser();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellerHomePage(user: user)
                      )
                  );
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellerLogin()
                      )
                  );
                }
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              title: Text("Add Items", style: TextStyle(color: Colors.pink), textScaleFactor: 1.2,),
              onTap: () async {
                if (await FirebaseAuth.instance.currentUser() != null) {
                  // signed in
                  FirebaseUser user = await _auth.currentUser();
                  if(_uemail==null){
                    Flushbar(
                      title: "Email missing",
                      message: "Please add an Email in your account to continue",
                    )..show(context);
                  }
                  else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddItem(user: user)
                        )
                    );
                  }

                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellerLogin()
                      )
                  );
                }
              },
            ),
            DrawerTile(title: "Contact Us", pushName: "/ContactUs",),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              title: Text("Terms and Conditions", style: TextStyle(color: Colors.pink), textScaleFactor: 1.2,),
              onTap: () async {
                const _tnc = "https://sites.google.com/view/sugbobuys-tnc/home";
                if(await canLaunch(_tnc)){
                  await launch(
                      _tnc,
                      forceWebView: false
                  );
                }
                else {
                  throw 'Could not launch $_tnc';
                }

              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              title: Text("Privacy Policy", style: TextStyle(color: Colors.pink), textScaleFactor: 1.2,),
              onTap: () async {
                const _prvcy = "https://sites.google.com/view/sugbobuys-privacy/home";
                if(await canLaunch(_prvcy)){
                  await launch(
                      _prvcy,
                      forceWebView: false
                  );
                }
                else {
                  throw 'Could not launch $_prvcy';
                }
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              title: Text("Sign out", style: TextStyle(color: Colors.pink), textScaleFactor: 1.2,),
              onTap: () async{
                await _auth.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage()
                    )
                );
              },
            ),
          ],
        ),
      ),
      body: HomePageBody(),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String title;
  final String pushName;
  const DrawerTile({Key key, this.title, this.pushName});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 30),
      title: Text(title, style: TextStyle(color: Colors.pink), textScaleFactor: 1.2,),
      onTap: (){
        Navigator.pushNamed(context, pushName);
      },
    );
  }
}
