import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';

class ColorSelectItem extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final double radius;
  const ColorSelectItem({ Key? key ,this.color = Colors.black,this.isSelected = false,this.radius = 20}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: BorderRadius.all(Radius.circular(this.radius)),
        border: Border.all(width: this.isSelected ? 2 : 0,color: LRThemeColor.mainColor)
      ),
    );
  }
}