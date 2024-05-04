import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomRowItemDetail extends StatefulWidget {
  final String text;
  final IconData icon;

  const CustomRowItemDetail({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  State<CustomRowItemDetail> createState() => _CustomRowItemDetailState();
}

class _CustomRowItemDetailState extends State<CustomRowItemDetail> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          widget.icon,
          color: Colors.cyan[200],
        ),
        10.widthBox,
        Expanded(
          child: widget.text.text
              .minFontSize(18)
              .black
              .maxLines(2)
              .ellipsis
              .make(),
        ),
      ],
    );
  }
}
