import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class Todo {
  int id;
  String name;
  String intro;
  String age;
  String password, email;
  String image0, image1, image2, image3, image4, image5;
  int vote;
  String location;

  Todo({
    this.id,
    this.email,
    this.password,
    this.name,
    this.intro,
    this.location,
    this.vote,
    this.image0,
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.image5,
    this.age,});

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json["id"],
    intro: json["intro"],
    name: json["name"],
    age: json["age"],
    email: json["email"],
    password: json["password"],
    vote: json["vote"],
    location: json["location"],
    image0: json["image0"],
    image1: json["image1"],
    image2: json["image2"],
    image3: json["image3"],
    image4: json["image4"],
    image5: json["image5"],
  );

  Map<String, dynamic> toJson() =>
      {
        "id" :id,
        "name": name,
        "age": age,
        "intro" : intro,
        "email" : email,
        "password" : password,
        "vote" : vote,
        "location" : location,
        "image0" : image0,
        "image1" : image1,
        "image2" : image2,
        "image3" : image3,
        "image4" : image4,
        "image5" : image5,
      };

  Map<String, dynamic> toJson2() =>
      {
        "image0" : image0,
        "image1" : image1,
        "image2" : image2,
        "image3" : image3,
        "image4" : image4,
        "image5" : image5,
      };

}


class Auth{
  int _id;
  String _email;
  String _name;
  String _avatar;

  String _deviceToken;
  String _accessToken;
  String _uid;
  String _clientId;
  Auth(this._uid, this._accessToken);

  Auth.map(dynamic response, String deviceToken){
    var obj = json.decode(response.body)["data"];

    var headers= response.headers;

    this._deviceToken = deviceToken;

    this._id=obj["id"];
    this._email=obj["email"];
    this._name=obj["name"];
    this._avatar=obj["avatar"];
    this._accessToken=obj["access-token"];
    this._clientId=obj["client"];
    this._uid=obj["uid"];
  }

  Auth.fromMap(dynamic obj){
    this._id=obj["id"];
    this._email=obj["email"];
    this._name=obj["name"];
    this._avatar=obj["avatar"];
    this._accessToken=obj["access-token"];
    this._deviceToken=obj["deviceToken"];
    this._clientId=obj["client"];
    this._uid=obj["uid"];
  }

  int get id => _id;
  String get email => _email;
  String get name => _name;
  String get avatar => _avatar;
  String get uid => _uid;
  String get accessToken => _accessToken;
  String get deviceToken => _deviceToken;
  String get clientId => _clientId;


  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["id"] = _id;
    map["email"] = _email;
    map["name"] = _name;
    map["avatar"] = _avatar;
    map["uid"] = _uid;
    map["accessToken"] = _accessToken;
    map["deviceToken"] = _deviceToken;
    map["clientId"] = _clientId;

    return map;
  }
}


class User{
  int _id;
  String _email;
  String _name;
  String _avatar;
  String _password;

  User(this._email, this._password);

  User.map(dynamic obj){
    this._id = obj["id"];
    this._email = obj["email"];
    this._name = obj["name"];
    this._avatar = obj["avatar"];
    this._password = obj["password"];
  }


  int get id => _id;
  String get email => _email;
  String get name => _name;
  String get password => _password;
  String get avatar => _avatar;


  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    map["id"] = _id;
    map["email"] = _email;
    map["name"] = _name;
    map["_avatar"] = _avatar;
    map["password"] = _password;

    return map;
  }
}


class Message{
  int _id;
  String _text;
  String _name;
  DateTime _created_at;
  User _user;

  Message.map(dynamic obj){
    this._id = obj['id'];
    this._text = obj['text'];
    this._user = User.map(obj["user"]);
    this._name = obj['name'];
    this._created_at = DateTime.tryParse(obj["created_at"]);
  }

  int get id => _id;
  String get text => _text;
  String get name => _name;
  DateTime get created_at => _created_at;
  User get user => _user;

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["text"] = _text;
    map["name"] = _name;
    map["user"] = _user;
    map["created_at"] = _created_at;

    return map;

  }
}


class ListMessage{
  int _current_page;
  int _count;
  int _total_pages;
  int _total_count;
  List<Message> _messages = <Message>[];

  int get current_page => _current_page;
  int get count => _count;
  int get total_pages => _total_pages;
  int get total_count => _total_count;
  List<Message> get messages => _messages;

  ListMessage.map(dynamic obj){
    this._current_page = obj["current_page"];
    this._count = obj["count"];
    this._total_pages = obj["total_pages"];
    this._total_count = obj["total_count"];

    for(final x in obj["messages"]){
      this._messages.add(Message.map(x));
    }
  }
}