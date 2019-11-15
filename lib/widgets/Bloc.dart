import 'package:flutter/material.dart';


class BlocProvider extends ChangeNotifier{
  int _MenuController = 1;
  int get MenuController => _MenuController;

  set MenuController(int val){
    _MenuController = val;
    notifyListeners();
  }

  select(int num){
    _MenuController = num;
    notifyListeners();
  }
}

class AlertProvider extends ChangeNotifier{
  int _Alert = 0;
  int get AlertController => _Alert;

  set AlertController(int val){
    _Alert = val;
    notifyListeners();
  }

  IncreaseCount(){
    _Alert++;
    notifyListeners();
  }

  ReadAlert(){
    _Alert = 0;
    notifyListeners();
  }
}


class IdProvider extends ChangeNotifier{
  String _currentId;
  String get CurrentId => _currentId;

  set CurrentId(String val){
    _currentId = val;
    notifyListeners();
  }

  saveId(String Id){
    _currentId = Id;
    notifyListeners();
  }
}




