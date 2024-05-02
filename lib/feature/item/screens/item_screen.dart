import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../core/common/common_row_item_info.dart';
import '../../upload/models/found_item_model.dart';

class ItemScreen extends StatefulWidget {
  final String postId;
  final String imageUrl;
  final FoundItemModel foundItemModel;

  const ItemScreen({
    super.key,
    required this.postId,
    required this.imageUrl,
    required this.foundItemModel,
  });

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
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

              /// NAME
              widget.foundItemModel.name.toString().text.bold.size(20).make(),
              8.heightBox,

              /// DESCRIPTION
              'Description'.text.size(16).gray400.make(),
              widget.foundItemModel.description.text.size(18).make(),
              30.heightBox,
              'Found at'.text.gray400.size(16).make(),
              8.heightBox,

              CustomRowItemDetail(
                icon: Icons.location_on_rounded,
                text: widget.foundItemModel.location,
              ),
              16.heightBox,

              /// TIME
              'Found on'.text.gray400.size(16).make(),
              8.heightBox,
              CustomRowItemDetail(
                icon: Icons.calendar_month_rounded,
                text: widget.foundItemModel.date,
              ),
              16.heightBox,

              /// FOUND BY
              'Found by'.text.size(16).gray400.make(),
              8.heightBox,
              CustomRowItemDetail(
                icon: Icons.person_2_rounded,
                text: widget.foundItemModel.founderName,
              ),
              16.heightBox,

              /// CONTACT
              'Contact info'.text.size(16).gray400.make(),
              8.heightBox,
              CustomRowItemDetail(
                icon: Icons.phone_android_rounded,
                text: widget.foundItemModel.founderContact,
              ),
              16.heightBox,

              /// POSTED AT
              'Posted at'.text.size(16).gray400.make(),
              8.heightBox,
              CustomRowItemDetail(
                icon: Icons.calendar_month_rounded,
                text:
                    widget.foundItemModel.createdAt.toString().substring(0, 11),
              ),
              10.h.heightBox,
            ],
          ).pSymmetric(h: 5.w, v: 5.w),
        ),
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
                  height: 7.h,
                  width: 7.h,
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
                  height: 7.h,
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
