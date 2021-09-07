import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';

class ToDoProjectCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Color color;
  const ToDoProjectCard(
      {Key? key,
      this.iconData = Icons.add,
      this.title = "标题",
      this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Stack(
          children: [
            Positioned(
              child: Text(
                this.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                maxLines: 1,
              ),
              left: 8,
              top: 8,
              right: 8,
            ),
            Positioned(
              child: Icon(
                this.iconData,
                color: this.color,
                size: 30,
              ),
              bottom: 8,
              right: 8,
            )
          ],
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, LRThemeColor.mainColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.5, 1.0])),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      elevation: 2,
    );
  }
}
