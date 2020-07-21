import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:sugbo/item/ItemInfo.dart';
import 'package:sugbo/data.dart';

class ItemSearch extends StatefulWidget {
  @override
  _ItemSearchState createState() => _ItemSearchState();
}

class _ItemSearchState extends State<ItemSearch> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  String _searched = 'All';
  TextEditingController _searchC = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchC,
                          onChanged: (String query){
                            setState(() {
                              _searched = _searchC.text;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Search"
                          ),
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 1,
                        child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: (){
                            setState(() {
                              _searched = _searchC.text;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: (_searched=='All')?_firestore.collection('item').orderBy('timestamp', descending: true).snapshots():_firestore.collection('item').where('itemSearch', arrayContains: _searched.toLowerCase()).orderBy('timestamp', descending: true).snapshots(),
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
                      )).toList();

                      if(docs.length==0) return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("OOPS.."),
                          Text("No items to show yet"),
                        ],
                      );
                      return ListView(
//                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                        children: [
                          ...messages,
                        ],
                      );



//                    return ListView();
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

void setColor(int index){
  for(int i=0; i<categoryColor.length; i++){
    categoryColor[i] = Colors.white;
  }
  categoryColor[index] = Colors.purple;
}

class ItemCard extends StatelessWidget {

  String pic1;
  String pic2;
  String pic3;
  String pic4;
  String email, item, seller, city, price, remarks;
  String category, subcategory;
  int id, likes, views;
  ItemCard({
    Key key, this.pic1, this.pic2, this.pic3, this.pic4,
    this.email, this.item, this.seller, this.city,
    this.id, this.likes, this.views, this.price, this.remarks,
    this.category, this.subcategory,
  });


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


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: InkWell(
          splashColor: Colors.green,
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemInfo(
                      item: item,
                      id: id,
                      likes: likes,
                      views: views,
                      price: price,
                      seller: seller,
                      pic1: pic1,
                      pic2: pic2,
                      pic3: pic3,
                      pic4: pic4,
                      city: city,
                      email: email,
                      remarks: remarks,
                    )
                )
            );
          },
          child: SizedBox(
              height: 120,
              child: Card(
//              color: Colors.black12,

                elevation: 10,
                shadowColor: Colors.deepPurpleAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AspectRatio(
                        aspectRatio: 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent
                          ),
                          height: 100,
//                        color: Colors.grey,
                          child: InkWell(
                            splashColor: Colors.pink,
                            onTap: (){
                              print("Tap");
//                            _sendAnalyticsEvent("item_clicked", item, seller, email, id);
                            },
                            child: PageView(
                              children: [
                                Image.network(pic1, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress){
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: Image.asset("assets/loader.gif"),
                                  );
                                },
                                ),
                                Image.network(pic2, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress){
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: Image.asset("assets/loader.gif"),
                                  );
                                },
                                ),
                                Image.network(pic3, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress){
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: Image.asset("assets/loader.gif"),
                                  );
                                },
                                ),
                                Image.network(pic4, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress){
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: Image.asset("assets/loader.gif"),
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
                                              Text(item, textScaleFactor: 1.2,),
                                              Text(seller),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("P. $price", textScaleFactor: 1.1,),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(city),
                                )
                              ],
                            )
                        )
                    )
                  ],
                ),
              )
          ),
        )
    );
  }
}