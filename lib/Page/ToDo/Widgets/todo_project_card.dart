import 'package:flutter/material.dart';
import 'package:flutter_life_record/Extension/lr_extension.dart';

class ToDoProjectCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Color color;
  final int? itemCount;

  const ToDoProjectCard(
    this.title, {
    Key? key,
    this.itemCount,
    this.iconData = Icons.add,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Stack(
          children: [
            Positioned(
              child: Text(
                this.title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
                maxLines: 1,
              ),
              left: 14,
              top: 10,
              right: 14,
            ),
            Positioned(
              child: Container(
                padding: EdgeInsets.all(2),
                child: Icon(
                  this.iconData,
                  color: this.color,
                  size: 30,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              bottom: 10,
              right: 10,
            ),
            if (itemCount != null)
              Positioned(
                child: Text("${this.itemCount}",
                    style: context.lrTextTheme.subtitle1!
                        .copyWith(color: Colors.white, fontSize: 30)),
                bottom: 10,
                left: 10,
              )
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: this.color
            // gradient: LinearGradient(
            //     colors: [this.color.withOpacity(0.6), this.color],
            //     begin: Alignment.topRight,
            //     end: Alignment.bottomLeft,
            //     stops: [0.1, 1.0])

            ),
      ),
      elevation: 2,
    );
  }
}
