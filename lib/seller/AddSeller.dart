import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';

class AddSeller extends StatefulWidget {
  final FirebaseUser user;
  const AddSeller({Key key, this.user}):super(key: key);

  @override
  _AddSellerState createState() => _AddSellerState();
}

class _AddSellerState extends State<AddSeller> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  TextEditingController addressC = TextEditingController();
  TextEditingController ageC = TextEditingController();
  TextEditingController cityC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController nC = TextEditingController();
  TextEditingController passwC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController photourlC = TextEditingController();


  Future<void> callback() async {
    if(
        addressC.text.length>0&&
        ageC.text.length>0&&
        cityC.text.length>0&&
        emailC.text.length>0&&
        nC.text.length>0&&
//        passwC.text.length>0&&
        phoneC.text.length>0&&
        photourlC.text.length>0
    ){
      print("All Data set");
      print("${emailC.text}");
      print("${ageC.text}");
      print("${phoneC.text}");
      print("${photourlC.text}");
      print("${nC.text}");
      print("${passwC.text}");
      print("${cityC.text}");
      print("${addressC.text}");



      await Firestore.instance
          .collection('user')
          .document("$uid")
          .updateData({
          'email': emailC.text,
          'passw': passwC.text,
          'n': nC.text,
          'age': ageC.text,
          'phone': phoneC.text,
          'photourl': photourlC.text,
          'city': cityC.text,
          'address': addressC.text,
        });

      Flushbar(

        title: "Details Updated",
        message: "Please Go to your profile and Verify",
      )..show(context);
      addressC.clear();
      phoneC.clear();

    }
    else{
      Flushbar(

        title: "Empty",
        message: "Something empty",
      )..show(context);
    }
  }

  FirebaseUser user;
  String uid = "sampleUid";
  String uemail;// = "sampleEmail";
  String ininame;//  = ds['n'];
  String inicity;//  = ds['city'];
  String iniaddress;//  = ds['address'];
  String iniage;// = ds['age'].toString();
  String inipassword;//  = ds['passw'];
  String iniphone;//  = ds['phone'];
  String iniphotourl;//
  String iniemail;// = ds['photourl'];

  getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    uid = user.uid;
    print(uid);
    if(user.email!=null){
      setState(() {
        emailC.text=user.email;
      });
    }
    await Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .listen((data) {
      DocumentSnapshot ds = data.documents.last;

      ininame = ds['n'];
      inicity = ds['city'];
      iniaddress = ds['address'];
      iniage = ds['age'];
      inipassword = ds['passw'];
      iniphone = ds['phone'];
      iniphotourl = ds['photourl'];
      iniemail = ds['email'];

      nC.text = ininame;
      cityC.text = inicity;
      addressC.text = iniaddress;
      ageC.text = iniage;
      passwC.text = inipassword;
      phoneC.text = iniphone;
      photourlC.text = iniphotourl;

      setState(() {

      });

    });

  }


  @override
  void initState() {
    getCurrentUser();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    print(emailC.text);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Edit Profile"),),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Fill the entire form to proceed"),
                  Text("You can add your email only once", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("You cannot edit the registered Email."),
                  Text("To change the registered Email,"),
                  Text("contact Admin."),
                ],
              ),
            ),

          ),
          Text(" "),
          TextField(
            enabled: (iniemail==null)?true:false,
            controller: emailC,
            decoration: InputDecoration(
              hintText: "Email: $iniemail",
              border: const OutlineInputBorder(),
            ),
          ),
          Text(" "),
          TextField(
            controller: nC,
            decoration: InputDecoration(
              hintText: "Name: $ininame",
              border: const OutlineInputBorder(),
            ),
          ),
          Text(" "),
          TextField(
            controller: ageC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Age: $iniage",
              border: const OutlineInputBorder(),
            ),
          ),
          Text(" "),
          TextField(
            controller: cityC,
            decoration: InputDecoration(
              hintText: "City: $inicity",
              border: const OutlineInputBorder(),
            ),
          ),
          Text(" "),
          TextField(
            controller: addressC,
            decoration: InputDecoration(
              hintText: "Address: $iniaddress",
              border: const OutlineInputBorder(),
            ),
          ),
          Text(" "),
          TextField(
            controller: phoneC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Phone: $iniphone",
              border: const OutlineInputBorder(),
            ),
          ),
          Text(" "),
          TextField(
            controller: photourlC,
            decoration: InputDecoration(
              hintText: "Photo: ${(iniphotourl!=null)?iniphotourl.substring(0,25):null}...",
              border: const OutlineInputBorder(),
            ),
          ),
          Text(" "),
          Text(" "),
          Container(
            width: 400,
            child: Material(
              elevation: 10,
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              child: MaterialButton(
                onPressed: (){
                  onPressed: callback();
                },
                child: Text("Submit", textScaleFactor: 1.3,),

              ),
            ),
          ),
          Text(" "),
          Text(" "),
          Text(" "),
        ],
      ),
    );
  }
}
