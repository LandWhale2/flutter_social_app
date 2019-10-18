import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/base.dart';
import 'package:socialapp/model/todo.dart';
import 'package:socialapp/page/profilepage.dart';
import 'package:socialapp/widgets/database_create.dart';

List<File> tmpimagelist = [];
List<String> tmp64list = ['','','','','',''];
File tmpimage;
List<int> imageBytes = [];
String image64;


Random random = Random();

PictureBox pictureBox1 = PictureBox(num:0);
PictureBox pictureBox2 = PictureBox(num:1);
PictureBox pictureBox3 = PictureBox(num:2);
PictureBox pictureBox4 = PictureBox(num:3);
PictureBox pictureBox5 = PictureBox(num:4);
PictureBox pictureBox6 = PictureBox(num:5);



class REwriteprofile extends StatefulWidget {
  const REwriteprofile({Key key}) : super(key: key);

  @override
  REwriteprofileState createState() => REwriteprofileState();
}

class REwriteprofileState extends State<REwriteprofile> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
//    Future uploadPic(BuildContext context) async{
//      String filName = basename(tmpimage.path);
//      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(filName);
//      StorageUploadTask uploadTask = firebaseStorageRef.putFile(tmpimage);
//      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
//      setState(() {
//        print("Profile pic upload !!");
//        Navigator.push(context, MaterialPageRoute(builder: (context) => writeprofile2()));
//      });
//    }

    Future<Null> _uploadImage() async {
      tmpimagelist.forEach((f) {
        print('asd1 $image64');
        final StorageReference _ref =
        FirebaseStorage.instance.ref().child('${random.nextInt(1000)}.jpg');
        print('asd2');
        final StorageUploadTask uploadTask = _ref.putFile(f);
        print('asd3');
        setState(() {
          String _email = 'kmail';
          for(int i=0 ; i<5 ; i++){
            Todo todoimage = Todo(image0: tmp64list[i], email: _email);
            DBHelper().imageUpdate(todoimage,'image${i}');
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfilePage()));
        });
      });
    }

    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: Container(
            key: _formKey,
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 70),
                    child: Text(
                      '사진 수정',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 50),
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width / 1.4,
                      color: Colors.black26,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 15,
                    alignment: FractionalOffset.center,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(250, 80, 120, 1),
                      borderRadius: BorderRadius.all(const Radius.circular(30)),
                    ),
                    child: Text(
                      "가이드 라인을 읽어주세요 !",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Row(
                      children: <Widget>[
                        pictureBox1,
                        pictureBox2,
                        pictureBox3,
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        pictureBox4,
                        pictureBox5,
                        pictureBox6,
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: (){
//                          Navigator.push(context,
//                              MaterialPageRoute(builder: (context) => Base()));
                        Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 50, left: 40),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 20,
                            alignment: FractionalOffset.center,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius:
                              BorderRadius.all(const Radius.circular(30)),
                            ),
                            child: Text(
                              "뒤로가기",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _uploadImage,
                        child: Padding(
                          padding: EdgeInsets.only(top: 50, left: 60),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 20,
                            alignment: FractionalOffset.center,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(250, 80, 100, 1),
                              borderRadius:
                              BorderRadius.all(const Radius.circular(30)),
                            ),
                            child: Text(
                              "변경",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PictureBox extends StatefulWidget {
  int num;
  PictureBox({Key key, this.num}): super(key:key);

  @override
  _PictureBoxState createState() => _PictureBoxState();
}

var _writeprofile = REwriteprofileState();

class _PictureBoxState extends State<PictureBox> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () async {
          var getimage =
          await ImagePicker.pickImage(source: ImageSource.gallery);
          setState(() {
            tmpimage = getimage;
            imageBytes = getimage.readAsBytesSync();
            image64 = base64Encode(imageBytes);
            print(tmp64list.length);
            print('Image Path $tmpimage');
          });
          tmp64list[widget.num] = image64;
        },
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Container(
            width: MediaQuery.of(context).size.width / 3.3,
            height: MediaQuery.of(context).size.height / 7,
            color: Colors.black12,
            child: (tmpimage != null)
                ? Image.file(tmpimage, fit: BoxFit.fill)
                : Icon(
              Icons.camera_alt,
              color: Colors.black26,
            ),
          ),
        ),
      ),
    );
  }
}

