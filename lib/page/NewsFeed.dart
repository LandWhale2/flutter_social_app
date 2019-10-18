import 'package:flutter/material.dart';
import 'package:socialapp/widgets/post_item.dart';
import 'package:socialapp/model/data.dart';

class NewsFeed extends StatefulWidget{
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index){

          Map post = posts[index];
          return PostItem(
            img:post['img'],
            name: post['name'],
            dp : post['dp'],
            time: post['time'],
            address :post['address'],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.sms,
        ),
        backgroundColor: Colors.red,
        onPressed: (){},
      ),
    );
  }

}