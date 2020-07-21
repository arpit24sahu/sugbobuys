import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:sugbo/data.dart';
import 'package:sugbo/seller/AddItem.dart';
import 'HomePage.dart';
import 'package:sugbo/ContactUs.dart';
import 'package:admob_flutter/admob_flutter.dart';

void main() {
  Admob.initialize(Ads[3]);

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


String facebook_app_id = "281765436491881";
String fb_login_protocol_scheme = "fb281765436491881";

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/HomePage": (context) => HomePage(),
        "/AddItem": (context) => AddItem(),
        "/ContactUs": (context) => ContactUs(),
//        "YourOrders": (context) =>
      },
      home: SplashScreen(
        seconds: 3,
        navigateAfterSeconds: HomePage(),
        image: Image.asset("assets/splash1.jpg"),
        photoSize: 150,
        loadingText: Text("Awesomeness Loading....", textScaleFactor: 1.3,),
        loaderColor: Colors.pinkAccent,
      ),
      theme: ThemeData(
        primaryColor: Colors.pinkAccent,
        splashColor: Colors.blue,
      ),
    );
  }
}
