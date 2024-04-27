import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../widgets/custom_category_title_button.dart';
import '../widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              20.heightBox,
              'Item categories'.text.bold.size(20).make(),
              20.heightBox,
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    CustomCategoryTitleButton(
                      category: 'All',
                      onTap: () {},
                    ),
                    CustomCategoryTitleButton(
                      category: 'Wallet',
                      onTap: () {},
                    ),
                    CustomCategoryTitleButton(
                      category: 'Watch',
                      onTap: () {},
                    ),
                    CustomCategoryTitleButton(
                      category: 'Aadhaar',
                      onTap: () {},
                    ),
                    CustomCategoryTitleButton(
                      category: 'Pan Card',
                      onTap: () {},
                    ),
                  ],
                ),
              )
            ],
          ).pSymmetric(h: 5.w, v: 5.w),
        ),
      ),
    );
  }
}
