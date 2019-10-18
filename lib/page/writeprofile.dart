import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as prefix0;
import 'package:socialapp/model/todo.dart';
import 'dart:io';
import 'package:socialapp/page/writeprofile2.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:socialapp/widgets/database_create.dart';

List<File> tmpimagelist = [];
List<String> tmp64list = ['', '', '', '', '', ''];
File tmpimage;
List<int> imageBytes = [];
String image64;

Random random = Random();

PictureBox pictureBox1 = PictureBox(num: 0);
PictureBox pictureBox2 = PictureBox(num: 1);
PictureBox pictureBox3 = PictureBox(num: 2);
PictureBox pictureBox4 = PictureBox(num: 3);
PictureBox pictureBox5 = PictureBox(num: 4);
PictureBox pictureBox6 = PictureBox(num: 5);

final key = GlobalKey<writeprofileState>();

class writeprofile extends StatefulWidget {
  const writeprofile({Key key}) : super(key: key);

  @override
  writeprofileState createState() => writeprofileState();
}

class writeprofileState extends State<writeprofile> {
  final formKey = GlobalKey<FormState>();

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
      print('asd');
      tmpimagelist.forEach((f) {
        print('asd1 $image64');
        final StorageReference _ref =
            FirebaseStorage.instance.ref().child('${random.nextInt(1000)}.jpg');
        print('asd2');
        final StorageUploadTask uploadTask = _ref.putFile(f);
        print('asd3');
        setState(() {
          String _email = 'roro';
          Todo imagetodo = Todo(
            email: _email,
            image0: tmp64list[0],
            image1: tmp64list[1],
            image2: tmp64list[2],
            image3: tmp64list[3],
            image4: tmp64list[4],
            image5: tmp64list[5],
          );
          DBHelper().updateimage(imagetodo);
//          Navigator.push(context,
//              MaterialPageRoute(builder: (context) => writeprofile2()));
        });
      });
    }

    imageupload()async{
      print('업로드 시도');
      String _email = 'gam';
      Todo imagetodo = Todo(
        email: _email,
        image0: tmp64list[0],
        image1: tmp64list[1],
        image2: tmp64list[2],
        image3: tmp64list[3],
        image4: tmp64list[4],
        image5: tmp64list[5],
      );
      DBHelper().updateimage(imagetodo);
    }


    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: Container(
            key: formKey,
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 70),
                    child: Text(
                      '사진 선택',
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
                  InkWell(
                    onTap: imageupload,
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
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
                          "Next",
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
            ),
          ),
        ),
      ),
    );
  }
}

class PictureBox extends StatefulWidget {
  int num;

  PictureBox({Key key, this.num}) : super(key: key);

  @override
  _PictureBoxState createState() => _PictureBoxState();
}

var _writeprofile = writeprofileState();

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
