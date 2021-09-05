import 'package:flutter/material.dart';

class ToDoProjectCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Color color;
  const ToDoProjectCard({ Key? key, this.iconData = Icons.add, this.title = "标题", this.color = Colors.black }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(this.iconData,color: this.color,size: 30,),
            SizedBox(
              height: 8,
            ),
            Text(this.title,style: TextStyle(fontSize: 16),)
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      elevation: 2,
    );
  }
}