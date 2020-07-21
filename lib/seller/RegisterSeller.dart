import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:sugbo/Developer/AddBuyer.dart';
import 'package:sugbo/seller/SellerHomePage.dart';
import 'package:flushbar/flushbar.dart';

class RegisterSeller extends StatefulWidget {
  @override
  _RegisterSellerState createState() => _RegisterSellerState();
}

class _RegisterSellerState extends State<RegisterSeller> {
  String _email;
  String _password;
  String _name;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  int userIsThere = 0;

  FirebaseUser user;
  Future<void> _registerUser() async {
    FirebaseUser user;
    try{
      user = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      userIsThere=1;
    } catch(e) {
      userIsThere = 0;
      print(e.toString());
      Flushbar(
        title: "Sign In Error",
        message: e.toString(),
        duration: Duration(seconds: 10),
      )..show(context);
    } finally {
      if(userIsThere==1){
        Flushbar(
          title: "Registration Successful",
          message: "Verification Email sent to the Email address",
          duration: Duration(seconds: 7),
        )
          ..show(context);
        try {
          await user.sendEmailVerification();
          print(user.uid.toString());
          return user.uid;
        } catch (e) {
          print("$userIsThere");
          userIsThere=0;
          print(e.toString());
          Flushbar(
            title: "Sign In Error",
            message: e.toString(),
            duration: Duration(seconds: 5),
          )
            ..show(context);
        } finally {
          Flushbar(
            title: "Verification Email sent",
            message: "Please follow the instructions sent to your Email to verify your account.",
            duration: Duration(seconds: 7),
          )
            ..show(context);
          await _firestore.collection("user").document(user.uid).setData({
            'uid': user.uid,
            'email': _email,
            'passw': _password,
            'n': _name,
            'age': "Age",
            'phone': "Phone number",
            'photourl': "https://i.imgur.com/G3j4Piv.jpg",
            'city': "City",
            'address': "Address",
            'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
//        convertback
//        DateTime.fromMillisecondsSinceEpoch(doc.data['timestamp'], isUtc: true),
          },
          );
          userIsThere=0;
        }
      }
    }

  }
  Future<void> _loginUser() async {
    print("Flag1");
    FirebaseUser user;
    try{
      print("Flag2");
      user = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      print("Flag3");
    } catch(e){
      Flushbar(
        title: "Login Error",
        message: e.toString(),
        duration: Duration(seconds: 7),
      )
        ..show(context);
    } finally{

      print("Flag4");
      if(user.isEmailVerified==true){

        print("Flag5");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SellerHomePage(user: user)
            )
        );

        print("Flag6");
      }
      else{

        print("Flag7");
        Flushbar(
          title: "Email not verified",
          message: "Please complete email verification first",
          duration: Duration(seconds: 7),
        )
          ..show(context);
      }
    }
    print("process finsihed");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text("Register Seller"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colors.white,
                        Colors.white,
                      ]
                  )
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Hero(
                    tag: "logo",
                    child: Container(
                      child: Image.asset("assets/icon.png"),
                      height: 150,
                      width: 150,
                    ),
                  ),
                ),
                Center(child: Text(" ")),
                Material(
                  elevation: 10,
                  shadowColor: Colors.deepPurpleAccent,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              end: Alignment.centerLeft,
                              begin: Alignment.centerRight,
                              colors: [
                                Colors.grey,
                                Colors.white,
                              ]
                          )
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 45,
                            width: 250,
                            child: TextField(
                              onChanged: (value) => _name = value,
                              decoration: InputDecoration(
                                hintText: "Name...",
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                ),
                Text(" "),
                Material(
                  elevation: 10,
                  shadowColor: Colors.deepPurpleAccent,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              end: Alignment.centerLeft,
                              begin: Alignment.centerRight,
                              colors: [
                                Colors.grey,
                                Colors.white,
                              ]
                          )
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 45,
                            width: 250,
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) => _email = value,
                              decoration: InputDecoration(
                                hintText: "Input Your Email...",
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                ),
                Text(" "),
                Material(
                  elevation: 10,
                  shadowColor: Colors.deepPurpleAccent,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              end: Alignment.centerLeft,
                              begin: Alignment.centerRight,
                              colors: [
                                Colors.grey,
                                Colors.white,
                              ]
                          )
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 45,
                            width: 250,
                            child: TextField(
                              onChanged: (value) => _password = value,
                              decoration: InputDecoration(
                                hintText: "Input Password...",
//                      border: OutlineInputBorder(),
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                ),
                Text(" "),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Material(
                        elevation: 10,
                        shadowColor: Colors.deepPurpleAccent,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        child: MaterialButton(
                          minWidth: 150,
                          child: Text("Log In"),
                          onPressed: () async {
                            print("now awaiting login");
                            await _loginUser();
                          },
                        )
                    ),
                    Material(
                        elevation: 10,
                        shadowColor: Colors.deepPurpleAccent,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        child: MaterialButton(
                          minWidth: 150,
                          child: Text("Register"),
                          onPressed: () async {
                            await _registerUser();
                          },
                        )
                    ),
                  ],

                ),
                Text(" "),
              ],
            ),
          ],
        )
    );
  }
}
