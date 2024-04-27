import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../home/screens/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              'FindersUnited'.text.semiBold.black.size(20).make(),
              18.h.heightBox,
              Lottie.asset('assets/animation/search.json'),
              40.heightBox,
              Container(
                height: 40.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black,
                      Colors.grey,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    'Find Your Lost Items'.text.white.bold.size(20).make(),
                    30.heightBox,
                    'a place where you can find your lost items and upload your found items'
                        .text
                        .white
                        .align(TextAlign.center)
                        .make(),
                    30.heightBox,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.all(5.w),
                        backgroundColor: Colors.cyan[200],
                      ),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(),
                          )),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ).pSymmetric(h: 5.w, v: 5.w),
              )
            ],
          ).pSymmetric(h: 5.w, v: 5.w),
        ),
      ),
    );
  }
}
