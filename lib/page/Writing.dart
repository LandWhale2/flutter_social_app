import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/widgets/adHelper.dart';

class Writing extends StatefulWidget {
  final String currentId;
  String title, SelectSpace;
  String contextId;

  Writing({Key key, @required this.currentId, @required this.title, @required this.SelectSpace, @required this.contextId}) : super(key: key);

  @override
  _WritingState createState() => _WritingState(currentId: currentId, title: title, SelectSpace: SelectSpace,contextId: contextId);
}

class _WritingState extends State<Writing> {
  String contextId;
  String title, SelectSpace;
  final String currentId;
  String _CONTEXT;
  File ImageFile;
  String _ImageUrl;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _controller = TextEditingController();

  _WritingState({Key key, @required this.currentId,@required this.title, @required this.SelectSpace, @required this.contextId});

  Future GETImage() async {
    ImageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if(ImageFile != null){
      setState(() {
        isLoading = true;
      });
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
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          setState(() {
            isLoading = false;
            _ImageUrl = downloadUrl;
          });
//          Firestore.instance
//              .collection('users')
//              .document(currentId)
//              .updateData({
//            'image': FieldValue.arrayUnion([photoUrl])
//          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: '이미지파일이 아닙니다.');
        });
      } else
        Fluttertoast.showToast(msg: '이미지파일이 아닙니다.');
      print(value.error);
    });
  }

  Postcontext() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        var documentName= 'M'+DateTime.now().millisecondsSinceEpoch.toString();
        await Firestore.instance
            .collection('users')
            .where('id', isEqualTo: currentId)
            .snapshots()
            .listen((data) async {
          await Firestore.instance
              .collection(SelectSpace)
              .document(documentName)
              .setData({
            'context': _CONTEXT,
            'image': data.documents[0]['image'],
            'time': DateTime.now().millisecondsSinceEpoch,
            'title': title,
            'nickname': data.documents[0]['nickname'],
            'contextImage' : _ImageUrl,
            'id' : data.documents[0]['id'],
            'contextID' : documentName,
            'comment' : 0,
            'like': 0,
            'likeperson': null,
            'latitude' : data.documents[0]['latitude'],
            'longitude' : data.documents[0]['longitude'],
            'space': SelectSpace,
          });
        });

        Navigator.pop(context);
      } catch (e) {
        print(e.message);
      }
    }
  }
  RePostcontext(){
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        Firestore.instance.collection(SelectSpace).document(contextId).updateData({
          'context' : _CONTEXT,
          'contextImage': _ImageUrl,
        });

        Navigator.pop(context);
      } catch (e) {
        print(e.message);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Ads.hideBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: Firestore.instance.collection(SelectSpace).document(contextId).snapshots(),
          builder: (context, snapshot) {
            var ds = snapshot.data;
            if(!snapshot.hasData){
              return Container();
            }
            return Container(
              child: Stack(
                children: <Widget>[
                  Column(
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
                              IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              Padding(
                                padding: const EdgeInsets.only(left: 250),
                                child: InkWell(
                                  onTap: () {
                                    if(contextId != null){
                                      RePostcontext();
                                    }else{
                                      Postcontext();
                                    }

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
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
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
                            controller: (contextId == null)?_controller: asd(_controller, ds['context']),
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
                          child: (_ImageUrl != null)?CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                              ),
//                          decoration: BoxDecoration(
//                            color: Colors.black12,
//                            borderRadius: BorderRadius.all(
//                              Radius.circular(8.0),
//                            ),
//                          ),
                            ),
                            imageUrl: _ImageUrl,
                          ): null,)
                    ],
                  ),
                  buildLoading(),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  TextEditingController asd(TextEditingController controller, String text){
    controller.text= text;
    return controller;
  }

  Widget buildLoading(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        isLoading
            ?Container(
          child: Center(
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey)),
          ),
          color: Colors.white.withOpacity(0.8),
        )
            :Container(),
      ],
    );
  }
}
