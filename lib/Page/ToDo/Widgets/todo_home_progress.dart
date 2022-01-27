import 'package:flutter/widgets.dart';
import 'package:flutter_life_record/Extension/lr_extension.dart';
import 'package:flutter/material.dart';

class ToDoHomeProgress extends StatelessWidget {
  const ToDoHomeProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double padding = 14;
    double width = MediaQuery.of(context).size.width - padding * 2;
    return Card(
      margin: EdgeInsets.all(padding),
      child: Container(
        height: 80,
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(
              color: context.lrColorScheme.background,
            )),
            Positioned.fill(
                right: width - width * 0.5,
                child: Container(
                  color: context.lrColorScheme.secondary,
                )),
            Positioned(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "50",
                    style: context.lrTextTheme.headline2,
                  ),
                  Text(
                    "%",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              left: 14,
              top: 10,
            ),
            Positioned(
              child: Text("今日完成进度"),
              left: 10,
              bottom: 10,
            )
          ],
        ),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
    );
  }
}
