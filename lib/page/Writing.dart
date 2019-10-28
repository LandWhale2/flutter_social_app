import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Writing extends StatefulWidget {
  final String currentId;

  Writing({Key key, @required this.currentId}) : super(key: key);

  @override
  _WritingState createState() => _WritingState(currentId: currentId);
}

class _WritingState extends State<Writing> {
  final String currentId;
  String _CONTEXT;
  File ImageFile;
  String _ImageUrl;
  final _formKey = GlobalKey<FormState>();

  _WritingState({Key key, @required this.currentId});

  Future GETImage() async {
    ImageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (ImageFile != null) {
      print(ImageFile);
      UploadImage();
    }
  }

  Future UploadImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference =
        FirebaseStorage.instance.ref().child('${currentId}/${fileName}.jpg');
    StorageUploadTask uploadTask = reference.putFile(ImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) async {
      print(value);
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          setState(() {
            _ImageUrl = downloadUrl;
          });
//          Firestore.instance
//              .collection('users')
//              .document(currentId)
//              .updateData({
//            'image': FieldValue.arrayUnion([photoUrl])
//          });
        }, onError: (err) {
          Fluttertoast.showToast(msg: '이미지파일이 아닙니다.');
          print('123');
        });
      } else
        Fluttertoast.showToast(msg: '이미지파일이 아닙니다.');
      print(value.error);
    });
  }

  void Postcontext() async{
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        var now = DateTime.now();
        await Firestore.instance
            .collection('users')
            .document(currentId)
            .collection('post')
            .document(DateTime.now().millisecondsSinceEpoch.toString())
            .setData({'context': _CONTEXT, 'image' : _ImageUrl, 'time' : now, 'space' : '영화관'});
        Navigator.pop(context);
      } catch (e) {
        print(e.message);
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 13,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black26),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.clear), onPressed: (){
                        Navigator.pop(context);
                      }),
                      Padding(
                        padding: const EdgeInsets.only(left: 250),
                        child: InkWell(
                          onTap: (){
                            Postcontext();
                          },
                          child: Container(
                            width: 70,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(123, 198, 250, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                '등록',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.black26),
                  ),
                ),
                child: IconButton(
                  icon: Icon(Icons.image),
                  onPressed: GETImage,
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLength: 500,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 15,
                      ),
                      hintText: '내용을 입력해주세요.',
                      border: InputBorder.none,
                    ),
                    validator: (input) {
                      if (input.isEmpty) {
                        return '내용을입력해주세요';
                      }
                    },
                    onSaved: (value) => _CONTEXT = value,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (_ImageUrl != null)
                      ? Image.network(
                          _ImageUrl,
                    fit: BoxFit.fill,
                        )
                      : null)
            ],
          ),
        ),
      ),
    );
  }
}


