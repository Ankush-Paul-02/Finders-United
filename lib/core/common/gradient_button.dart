import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class GradientButton extends StatefulWidget {
  final String buttonName;
  final List<Color>? colors;

  const GradientButton({
    super.key,
    required this.buttonName,
    this.colors,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.colors ??
              [
                Colors.black,
                Colors.grey,
              ],
        ),
      ),
      child: widget.buttonName.text.white.bold.size(18).makeCentered(),
    );
  }
}
