import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'board.dart';

class asd extends StatefulWidget {
  @override
  _asdState createState() => _asdState();
}

class _asdState extends State<asd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('asd'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: StaggeredGridView.countBuilder(
                scrollDirection: Axis.horizontal,
                crossAxisCount: 4,
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) => Container(
                  color: Colors.green,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text('$index'),
                    ),
                  ),
                ),
                staggeredTileBuilder: (int index) =>
                    StaggeredTile.count(2, index.isEven ? 2 : 1),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
