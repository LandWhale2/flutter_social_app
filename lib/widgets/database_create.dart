

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:socialapp/model/todo.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'dart:io';

final String tableName = 'person';

class DBHelper{
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  //해당 변수에 데이터베이스 정보 저장
  static Database _database;

  Future<Database> get database async{
    if(_database == null){
      print('No data , create database');
      _database = await initDB();
      return _database;}else {
      print('이미 데이터베이스가 존재');
      return _database;
    }
  }

  initDB() async{
    io.Directory dbDir = await getApplicationDocumentsDirectory();
    String path = join(dbDir.path, "social2.db");
    print('init...');
    print(path);
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async{
        await db.execute('''
        CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY,
        email TEXT,
        password TEXT,
        name TEXT,
        intro TEXT,
        age TEXT,
        image0 BLOB,
        image1 BLOB,
        image2 BLOB,
        image3 BLOB,
        image4 BLOB,
        image5 BLOB,
        vote INTEGER,
        location TEXT) ''');
      },
    );
  }


  createData(Todo todo)async{
    print('데이터베이스 생성중..');
    final db = await database;
    print('데이터베이스 추가중 ...');
    var res = await db.insert(tableName, todo.toJson());
    print('데이터베이스 추가완료');
    return res;
  }

  updateimage(Todo todo)async{
    final db = await database;
    var res = await db.update(tableName, todo.toJson2(),where: 'email =?' ,
        whereArgs: [todo.email] );
    return res;
  }

  getEmail(String email) async{
    final db = await database;
    var res = await db.query("person", where: "email = ?", whereArgs: [email]);
    return res.isNotEmpty? Todo.fromJson(res.first) : Null;
  }

  getuserIDPW(String email) async{
    final db = await database;
    var res = await db.query("person",columns: ['email', 'password'] ,where: "email = ?", whereArgs: [email]);
    return res.isNotEmpty? res : Null;
  }

  getuserIMAGE1(String email) async{
    final db = await database;
    var res = await db.query("person", columns: ['image0'], where: "email = ?", whereArgs: [email]);
    return res.isNotEmpty? res : Null;
  }


  profileUpdate(Todo todo) async{
    final db = await database;
    var res = await db.rawUpdate(
      'UPDATE person SET name = ?, age = ?, intro = ? WHERE email = ?',
      [todo.name, todo.age, todo.intro, todo.email]
    );
    return res;
  }

  imageUpdate(Todo todo, String select) async{
    final db = await database;
    var res = await db.rawUpdate(
      'UPDATE person SET ${select} = ? WHERE email = ?',
      [todo.image0, todo.email]
    );
    return res;
  }

  //read
  getTodo(int id) async{
    final db = await database;
    var res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Todo.fromJson(res.first) : Null;
  }

  getAllTodos() async{
    final db = await database;
    var res = await db.query(tableName);
    return res;
  }
  updateTodo(Todo todo) async{
    final db = await database;
    Directory dbDir = await getApplicationDocumentsDirectory();
    print(dbDir.path);
    var res = await db.update(tableName, todo.toJson(),
        where: 'id =?' ,
        whereArgs: [todo.id]);
    print('update');
    return res;
  }

  //Delete
  deleteTodo(int id) async{
    final db = await database;
    db.delete(tableName, where: 'id =?', whereArgs: [id]);
  }

  deleteAllTodos() async{
    final db =await database;
    db.rawDelete("Delete * from $tableName");
  }


  gettop10person()async{
    final db = await database;
    var res = await db.rawQuery('SELECT*FROM person ORDER BY vote DESC LIMIT (SELECT CAST(round(COUNT(*) * 30/100)AS INTEGER) FROM person)');
    return res.isNotEmpty? res : Null;
  }




}

//class DatabaseHelper{
//  static final DatabaseHelper _instance = DatabaseHelper().internal();
//  factory DatabaseHelper() => _instance;
//
//  static Database _db;
//  String _dbFile = "main.db";
//
//  Future<Database> get db async{
//    if(_db != null) return _db;
//    _db = await initDb();
//    return _db;
//  }
//
//  DatabaseHelper.internal();
//
//  initDb() async{
//    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    String path = join(documentsDirectory.path, _dbFile);
//    var theDb =await openDatabase(path, version: 1, onCreate: _onCreate);
//    return theDb;
//  }
//
//  Future<String> deleteDb() async{
//    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    String path = join(documentsDirectory.path, _dbFile);
//    await deleteDatabase(path);
//    _db = null;
//    return path;
//
//  }
//
//  void _onCreate(Database db, int version) async{
//    await db.execute(
//        "CREATE TABLE Auth(id INTERGER PRIMARY KEY, name TEXT, email TEXT, avatar TEXT, uid TEXT, accessToken TEXT, deviceToken TEXT, clientId TEXT);");
//
//    print("created tables");
//  }
//
//  Future<int> saveAuth(Auth auth) async{
//    var dbClient = await db;
//    int res = await dbClient.insert("Auth", auth.toMap());
//    return res;
//  }
//
//
//  Future<Auth> getAuth() async{
//    var dbClient = await db;
//    var res = await dbClient.query("Auth", limit:1);
//    return Auth.fromMap(res.first);
//  }
//
//  Future<bool> isLoggedIn() async{
//    var dbClient = await db;
//    var res = await dbClient.query("Auth");
//    return res.length > 0 ? true : false;
//  }
//
//}