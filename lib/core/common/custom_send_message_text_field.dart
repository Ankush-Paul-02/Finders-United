import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomSendMessageTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextInputType textInputType;

  const CustomSendMessageTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.maxLines,
    required this.textInputType,
  });

  @override
  State<CustomSendMessageTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomSendMessageTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(3, 3),
            spreadRadius: 3,
            blurRadius: 3,
          ),
        ],
      ),
      child: VxTextField(
        controller: widget.controller,
        borderRadius: 10,
        fillColor: Colors.white,
        contentPaddingLeft: 10,
        clear: false,
        enableSuggestions: true,
        autocorrect: true,
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
