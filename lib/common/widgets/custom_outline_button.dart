import 'package:flutter/material.dart';
import 'package:todo_app/common/widgets/app_style.dart';
import 'package:todo_app/common/widgets/reusable_text.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.width,
      required this.height,
      this.color2,
      required this.color});

  final String text;
  final Function() onPressed;
  final double width, height;
  final Color color;
  final Color? color2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color2,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            width: 1,
            color: color,
          ),
        ),
        child: Center(
          child: ReusableText(
            text: text,
            style: appStyle(
              size: 16,
              color: color,
              fw: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
