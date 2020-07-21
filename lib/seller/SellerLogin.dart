import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sugbo/seller/RegisterSeller.dart';
import 'package:sugbo/seller/SellerHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SellerHomePage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SellerLogin extends StatefulWidget {
  @override
  _SellerLoginState createState() => _SellerLoginState();
}

class _SellerLoginState extends State<SellerLogin> {
  String _resetEmail = "noemail@noemail.com";
  TextEditingController _resetEmailText = TextEditingController();

  //--------------Facebook Login
  static final FacebookLogin _facebookSignIn = new FacebookLogin();


  FirebaseUser currentUser;
  final Firestore _firestore = Firestore.instance;


  Future<FirebaseUser> _loginByFacebook() async {
    _facebookSignIn.logOut();
    final FacebookLoginResult result =
        await _facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        _showMessage('''
        Logged in!
        
        Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
        ''');
        Flushbar(
          icon: CircularProgressIndicator(),
          title: "LogIn attempt Succesful",
          message: "Please wait while we take care of certain stuffs.",
          duration: Duration(seconds: 30),

        )..show(context);
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        Flushbar(
          icon: CircularProgressIndicator(),
          title: "Login cancelled by user.",
          message: "Please try again or use any other authentication method.",
          duration: Duration(seconds: 30),
        )..show(context);
        break;
      case FacebookLoginStatus.error:
        _showMessage('Login error: ${result.errorMessage}');
        Flushbar(
          icon: CircularProgressIndicator(),
          title: "An error encountered",
          //
          message: result.errorMessage,
          duration: Duration(seconds: 30),
        )..show(context);
        break;
    }

    if(result.status == FacebookLoginStatus.loggedIn) {
      FacebookAccessToken facebookAccessToken = result.accessToken;
      final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: facebookAccessToken.token);
      final _token = result.accessToken.token;
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&id');
      final _profile = json.decode(graphResponse.body);
      user = await _auth.signInWithCredential(credential);
      Flushbar(
        icon: CircularProgressIndicator(),
        title: "Signing In through Facebook",
        message: "Please wait while we take care of certain stuffs.",
        duration: Duration(seconds: 30),
      )..show(context);
//      assert(user.email != null);
      assert(user.displayName != null);
//      assert(user.phoneNumber != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      print("${user.email} ${user.displayName} ${user.isAnonymous}");
      currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      print("photoURL = ${user.photoUrl}");

      print("checking the document of ${user.email}");

      Flushbar(
        icon: CircularProgressIndicator(),
        title: "Creating User Profile",
        message: "Please wait while we take care of certain stuffs.",
        duration: Duration(seconds: 30),
      )..show(context);

      //
      var usersRef = _firestore.collection("user").document("${user.uid}");
      print("docs got ${user.email}");
      usersRef.get()
          .then((docSnapshot) async => {
      if (docSnapshot.exists) {
          await usersRef.updateData({
            'n': (user.displayName!=null)?user.displayName:"Name",
            'photourl': (user.photoUrl!=null)?user.photoUrl:"https://i.imgur.com/G3j4Piv.jpg",
            'uid': (user.uid!=null)?user.uid:"UID error",
          })
      } else {
          await usersRef.setData({
            'email':(user.email!=null)?user.email:null,
            'phone':(user.phoneNumber!=null)?user.phoneNumber:null,
            'n': (user.displayName!=null)?user.displayName:null,
            'photourl': (user.photoUrl!=null)?user.photoUrl:"https://i.imgur.com/G3j4Piv.jpg",
            'passw': "facebook",// "password",
            'age': null,//"Age Not set",
            'city': null,//"City not set",
            'address': null,// "Address not set",
            'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
            'uid': (user.uid!=null)?user.uid:"UID error",
//        convertback
//        DateTime.fromMillisecondsSinceEpoch(doc.data['timestamp'], isUtc: true),

          }) // create the document
    }
    });


      Flushbar(
        icon: CircularProgressIndicator(),
        title: "Taking you to your profile",
        message: "Hop In!!",
        duration: Duration(seconds: 30),
      )..show(context);


      if(user!=null&&user.uid!=null){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SellerHomePage(user: user)
            )
        );
      }
      else {
        Flushbar(
          icon: CircularProgressIndicator(),
          title: "Cannot sign you in",
          message: "UID not available, User invalid. Please contact the Admins at rptsahu1@gmail.com",
          duration: Duration(seconds: 30),
        )..show(context);
      }

      return currentUser;

    }
  }

  void _showMessage(String message) {
    print(message);
  }

  String email;
  String password;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;
  Future<void> loginUser() async {
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } catch (e) {
      print(e.toString().toUpperCase());
      String exception = e.toString();
      Flushbar(
        title: "Sign In Error",
        message: exception,
        duration: Duration(seconds: 5),
      )..show(context);

    } finally {
      if (user != null) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SellerHomePage(user: user)
        )
    );
        // sign in successful!
        // ex: bring the user to the home page
      } else {
        Flushbar(
          title: "Sign In Error",
          message: "Please Try again",
          duration: Duration(seconds: 5),
        )..show(context);
      }
    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: new AppBar(
          title: Text("Login"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: ()async{
                _facebookSignIn.logOut();
              },
            )
          ],
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
                        Colors.white
                      ]
                  )
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
//                color: Colors.yellow,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height/2.7,
                      alignment: Alignment.center,
                      child: Hero(
                        transitionOnUserGestures: true,
                        tag: "logo",
                        child: Container(
                          child: Center(child: Image.asset("assets/icon.png")),
                          height: 150,
                          width: 150,
                        ),
                      ),
                    ),
                    Center(child: Text(" ")),
                    Center(child: Text(" ")),
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      shadowColor: Colors.purpleAccent,
                      child: Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                  end: Alignment.centerLeft,
                                  begin: Alignment.centerRight,
                                  colors: [
                                    Colors.white,
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
                                  onChanged: (value) => email = value,
                                  decoration: InputDecoration(
                                    hintText: "Input Registered Email...",
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
                      shadowColor: Colors.purpleAccent,
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
                                    Colors.white,
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
                                  obscureText: true,
                                  obscuringCharacter: '*',
                                  onChanged: (value) => password = value,
                                  decoration: InputDecoration(
                                    hintText: "Input Password...",
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                    ),
                    Text(" "),
                    Text(" "),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                            elevation: 10,
                            shadowColor: Colors.purpleAccent,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            child: MaterialButton(
                              minWidth: 100,
                              child: Text("Reset Password"),
                              onPressed: () async {
                                Alert(
                                    context: context,
                                    image: Image.asset("assets/icon/icon.png", height: 50, width: 50,),
                                    title: "Reset Password",
                                    content: Column(
                                      children: <Widget>[
                                        TextField(
                                          controller: _resetEmailText,
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.account_circle),
                                            labelText: 'Registered Email',
                                          ),
                                        ),
                                      ],
                                    ),
                                    buttons: [
                                      DialogButton(
                                          onPressed: () async {
                                            if(_resetEmailText.text.length>0){
                                              _resetEmail = _resetEmailText.text;
                                              try{
                                                await _auth.sendPasswordResetEmail(email: _resetEmail);
                                              } catch (e){
                                                print(e.toString().toUpperCase());
                                                Alert(
                                                  context: context,
                                                  title: "Error",
                                                  desc: e.toString(),
                                                ).show();
                                              } finally{
                                                Alert(
                                                  context: context,
                                                  title: "Success",
                                                  desc: "Please follow the instructions sent to your Email to reset your password.",
                                                ).show();
                                              }
                                              _resetEmailText.clear();
                                            }
                                          },
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("Send Email",style: TextStyle(color: Colors.black, fontSize: 20),),
//                                          Text("(Standard charges may apply)",style: TextStyle(color: Colors.black, fontSize: 10),),
                                              ],
                                            ),
                                          )
                                      ),
                                    ]).show();
                              },
                            )
                        ),
                        Text(" "),
                        Material(
                            elevation: 10,
                            shadowColor: Colors.purpleAccent,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            child: MaterialButton(
                              minWidth: 150,
                              child: Text("Login"),
                              onPressed: () async {
                                await loginUser();
                              },
                            )
                        ),
                      ],
                    ),
                    Text(" "),
                    Material(

                        elevation: 10,
                        shadowColor: Colors.blue,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        child: MaterialButton(
                          minWidth: 150,
                          child: Text("Login using Facebook", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                            onPressed: (){
                              Flushbar(
                                icon: CircularProgressIndicator(),
                                title: "Signing you through Facebook",
                                message: "This might take a while.",
                                duration: Duration(seconds: 30),
                              )..show(context);

                            _loginByFacebook();

                            },

//                          onPressed: () {
//                            _loginByFacebook;
//                            print("FB Login Attempted");
//                          },
                        )
                    ),

                    Text(" "),
                    Material(
                        elevation: 10,
                        shadowColor: Colors.deepPurpleAccent,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        child: MaterialButton(
                          minWidth: 150,
                          child: Text("New User? Register here."),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterSeller()
                              )
                            );
                          },
                        )
                    ),

                    Text(" "),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}
