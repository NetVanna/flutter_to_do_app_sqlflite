import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  const ReusableText(
      {super.key,
      required this.text,
      required this.style,
      this.maxLines = 1,
      this.softWrap = false});

  final String text;
  final TextStyle style;
  final int? maxLines;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: TextAlign.left,
      softWrap: softWrap,
      overflow: TextOverflow.fade,
      style: style,
    );
  }
}
