import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BlackGradientButton extends StatefulWidget {
  final String buttonName;

  const BlackGradientButton({
    super.key,
    required this.buttonName,
  });

  @override
  State<BlackGradientButton> createState() => _BlackGradientButtonState();
}

class _BlackGradientButtonState extends State<BlackGradientButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black,
            Colors.grey,
          ],
        ),
      ),
      child: widget.buttonName.text.white.bold.size(18).makeCentered(),
    );
  }
}
