import 'package:finders_united/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../auth/providers/auth_provider.dart';
import '../../upload/models/found_item_model.dart';
import '../../upload/provider/upload_item_provider.dart';
import '../widgets/custom_category_title_button.dart';
import '../widgets/home_header.dart';
import '../widgets/recent_post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final uploadItemProvider =
        Provider.of<UploadItemProvider>(context, listen: false);

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return FutureBuilder(
          future: authProvider.getUserData(authProvider.user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.cyan,
                ),
              );
            } else if (snapshot.hasError) {
              return 'Error'.text.makeCentered();
            } else {
              final user = snapshot.data;
              if (user == null) {
                return 'No user found'.text.bold.size(22).makeCentered();
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(user: user),
                    20.heightBox,
                    'Item categories'.text.bold.size(20).make(),
                    20.heightBox,

                    /// Category Items
                    SizedBox(
                      height: 60,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: AppConstants.categories
                            .map(
                              (category) => CustomCategoryTitleButton(
                                category: category,
                                onTap: () {},
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    30.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        'Recent posts'.text.bold.size(20).make(),
                        'See more'.text.color(Colors.grey).size(16).make(),
                      ],
                    ),
                    20.heightBox,
                    FutureBuilder<List<FoundItemModel>>(
                      future: uploadItemProvider.recentFoundItems(context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child:
                                CircularProgressIndicator(color: Colors.cyan),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final recentItems = snapshot.data ?? [];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: recentItems
                                .map((item) => RecentPostCard(
                                      postId: item.id,
                                      imageUrl: item.imageUrl,
                                      foundItemModel: item,
                                    ))
                                .toList(),
                          );
                        }
                      },
                    )
                  ],
                ).pSymmetric(h: 5.w, v: 5.w),
              );
            }
          },
        );
      },
    );
  }
}
