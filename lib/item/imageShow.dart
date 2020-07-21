import 'package:flutter/material.dart';
//import 'package:admob_flutter/admob_flutter.dart';
//import 'package:indi/data.dart';

class ImageShow extends StatelessWidget {
  final String pic;
  final String name;
  final String hero;
  const ImageShow({Key key, this.pic, this.name, this.hero});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(name),
        centerTitle: true,
        elevation: 10,
//        shadowColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            child: Hero(
              tag: hero,
              child: Center(child: Image.network(pic),),
            )
          ),
        ],
      ),
    );
  }
}

