import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomCategoryTitleButton extends StatelessWidget {
  final String category;
  final VoidCallback onTap;

  const CustomCategoryTitleButton({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.w,
        height: 45,
        margin: EdgeInsets.only(right: 5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.cyan.shade100,
              Colors.cyan,
            ],
          ),
        ),
        child: category.text
            .bodyText1(context)
            .size(18)
            .white
            .align(TextAlign.center)
            .makeCentered(),
      ),
    );
  }
}
