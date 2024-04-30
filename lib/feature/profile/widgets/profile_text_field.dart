import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileTextField extends StatefulWidget {
  final bool isReadOnly;
  final String hintText;
  final IconData icon;
  final TextInputType? textInputType;
  final TextEditingController? textEditingController;

  const ProfileTextField({
    super.key,
    required this.isReadOnly,
    required this.hintText,
    required this.icon,
    this.textInputType,
    this.textEditingController,
  });

  @override
  State<ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<ProfileTextField> {
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
        borderRadius: 10,
        controller: widget.textEditingController,
        fillColor: Colors.white,
        contentPaddingLeft: 10,
        clear: false,
        readOnly: widget.isReadOnly,
        prefixIcon: Icon(
          widget.icon,
          color: Colors.grey,
        ),
        height: 60,
        hint: widget.hintText,
        borderType: VxTextFieldBorderType.roundLine,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
        ),
        keyboardType: widget.textInputType,
      ),
    );
  }
}
