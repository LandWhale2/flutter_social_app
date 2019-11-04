import 'package:flutter/material.dart';


class BlocProvider extends ChangeNotifier{
  int _MenuController = 1;
  int get MenuController => _MenuController;

  set MenuController(int val){
    _MenuController = val;
    notifyListeners();
  }

  select1(){
    _MenuController = 1;
    notifyListeners();
  }

  select2(){
    _MenuController = 2;
    notifyListeners();
  }

}