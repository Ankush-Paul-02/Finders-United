import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
              'FindersUnited'.text.white.size(20).make(),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  debugPrint('Logging out...');
                },
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          30.heightBox,
          'Discover Lost Items'.text.size(22).bold.white.make(),
          20.heightBox,
          SearchBar(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            leading: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            elevation: MaterialStateProperty.all(0),
            hintText: 'Search item',
            hintStyle: MaterialStateProperty.all(
              const TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: [
              Icon(
                Icons.filter_alt_rounded,
                color: Colors.cyan[200],
              ),
            ],
          ),
        ],
      ).pSymmetric(h: 5.w, v: 5.w),
    );
  }
}
