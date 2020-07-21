import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sugbo/item/imageShow.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sugbo/chat/chatbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sugbo/data.dart';


class ItemInfo extends StatefulWidget {
  final String pic1;
  final String pic2;
  final String pic3;
  final String pic4;
  final int timestamp;
  final String email, item, seller, city, price, remarks, uid;
  final int id, likes, views;
  final Color _bgColor = Color.fromRGBO(255,192,203, 1);
  ItemInfo({
    this.timestamp,
    Key key, this.pic1, this.pic2, this.pic3, this.pic4,
    this.email, this.item, this.seller, this.city,
    this.id, this.likes, this.views, this.price, this.remarks, this.uid,
  });
  @override
  _ItemInfoState createState() => _ItemInfoState();
}

class _ItemInfoState extends State<ItemInfo> {

  AdmobInterstitial interstitialAd;
  AdmobBanner admobBanner;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  FirebaseUser user;
  String _uid = "sampleUid";
  String _uemail;
  getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    if(user!=null) setState(() {
      _uid = user.uid;
      _firestore.collection('user').where('uid', isEqualTo: _uid).snapshots().listen((event) {
        _uemail = event.documents.last.data['email'];

      });


    });

  }

  @override
  void initState() {
    // TODO: implement initState
    Admob.initialize(Ads[3]);

    interstitialAd = AdmobInterstitial(
      adUnitId: Ads[8],
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();

      },
    );
    interstitialAd.load();
    getCurrentUser();
    super.initState();
  }

  @override
  void dispose() {

    interstitialAd.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Product", textScaleFactor: 1.2,),),
        elevation: 10,
//        shadowColor: Colors.pink,
        actions: [
          IconButton(
            onPressed: (){

            },
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 20, left: 5, right: 5),
            child: Container(
//              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Center(child: Text(widget.item, textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold),),),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
                height: MediaQuery.of(context).size.width,
//                  color: Colors.transparent,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: AssetImage("assets/loader.gif"),
                    )
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: PageView(
                    children: [
                      _SlidePicture(url: widget.pic1, name: widget.item, hero: widget.pic1,),
                      _SlidePicture(url: widget.pic2, name: widget.item, hero: widget.pic2,),
                      _SlidePicture(url: widget.pic3, name: widget.item, hero: widget.pic3,),
                      _SlidePicture(url: widget.pic4, name: widget.item, hero: widget.pic4,),
                    ],
                  ),
                )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("PHP. ${widget.price}", textScaleFactor: 2,),
              )
            ],
          ),
          Text(" "),
          Text(" "),
          Text(" "),
          Container(
            color: Color.fromRGBO(255,192,203, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(" "),
                Center(child: Text("Details", textScaleFactor: 2,),),
                Text(" "),
                _CustomText(text: "Name: ${widget.item}",),
                _CustomText(text: "Seller: ${widget.seller}",),
                _CustomText(text: "Email: ${widget.email}",),
                _CustomText(text: "City: ${widget.city}",),
//                _CustomText(text: "Posted on: ${widget.timestamp}",),
//                _CustomText(text: "Posted on: ${DateTime.fromMillisecondsSinceEpoch(widget.timestamp)}",),
                _CustomText(text: "Posted on: ${DateTime.fromMillisecondsSinceEpoch(widget.timestamp).day}-${DateTime.fromMillisecondsSinceEpoch(widget.timestamp).month.toString().padLeft(2,'0')}-${DateTime.fromMillisecondsSinceEpoch(widget.timestamp).year}",),
//        convertback
//        DateTime.fromMillisecondsSinceEpoch(doc.data['timestamp'], isUtc: true),






              ],


            ),
          ),
          Text(" "),
          Container(
            color: Color.fromRGBO(255,192,203, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(" "),
                Center(child: Text("Remarks", textScaleFactor: 2,),),
                Text(" "),
                _CustomText(text: "${widget.remarks}",),
                Text(" "),
                Text(" "),
                Text(" "),
                Text(" "),
                Text(" "),
                Text(" "),
              ],


            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(100),
                child: MaterialButton(
//                  height: 200,
                  onPressed: () async {
                    if(await interstitialAd.isLoaded){
                      interstitialAd.show();
                    }
//                    await getCurrentUser;
                    user = await _auth.currentUser();
                    if (user==null){
                      print("user==null");
                      Alert(
                          context: context,
                          title: "Login",
                          desc: "You need to Login first to use this feature"
                      ).show();
                    }
                    else if (widget.uid == _uid){
                      print("user == own");
                      Alert(
                          context: context,
                          title: "Umm...",
                          desc: "That's your item only, right?",
                          buttons: [
                            DialogButton(
                              child: Text("Yes ofcourse", style: TextStyle(color: Colors.white),),
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                            )
                          ]
                      ).show();

                    }
                    else if(_uemail==null){
                      Flushbar(
                        title: "Email missing",
                        message: "You need to add your email in your profile to use this feature",
                        duration: Duration(seconds: 15),
                      )..show(context);
                    }
                    else {
                      if (widget.uid.hashCode<_uid.hashCode){
                        String chatID = '${widget.uid}-$_uid';
                        List<String> chatters = List();
                        List<String> chattersUID = List();
                        chatters.add(widget.email);
                        chatters.add(_uemail);
                        chattersUID.add(widget.uid);
                        chattersUID.add(_uid);
                        await
                        _firestore.collection('chat').document(chatID).setData({
                          'UIDs': chattersUID,
                          'emails': chatters,
                          'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
                          'read': 0,
                          'blocked': 0,
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatBox(buyer: _uemail, seller: widget.email, chatID: chatID, buyerUID: _uid, sellerUID: widget.uid,)
                            )
                        );
                      }
                      else if (widget.uid.hashCode>_uid.hashCode){
                        String chatID = '$_uid-${widget.uid}';
                        List<String> chatters = List();
                        List<String> chattersUID = List();
                        chatters.add(widget.email);
                        chatters.add(_uemail);
                        chattersUID.add(widget.uid);
                        chattersUID.add(_uid);
                        await
                        _firestore.collection('chat').document(chatID).setData({
                          'UIDs': chattersUID,
                          'emails': chatters,
                          'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
                          'read': 0,
                          'blocked': 0,
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatBox(buyer: _uemail, seller: widget.email, chatID: chatID, buyerUID: _uid, sellerUID: widget.uid,)
                            )
                        );
                      }
                    }
                  },
//                  minWidth: 200,
                  child: Center(child: Text("Contact Seller", textScaleFactor: 1.2, style: TextStyle(fontWeight: FontWeight.bold, ),),),
                ),
              )
          )
      ),
    );
  }
}


class _CustomText extends StatelessWidget {
  final String text;
  const _CustomText({Key key, this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 1, bottom: 1, left: 5, right: 5),
              child: Text(text, style: TextStyle(color: Colors.black, fontSize: 15),),
            )
          ],
        )
      ),
    );
  }
}

class _SlidePicture extends StatelessWidget {
  final String url;
  final String name;
  final String hero;
  const _SlidePicture({Key key, this.url, this.name, this.hero});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageShow(name: name, hero: hero, pic: url,)
          )
        );
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.white,
        child: Stack(
          children: [
            Center(child: Image.asset("assets/loader.gif", scale: 1.5,),),
            Center(child: Image.network(url),)
          ],
        )
      ),
    );
  }
}
