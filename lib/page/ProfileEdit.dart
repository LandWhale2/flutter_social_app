import 'package:flutter/material.dart';

class ProfileEdit extends StatefulWidget {
  final String currentId;
  ProfileEdit({Key key, @required this.currentId}): super(key:key);

  @override
  _ProfileEditState createState() => _ProfileEditState(currentId: currentId);
}

class _ProfileEditState extends State<ProfileEdit> {
  final String currentId;
  _ProfileEditState({Key key, @required this.currentId});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
          ),
        ],
      ),
    );
  }
}
