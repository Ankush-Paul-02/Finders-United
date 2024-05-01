import 'package:finders_united/feature/item/screens/item_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class RecentPostCard extends StatelessWidget {
  final String postId;
  final String imageUrl;

  const RecentPostCard({
    super.key,
    required this.postId,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 42.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            offset: const Offset(1, 2),
            spreadRadius: 2,
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 20.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.cyan,
            ),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemScreen(
                    postId: postId,
                    imageUrl: imageUrl,
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: 'recent post $postId',
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          3.w.heightBox,
          'Brown Wallet'.text.bold.size(14).make(),
          1.w.heightBox,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_pin,
                color: Colors.cyan[200],
              ),
              Expanded(
                child: 'Sonarpur, Kolkata'
                    .text
                    .minFontSize(14)
                    .cyan500
                    .maxLines(1)
                    .ellipsis
                    .make(),
              ),
            ],
          ),
        ],
      ).pSymmetric(h: 2.w, v: 2.w),
    );
  }
}
