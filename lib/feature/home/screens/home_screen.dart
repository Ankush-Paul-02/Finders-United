import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../auth/providers/auth_provider.dart';
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
    return SingleChildScrollView(
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return FutureBuilder(
            future: authProvider.getUserData(authProvider.user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasError) {
                return 'Error'.text.makeCentered();
              } else {
                final user = snapshot.data;
                if (user == null) {
                  return 'No user found'.text.bold.size(22).makeCentered();
                }
                return Column(
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RecentPostCard(
                          postId: '1',
                          imageUrl:
                              'https://images.unsplash.com/photo-1579014134953-1580d7f123f3?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8d2FsbGV0fGVufDB8fDB8fHww',
                        ),
                        RecentPostCard(
                          postId: '2',
                          imageUrl:
                              'https://images.unsplash.com/photo-1539874754764-5a96559165b0?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHdhdGNofGVufDB8fDB8fHww',
                        ),
                      ],
                    ),
                  ],
                ).pSymmetric(h: 5.w, v: 5.w);
              }
            },
          );
        },
      ),
    );
  }
}
