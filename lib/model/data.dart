import 'dart:math';
import 'package:socialapp/widgets/database_create.dart';
import 'todo.dart';
import 'dart:async';

Random random = Random();

List names = [
  "이주형",
  "김혁진",
  "허석호",
  "이수민",
  "이원진",
  "신유경",
  "하명호",
  "김광석",
  "김재우",
  "신주원",
];

List posts = List.generate(
    13,
    (index) => {
          "name": names[random.nextInt(10)],
          "dp": "assets/cm${random.nextInt(10)}.jpeg",
          "time": "${random.nextInt(50)} min ago",
          "img": "assets/cm${random.nextInt(10)}.jpeg",
          'address': addres[random.nextInt(10)],
          "num": "10"
        });

List addres = [
  "대전광역시, 서구 대덕대로",
  "대전광역시, 서구 대덕대로",
  "대전광역시, 서구 대덕대로",
  "대전광역시, 서구 대덕대로",
  "대전광역시, 서구 대덕대로",
  "대전광역시, 서구 대덕대로",
  "대전광역시, 서구 대덕대로",
  "대전광역시, 서구 대덕대로",
  "대전광역시, 서구 대덕대로",
  "대전광역시, 서구 대덕대로",
];

//getTopuser() async {
//  var getinfo = await DBHelper().gettop10person();
//  return getinfo.isNotEmpty? getinfo : Null ;
//}
