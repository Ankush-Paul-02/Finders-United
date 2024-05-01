import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final bool readOnly;
  final IconData? icon;
  final TextInputType textInputType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.maxLines,
    required this.textInputType,
    required this.readOnly,
    this.icon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(1, 2),
            spreadRadius: 2,
            blurRadius: 1,
          ),
        ],
      ),
      child: VxTextField(
        controller: widget.controller,
        borderRadius: 10,
        fillColor: Colors.white,
        contentPaddingLeft: 10,
        clear: false,
        readOnly: widget.readOnly,
        enableSuggestions: true,
        autocorrect: true,
        prefixIcon: Icon(
          widget.icon,
          color: Colors.cyan,
        ),
        height: 60,
        hint: widget.hintText,
        maxLine: widget.maxLines,
        borderType: VxTextFieldBorderType.roundLine,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
        ),
        keyboardType: widget.textInputType,
      ),
    );
  }
}
