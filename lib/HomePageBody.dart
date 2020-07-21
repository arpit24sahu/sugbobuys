import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:sugbo/item/ItemInfo.dart';
import 'data.dart';

class HomePageBody extends StatefulWidget {
  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  String _selectedCategory = 'All';
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 120,
                child: ListView.builder(
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    return Container(
                      color: categoryColor[index],
                      child: InkWell(
                        onTap: (){
                          setColor(index);
                          setState(() {
                            _selectedCategory = categories[index];
                            _selectedCategoryIndex = index;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.deepPurpleAccent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Image.asset(categoryImage[index]),
                                      radius: 35,
                                    ),
                                  ),
                                  Text(categories[index]),
                                ],
                              )
                          ),
                        )
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (DragEndDetails details) {
                    print("velocity: "+details.velocity.toString());
                    print("v in px/s: "+details.velocity.pixelsPerSecond.dx.toString());
                    if(details.velocity.pixelsPerSecond.dx<=-500){
                      print("swipe left");
                      if(_selectedCategoryIndex+1<categories.length){
                        setState(() {
                          _selectedCategoryIndex = _selectedCategoryIndex+1;
                        });
                        setState(() {
                          _selectedCategory = categories[_selectedCategoryIndex];
                        });
                        setColor(_selectedCategoryIndex);
                      }
                    }
                    if(details.velocity.pixelsPerSecond.dx>=500){
                      print("swipe right");
                      if(_selectedCategoryIndex>0){
                        setState(() {
                          _selectedCategoryIndex = _selectedCategoryIndex-1;
                        });
                        setState(() {
                          _selectedCategory = categories[_selectedCategoryIndex];
                        });
                        setColor(_selectedCategoryIndex);
                      }
                    }
                  },
                  child: StreamBuilder<QuerySnapshot>(
                    stream: (_selectedCategory=='All')
                        ?_firestore.collection('item').orderBy('timestamp', descending: true).snapshots()
                        :_firestore.collection('item').where('subcategory', isEqualTo: _selectedCategory).orderBy('timestamp', descending: true).snapshots(),
//                  stream: _firestore.collection('item').snapshots(), //.where('subcategory', isEqualTo: _selectedCategory)
                    builder: (context, snapshot) {

                      if (!snapshot.hasData)
                        return Center(
                            child: Image.asset("assets/loader.gif")//CircularProgressIndicator(),
                        );

                      List<DocumentSnapshot> docs = snapshot.data.documents;
                      List<Widget> messages = docs
                          .map((doc) => ItemCard(
                        item: doc.data['item'],
                        id: doc.data['id'],
                        uid: doc.data['uid'],
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


                      if(docs.length==0) return GestureDetector(
                        onHorizontalDragEnd: (DragEndDetails details) {
                          print("velocity: "+details.velocity.toString());
                          print("v in px/s: "+details.velocity.pixelsPerSecond.dx.toString());
                          if(details.velocity.pixelsPerSecond.dx<=-500){
                            print("swipe left");
                            if(_selectedCategoryIndex+1<categories.length){
                              setState(() {
                                _selectedCategoryIndex = _selectedCategoryIndex+1;
                              });
                              setState(() {
                                _selectedCategory = categories[_selectedCategoryIndex];
                              });
                              setColor(_selectedCategoryIndex);
                            }
                          }
                          if(details.velocity.pixelsPerSecond.dx>=500){
                            print("swipe right");
                            if(_selectedCategoryIndex>0){
                              setState(() {
                                _selectedCategoryIndex = _selectedCategoryIndex-1;
                              });
                              setState(() {
                                _selectedCategory = categories[_selectedCategoryIndex];
                              });
                              setColor(_selectedCategoryIndex);

                            }
                          }
                        },
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("No items to show yet"),
                                  Text(" "),
                                  AdmobBanner(
                                    adUnitId: Ads[4],
                                    adSize: AdmobBannerSize.LARGE_BANNER,
                                  )..createState(),
                                  Text(" "),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onHorizontalDragEnd: (DragEndDetails details) {
                                print("velocity: "+details.velocity.toString());
                                print("v in px/s: "+details.velocity.pixelsPerSecond.dx.toString());
                                if(details.velocity.pixelsPerSecond.dx<=-500){
                                  print("swipe left");
                                  if(_selectedCategoryIndex+1<categories.length){
                                    setState(() {
                                      _selectedCategoryIndex = _selectedCategoryIndex+1;
                                    });
                                    setState(() {
                                      _selectedCategory = categories[_selectedCategoryIndex];
                                    });
                                    setColor(_selectedCategoryIndex);
                                  }
                                }
                                if(details.velocity.pixelsPerSecond.dx>=500){
                                  print("swipe right");
                                  if(_selectedCategoryIndex>0){
                                    setState(() {
                                      _selectedCategoryIndex = _selectedCategoryIndex-1;
                                    });
                                    setState(() {
                                      _selectedCategory = categories[_selectedCategoryIndex];
                                    });
                                    setColor(_selectedCategoryIndex);
                                  }
                                }
                              },
                            )
                          ],
                        )
                      );
                      return ListView(
//                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                        children: [
                          ...messages,
                        ],
                      );

                    },
                  ),
                )
              ),
            ],
          ),
        ),

      ],
    );
  }
}

void setColor(int index){
  for(int i=0; i<categoryColor.length; i++){
    categoryColor[i] = Colors.white;
  }
  categoryColor[index] = Colors.purple;
}

class ItemCard extends StatefulWidget {
  String pic1;
  String pic2;
  String pic3;
  String pic4;
  String email, item, seller, city, price, remarks, uid;
  String category, subcategory;
  int timestamp;
  int id, likes, views;
  ItemCard({
    this.timestamp,
    Key key, this.pic1, this.pic2, this.pic3, this.pic4,
    this.email, this.item, this.seller, this.city,
    this.id, this.likes, this.views, this.price, this.remarks,
    this.category, this.subcategory, this.uid,
  });

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);


  Future<void> _sendAnalyticsEvent(String event, String name, String seller, String email, int id) async {
    await analytics.logEvent(
      name: event,
      parameters: <String, dynamic>{
        'item': name,
        'seller': seller,
        'email': email,
        'item_id': id,
        'bool': true,
      },
    );
    print("Event logged");
  }

  int random = Random().nextInt(10);

  double adSize = 100;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.all(5),
            child: InkWell(
                splashColor: Colors.green,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItemInfo(
                            timestamp: widget.timestamp,
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
                            uid: widget.uid,
                          )
                      )
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 120,
                        child: Card(
                          elevation: 10,
                          shadowColor: Colors.deepPurpleAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AspectRatio(
                                  aspectRatio: 1.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    height: 100,
                                    child: InkWell(
                                      splashColor: Colors.pink,
                                      onTap: (){
                                        print("Tap");
                                      },
                                      child: PageView(
                                        children: [
                                          Image.network(widget.pic1, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress){
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: Image.asset("assets/loader.gif", fit: BoxFit.cover,),
                                            );
                                          },
                                          ),
                                          Image.network(widget.pic2, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress){
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: Image.asset("assets/loader.gif", fit: BoxFit.cover,),
                                            );
                                          },
                                          ),
                                          Image.network(widget.pic3, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress){
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: Image.asset("assets/loader.gif", fit: BoxFit.cover,),
                                            );
                                          },
                                          ),
                                          Image.network(widget.pic4, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress){
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: Image.asset("assets/loader.gif", fit: BoxFit.cover,),
                                            );
                                          },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
                                      child: Stack(
                                        children: [
                                          Container(
                                              width: double.maxFinite,
//                                  color: Colors.black12,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(widget.item, textScaleFactor: 1.2,),
                                                        Text(widget.seller),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("P. ${widget.price}", textScaleFactor: 1.1,),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(widget.city),
                                          )
                                        ],
                                      )
                                  )
                              )
                            ],
                          ),
                        )
                    ),
                  ],
                )
            )
        ),
        (random==2)?AdmobBanner(
          adUnitId: Ads[4+Random().nextInt(4)],
          adSize: AdmobBannerSize.LARGE_BANNER,
        ):Container()
      ],
    );
  }
}













//
//
//
//class ItemCard extends StatelessWidget {
//
//  String pic1;
//  String pic2;
//  String pic3;
//  String pic4;
//  String email, item, seller, city, price, remarks;
//  String category, subcategory;
//  int id, likes, views;
//  ItemCard({
//    Key key, this.pic1, this.pic2, this.pic3, this.pic4,
//    this.email, this.item, this.seller, this.city,
//    this.id, this.likes, this.views, this.price, this.remarks,
//    this.category, this.subcategory,
//  });
//
//
//  static FirebaseAnalytics analytics = FirebaseAnalytics();
//  static FirebaseAnalyticsObserver observer =
//  FirebaseAnalyticsObserver(analytics: analytics);
//
//
//  Future<void> _sendAnalyticsEvent(String event, String name, String seller, String email, int id) async {
//    await analytics.logEvent(
//      name: event,
//      parameters: <String, dynamic>{
//        'item': name,
//        'seller': seller,
//        'email': email,
//        'item_id': id,
//        'bool': true,
//      },
//    );
//    print("Event logged");
//  }
//
//  int random = Random().nextInt(10);
//
//  double adSize = 10;
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.start,
//      children: [
//        Padding(
//            padding: EdgeInsets.all(5),
//            child: InkWell(
//                splashColor: Colors.green,
//                onTap: (){
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => ItemInfo(
//                            item: item,
//                            id: id,
//                            likes: likes,
//                            views: views,
//                            price: price,
//                            seller: seller,
//                            pic1: pic1,
//                            pic2: pic2,
//                            pic3: pic3,
//                            pic4: pic4,
//                            city: city,
//                            email: email,
//                            remarks: remarks,
//                          )
//                      )
//                  );
//                },
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: [
//                    SizedBox(
//                        height: 120,
//                        child: Card(
////              color: Colors.black12,
//
//                          elevation: 10,
//                          shadowColor: Colors.deepPurpleAccent,
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            children: [
//                              AspectRatio(
//                                  aspectRatio: 1.0,
//                                  child: Container(
//                                    decoration: BoxDecoration(
//                                        color: Colors.white
//                                    ),
//                                    height: 100,
////                        color: Colors.grey,
//                                    child: InkWell(
//                                      splashColor: Colors.pink,
//                                      onTap: (){
//                                        print("Tap");
////                            _sendAnalyticsEvent("item_clicked", item, seller, email, id);
//                                      },
//                                      child: PageView(
//                                        children: [
//                                          Image.network(pic1, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress){
//                                            if (loadingProgress == null) return child;
//                                            return Center(
//                                              child: Image.asset("assets/loader.gif", fit: BoxFit.cover,),
//                                            );
//                                          },
//                                          ),
//                                          Image.network(pic2, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress){
//                                            if (loadingProgress == null) return child;
//                                            return Center(
//                                              child: Image.asset("assets/loader.gif", fit: BoxFit.cover,),
//                                            );
//                                          },
//                                          ),
//                                          Image.network(pic3, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress){
//                                            if (loadingProgress == null) return child;
//                                            return Center(
//                                              child: Image.asset("assets/loader.gif", fit: BoxFit.cover,),
//                                            );
//                                          },
//                                          ),
//                                          Image.network(pic4, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress){
//                                            if (loadingProgress == null) return child;
//                                            return Center(
//                                              child: Image.asset("assets/loader.gif", fit: BoxFit.cover,),
//                                            );
//                                          },
//                                          ),
//                                        ],
//                                      ),
//                                    ),
//                                  )
//                              ),
//                              Expanded(
//                                  flex: 1,
//                                  child: Padding(
//                                      padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
//                                      child: Stack(
//                                        children: [
//                                          Container(
//                                              width: double.maxFinite,
////                                  color: Colors.black12,
//                                              child: Column(
//                                                crossAxisAlignment: CrossAxisAlignment.start,
//                                                children: [
//                                                  Expanded(
//                                                    child: Column(
//                                                      crossAxisAlignment: CrossAxisAlignment.start,
//                                                      children: [
//                                                        Text(item, textScaleFactor: 1.2,),
//                                                        Text(seller),
//                                                      ],
//                                                    ),
//                                                  ),
//                                                  Container(
//                                                    child: Column(
//                                                      mainAxisAlignment: MainAxisAlignment.end,
//                                                      crossAxisAlignment: CrossAxisAlignment.start,
//                                                      children: [
//                                                        Text("P. $price", textScaleFactor: 1.1,),
//                                                      ],
//                                                    ),
//                                                  )
//                                                ],
//                                              )
//                                          ),
//                                          Align(
//                                            alignment: Alignment.bottomRight,
//                                            child: Text(city),
//                                          )
//                                        ],
//                                      )
//                                  )
//                              )
//                            ],
//                          ),
//                        )
//                    ),
//                  ],
//                )
//            )
//        ),
//        (true)?Container(
//          height: adSize,
//            child: AdmobBanner(
//              adUnitId: Ads[0],
//              adSize: AdmobBannerSize.LARGE_BANNER,
//              listener: (events, map){
//                if(events==AdmobAdEvent.loaded){
//                  adSize = 200;
//                }
//                else if(events==AdmobAdEvent.failedToLoad){
//                  adSize = 10;
//                }
//              }
//            )
//        ):Container()
//      ],
//    );
//  }
//}