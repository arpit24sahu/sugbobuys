import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'dart:async';
import 'package:popup_box/popup_box.dart';

class AddItem extends StatefulWidget {
  final FirebaseUser user;
  const AddItem({Key key, this.user}):super(key: key);
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {

  File _image1;
  File _image2;
  File _image3;
  File _image4;
  String _uploadedFileURL = " ";
  Future chooseFile(File chosen) async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        chosen = image;
      });
    });
  }

  Future uploadFile(File upload) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats/${Path.basename(upload.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(upload);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  bool _uploading = false;
  bool _uploading1 = false;
  bool _uploading2 = false;
  bool _uploading3 = false;
  bool _uploading4 = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  TextEditingController itemC = TextEditingController();
  TextEditingController idC = TextEditingController();
  TextEditingController pic1C = TextEditingController();
  TextEditingController pic2C = TextEditingController();
  TextEditingController pic3C = TextEditingController();
  TextEditingController pic4C = TextEditingController();
  TextEditingController likesC = TextEditingController();
  TextEditingController viewsC = TextEditingController();
  TextEditingController sellerC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController cityC = TextEditingController();
  TextEditingController priceC = TextEditingController();
  TextEditingController remarksC = TextEditingController();
  String category;
  String subcategory;


  Future<void> _callback() async {
    if(itemC.text.length>0&&
//        idC.text.length>0&&
        pic1C.text.length>0&&
        pic2C.text.length>0&&
        pic3C.text.length>0&&
        pic4C.text.length>0&&
//        likesC.text.length>0&&
//        viewsC.text.length>0&&
        sellerC.text.length>0&&
//        emailC.text.length>0&&
        cityC.text.length>0&&
        priceC.text.length>0&&
        remarksC.text.length>0
    ){
      print("All Data set");

      Flushbar(
        title: "All Right",
        message: "Uploading the details. Please Wait.",
        duration: Duration(seconds: 10),
        borderRadius: 10,
        backgroundColor: Colors.deepPurpleAccent,
        dismissDirection: FlushbarDismissDirection.VERTICAL,
      )..show(context);

      await _firestore.collection("item").add({
        'uid': uid,
        'item': itemC.text,
        "itemSearch": setSearchParam(itemC.text.toLowerCase()),
        'id': 1000,//1000+int.parse(idC.text),
        'pic1': pic1C.text,
        'pic2': pic2C.text,
        'pic3': pic3C.text,
        'pic4': pic4C.text,
        'likes': 0,//int.parse(likesC.text),
        'views': 0,//int.parse(viewsC.text),
        'seller': sellerC.text,
        'email': uemail,//emailC.text,
        'city': cityC.text,
        'remarks': remarksC.text,
        'price': (priceC.text),
        'category': category,
        'subcategory': subcategory,
        'isPosted': 1,
        'isavailable': 1,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
//        convertback
//        DateTime.fromMillisecondsSinceEpoch(doc.data['timestamp'], isUtc: true),
      });
      cityC.clear();
      remarksC.clear();
      priceC.clear();
      itemC.clear();
      pic1C.clear();
      pic2C.clear();
      pic3C.clear();
      pic4C.clear();
//      sellerC.clear();


      print("All Done ");
      Flushbar(
        title: "Details Submitted",
        message: "Please check Home Page to confirm",
        duration: Duration(seconds: 7),
        borderRadius: 10,
        backgroundColor: Colors.deepPurpleAccent,
        dismissDirection: FlushbarDismissDirection.VERTICAL,
      )..show(context);
    }
    else {
      Flushbar(
        title: "Fill All Details",
        message: "The form seems to be incomplete",
        duration: Duration(seconds: 7),
        borderRadius: 10,
        backgroundColor: Colors.deepPurpleAccent,
        dismissDirection: FlushbarDismissDirection.VERTICAL,
      )..show(context);
    }
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  FirebaseUser user;
  String uid = "sampleUid";
  String uemail = "sampleEmail";
  String userName = "User Name";
  TextEditingController _userNameC = TextEditingController();

  getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    uid = user.uid;
    uemail = user.email;

    await Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .listen((data) {
      DocumentSnapshot ds = data.documents.last;
      _userNameC.text = ds['n'];
      sellerC.text = ds['n'];
      userName = ds['n'];
      emailC.text = ds['email'];
      setState(() {

      });
    });

    print(uid);
    print(uemail);
    print(_userNameC.text);
//    emailC.text = uemail;
    sellerC.text = _userNameC.text;
  }

  String _loaderurl = "https://wpamelia.com/wp-content/uploads/2018/11/ezgif-2-6d0b072c3d3f.gif";
  String _arrowurl = "https://i.imgur.com/EPupHzs.png";

  @override
  void initState() {
    getCurrentUser();
    pic1C.text = _loaderurl;
    pic2C.text = _loaderurl;
    pic3C.text = _loaderurl;
    pic4C.text = _loaderurl;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Item"),
      ),
      body: ListView(
        children: [
          Container(
            height: 100,
            color: Colors.pinkAccent,
          ),
          Text(" "),
          TextField(
            controller: itemC,
            decoration: InputDecoration(
              hintText: "Enter Item Name...",
              border: const OutlineInputBorder(),
            ),
          ),
          Text(" "),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton(
                value: category,
                onChanged: (value){
                  setState(() {
                    category = value;
                  });
                },
                hint: Text("Category"),
                items: [
                  DropdownMenuItem(
                    child: Text("Men"),
                    value: "Men",
                  ),
                  DropdownMenuItem(
                    child: Text("Women"),
                    value: "Women",
                  ),
                  DropdownMenuItem(
                    child: Text("Unisex"),
                    value: "Unisex",
                  ),
                  DropdownMenuItem(
                    child: Text("Kids"),
                    value: "Kids",
                  ),
                ],
              ),
              DropdownButton(
                value: subcategory,
                onChanged: (value){
                  setState(() {
                    subcategory = value;
                  });
                },
                hint: Text("Sub Category"),
                items: [
                  DropdownMenuItem(
                    child: Text("Shirts"),
                    value: "Shirts",
                  ),
                  DropdownMenuItem(
                    child: Text("Dresses"),
                    value: "Dresses",
                  ),
                  DropdownMenuItem(
                    child: Text("Tops"),
                    value: "Tops",
                  ),
                  DropdownMenuItem(
                    child: Text("Shorts"),
                    value: "Shorts",
                  ),
                  DropdownMenuItem(
                    child: Text("Skirts"),
                    value: "Skirts",
                  ),
                  DropdownMenuItem(
                    child: Text("Jeans"),
                    value: "Jeans",
                  ),
                  DropdownMenuItem(
                    child: Text("Pre-loved"),
                    value: "Pre-Loved",
                  ),
                  DropdownMenuItem(
                    child: Text("Sandals"),
                    value: "Sandals",
                  ),
                  DropdownMenuItem(
                    child: Text("Shoes"),
                    value: "Shoes",
                  ),
                  DropdownMenuItem(
                    child: Text("Bags"),
                    value: "Bags",
                  ),
                  DropdownMenuItem(
                    child: Text("Accessories"),
                    value: "Accessories",
                  ),
                  DropdownMenuItem(
                    child: Text("Cosmetics"),
                    value: "Cosmetics",
                  ),
                  DropdownMenuItem(
                    child: Text("Food"),
                    value: "Food",
                  ),
                  DropdownMenuItem(
                    child: Text("Others"),
                    value: "Others",
                  ),
                ],
              ),
            ],
          ),
          Text(" "),
          Text(" "),
          Text(" "),
          Material(
              elevation: 10,
              shadowColor: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Image 1", textScaleFactor: 1.2, style: TextStyle(fontWeight: FontWeight.bold),),
              )
          ),
          Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 10,
            shadowColor: Colors.deepPurple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(" "),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: Color.fromRGBO(255,182,193, 10),
                      height: 50,
                      child: Row(
                        children: [
                          Text("Choose File "),
                          Icon(Icons.file_upload),
                        ],
                      ),
                      onPressed: () async {
                        await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
                          setState(() {
                            _image1 = image;
                            pic1C.text = _arrowurl;
                          });
                        });
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                              color: Color.fromRGBO(255,182,193, 10),
                              height: 100,
                              width: 100,
                              child: (_image1==null)?
                              Center(child: Text("Preview"),):
                              ClipRRect(
                                child: Image.file(_image1, fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10),
                              )
                          ),
                        ),
                        (_image1==null)?
                        Container():
                        RaisedButton(
                          onPressed: () async {
                            StorageReference storageReference = FirebaseStorage.instance
                                .ref()
                                .child('Items/$uemail/${Path.basename(_image1.path)}}');
                            StorageUploadTask uploadTask = storageReference.putFile(_image1);
                            print("File uploading1");
                            setState(() {
                              _uploading1 = true;
                            });
                            await uploadTask.onComplete;
                            print('File Uploaded');
                            setState(() {
                              _uploading1 = false;
                              pic1C.text = _loaderurl;
                            });
                            storageReference.getDownloadURL().then((fileURL) {
                              setState(() {
                                pic1C.text = fileURL;
                              });
                            });
                          },
                          child: Row(
                            children: [
                              Text("Upload "),
                              Icon(Icons.cloud_upload),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Text(" "),
                Center(
                  child: Material(
                    elevation: 10,
                    shadowColor: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        height: 300,
                        width: 300,
                        child: (_image1==null)?
                        Center(child: Text("Upload the image"),):
                        Container(
                            child: (_uploading1==true)?
                            Center( child: Text("Uploading...\nPlease Wait..."),):
                            Image.network(pic1C.text,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress){
                                if (loadingProgress == null) return child;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null ?
                                      loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                    Text(" "),
                                    Text("${(loadingProgress.cumulativeBytesLoaded~/1024).toInt()}kB/${(loadingProgress.expectedTotalBytes~/1024).toInt()}kB"),

                                  ],
                                );


                              },
                            )
                        )
                    ),
                  ),
                ),
                Text(" "),
              ],
            ),
          ),


          Text(" "),
          Material(
              elevation: 10,
              shadowColor: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Image 2", textScaleFactor: 1.2, style: TextStyle(fontWeight: FontWeight.bold),),
              )
          ),
          Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 10,
            shadowColor: Colors.deepPurple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(" "),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: Color.fromRGBO(255,182,193, 10),
                      height: 50,
                      child: Row(
                        children: [
                          Text("Choose File "),
                          Icon(Icons.file_upload),
                        ],
                      ),
                      onPressed: () async {
                        await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
                          setState(() {
                            _image2 = image;
                            pic2C.text = _arrowurl;
                          });
                        });
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                              color: Color.fromRGBO(255,182,193, 10),
                              height: 100,
                              width: 100,
                              child: (_image2==null)?
                              Center(child: Text("Preview"),):
                              ClipRRect(
                                child: Image.file(_image2, fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10),
                              )
                          ),
                        ),
                        (_image2==null)?
                        Container():
                        RaisedButton(
                          onPressed: () async {
                            StorageReference storageReference = FirebaseStorage.instance
                                .ref()
                                .child('Items/$uemail/${Path.basename(_image2.path)}}');
                            StorageUploadTask uploadTask = storageReference.putFile(_image2);
                            print("File uploading2");
                            setState(() {
                              _uploading2 = true;
                            });
                            await uploadTask.onComplete;
                            print('File Uploaded');
                            setState(() {
                              _uploading2 = false;
                              pic2C.text = _loaderurl;
                            });
                            storageReference.getDownloadURL().then((fileURL) {
                              setState(() {
                                pic2C.text = fileURL;
                              });
                            });
                          },
                          child: Row(
                            children: [
                              Text("Upload "),
                              Icon(Icons.cloud_upload),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Text(" "),
                Text(" "),
                Center(
                  child: Material(
                    elevation: 10,
                    shadowColor: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        height: 300,
                        width: 300,
                        child: (_image2==null)?
                        Center(child: Text("Upload the image"),):
                        Container(
                            child: (_uploading2==true)?
                            Center( child: Text("Uploading...\nPlease Wait..."),):
                            Image.network(pic2C.text,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress){
                                if (loadingProgress == null) return child;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null ?
                                      loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                    Text(" "),
                                    Text("${(loadingProgress.cumulativeBytesLoaded~/1024).toInt()}kB/${(loadingProgress.expectedTotalBytes~/1024).toInt()}kB"),

                                  ],
                                );

                              },
                            )
                        )
                    ),
                  ),
                ),
                Text(" "),
              ],
            ),
          ),


          Text(" "),
          Material(
              elevation: 10,
              shadowColor: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Image 3", textScaleFactor: 1.2, style: TextStyle(fontWeight: FontWeight.bold),),
              )
          ),
          Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 10,
            shadowColor: Colors.deepPurple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(" "),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: Color.fromRGBO(255,182,193, 10),
                      height: 50,
                      child: Row(
                        children: [
                          Text("Choose File "),
                          Icon(Icons.file_upload),
                        ],
                      ),
                      onPressed: () async {
                        await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
                          setState(() {
                            _image3 = image;
                            pic3C.text = _arrowurl;
                          });
                        });
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                              color: Color.fromRGBO(255,182,193, 10),
                              height: 100,
                              width: 100,
                              child: (_image3==null)?
                              Center(child: Text("Preview"),):
                              ClipRRect(
                                child: Image.file(_image3, fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10),
                              )
                          ),
                        ),
                        (_image3==null)?
                        Container():
                        RaisedButton(
                          onPressed: () async {
                            StorageReference storageReference = FirebaseStorage.instance
                                .ref()
                                .child('Items/$uemail/${Path.basename(_image3.path)}}');
                            StorageUploadTask uploadTask = storageReference.putFile(_image3);
                            print("File uploading3");
                            setState(() {
                              _uploading3 = true;
                            });
                            await uploadTask.onComplete;
                            print('File Uploaded');
                            setState(() {
                              _uploading3 = false;
                              pic3C.text = _loaderurl;
                            });
                            storageReference.getDownloadURL().then((fileURL) {
                              setState(() {
                                pic3C.text = fileURL;
                              });
                            });
                          },
                          child: Row(
                            children: [
                              Text("Upload "),
                              Icon(Icons.cloud_upload),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Text(" "),
                Text(" "),
                Center(
                  child: Material(
                    elevation: 10,
                    shadowColor: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        height: 300,
                        width: 300,
                        child: (_image3==null)?
                        Center(child: Text("Upload the image"),):
                        Container(
                            child: (_uploading3==true)?
                            Center( child: Text("Uploading...\nPlease Wait..."),):
                            Image.network(pic3C.text,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress){
                                if (loadingProgress == null) return child;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null ?
                                      loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                    Text(" "),
                                    Text("${(loadingProgress.cumulativeBytesLoaded~/1024).toInt()}kB/${(loadingProgress.expectedTotalBytes~/1024).toInt()}kB"),

                                  ],
                                );

                              },
                            )
                        )
                    ),
                  ),
                ),
                Text(" "),
              ],
            ),
          ),


          Text(" "),
          Material(
              elevation: 10,
              shadowColor: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Image 4", textScaleFactor: 1.2, style: TextStyle(fontWeight: FontWeight.bold),),
              )
          ),
          Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 10,
            shadowColor: Colors.deepPurple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(" "),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: Color.fromRGBO(255,182,193, 10),
                      height: 50,
                      child: Row(
                        children: [
                          Text("Choose File "),
                          Icon(Icons.file_upload),
                        ],
                      ),
                      onPressed: () async {
                        await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
                          setState(() {
                            _image4 = image;
                            pic4C.text = _arrowurl;
                          });
                        });
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                              color: Color.fromRGBO(255,182,193, 10),
                              height: 100,
                              width: 100,
                              child: (_image4==null)?
                              Center(child: Text("Preview"),):
                              ClipRRect(
                                child: Image.file(_image4, fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10),
                              )
                          ),
                        ),
                        (_image4==null)?
                        Container():
                        RaisedButton(
                          onPressed: () async {
                            StorageReference storageReference = FirebaseStorage.instance
                                .ref()
                                .child('Items/$uemail/${Path.basename(_image4.path)}}');
                            StorageUploadTask uploadTask = storageReference.putFile(_image4);
                            print("File uploading4");
                            setState(() {
                              _uploading4 = true;
                            });
                            await uploadTask.onComplete;
                            print('File Uploaded');
                            setState(() {
                              _uploading4 = false;
                              pic4C.text = _loaderurl;
                            });
                            storageReference.getDownloadURL().then((fileURL) {
                              setState(() {
                                pic4C.text = fileURL;
                              });
                            });
                          },
                          child: Row(
                            children: [
                              Text("Upload "),
                              Icon(Icons.cloud_upload),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Text(" "),
                Text(" "),
                Center(
                  child: Material(
                    elevation: 10,
                    shadowColor: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        height: 300,
                        width: 300,
                        child: (_image4==null)?
                        Center(child: Text("Upload the image"),):
                        Container(
                            child: (_uploading4==true)?
                            Center( child: Text("Uploading...\nPlease Wait..."),):
                            Image.network(pic4C.text,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress){
                                if (loadingProgress == null) return child;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null ?
                                      loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                    Text(" "),
                                    Text("${(loadingProgress.cumulativeBytesLoaded~/1024).toInt()}kB/${(loadingProgress.expectedTotalBytes~/1024).toInt()}kB"),

                                  ],
                                );


                              },
                            )
                        )
                    ),
                  ),
                ),
                Text(" "),
              ],
            ),
          ),

          Text(" "),
          TextField(
            controller: sellerC,
            decoration: InputDecoration(
              hintText: "Enter seller name",
              border: const OutlineInputBorder(),
            ),
          ),
          Text(" "),
//          TextField(
//            controller: emailC,
//            decoration: InputDecoration(
//              hintText: "Enter Email [IMPORTANT!]",
//              border: const OutlineInputBorder(),
//            ),
//          ),
//          Text(" "),
          TextField(
            controller: emailC,
//            enabled: false,
            decoration: InputDecoration(
              hintText: "Please Enter associated Email",
              border: const OutlineInputBorder(),
            ),
          ),
          Text(" "),
          TextField(
            controller: cityC,
            decoration: InputDecoration(
              hintText: "Enter City...",
              border: const OutlineInputBorder(),
            ),
          ),
          Text(" "),
          TextField(
            controller: priceC,
            decoration: InputDecoration(
              hintText: "Enter Price...",
              border: const OutlineInputBorder(),
            ),
          ),
          Text(" "),
          TextField(
            controller: remarksC,
            decoration: InputDecoration(
              hintText: "Enter Remarks...",
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
                  _callback();
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
