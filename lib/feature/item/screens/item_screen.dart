import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class ItemScreen extends StatefulWidget {
  final String postId;
  final String imageUrl;

  const ItemScreen({
    super.key,
    required this.postId,
    required this.imageUrl,
  });

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Hero(
                tag: 'recent post ${widget.postId}',
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.4),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.heightBox,
            'Brown Wallet'.text.bold.size(20).make(),
            30.heightBox,
            'Found at'.text.size(16).make(),
            10.heightBox,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_pin,
                  color: Colors.cyan[200],
                ),
                10.widthBox,
                Expanded(
                  child: 'Sonarpur, Kolkata, 700150'
                      .text
                      .minFontSize(18)
                      .cyan500
                      .maxLines(1)
                      .ellipsis
                      .make(),
                ),
              ],
            ),
            30.heightBox,
            'Found on'.text.size(16).make(),
            10.heightBox,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.access_time_filled_rounded,
                  color: Colors.cyan[200],
                ),
                10.widthBox,
                Expanded(
                  child: '27 Apr 2024, 11:52 PM'
                      .text
                      .minFontSize(18)
                      .cyan500
                      .maxLines(1)
                      .ellipsis
                      .make(),
                ),
              ],
            ),
            30.heightBox,
            'Description'.text.size(16).gray400.make(),
            "A weathered leather wallet discovered on the roadside, containing potential clues to its owner's identity.This silent-relic of someone's journey awaits reunion with its rightful owner. If lost, please contact [your contact information] to reclaim."
                .text
                .make(),
          ],
        ).pSymmetric(h: 5.w, v: 5.w),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          width: double.infinity,
          height: 70,
          color: Colors.transparent,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => debugPrint('Bookmark item...'),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.cyan.shade100,
                        Colors.cyan,
                      ],
                    ),
                  ),
                  child: const Icon(Icons.bookmark, color: Colors.white),
                ),
              ),
              Expanded(
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.only(left: 20),
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
                  child: 'Claim item'.text.white.bold.size(18).makeCentered(),
                ).onTap(
                  () => debugPrint('Claim item...'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
