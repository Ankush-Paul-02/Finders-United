import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../auth/providers/auth_provider.dart';
import '../../home/widgets/recent_post_card.dart';
import '../../upload/models/found_item_model.dart';
import '../../upload/provider/upload_item_provider.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<UploadItemProvider>(context);
    return Consumer<AuthProvider>(
      builder: (context, provider, child) => FutureBuilder(
        future: provider.getUserData(provider.user.uid),
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
            List<String> bookmarkedItemIds = user.bookmarkItems ?? [];
            return bookmarkedItemIds.isNotEmpty
                ? SingleChildScrollView(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 7 / 10,
                      ),
                      itemCount: bookmarkedItemIds.length,
                      itemBuilder: (context, index) =>
                          Consumer<UploadItemProvider>(
                        builder: (context, value, child) => FutureBuilder(
                          future: value.getItem(bookmarkedItemIds[index]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.cyan,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return 'Error'.text.makeCentered();
                            } else {
                              FoundItemModel item = snapshot.data!;
                              return Expanded(
                                child: RecentPostCard(
                                  postId: item.id,
                                  imageUrl: item.imageUrl,
                                  foundItemModel: item,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ).pSymmetric(h: 5.w, v: 5.w),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      'Add Bookmarks'.text.size(8.w).bold.makeCentered(),
                      4.heightBox,
                      'Don\'t forget to bookmark the items you think might be the ones you\'ve lost!\nSo that you can find those easily over here.'
                          .text
                          .size(4.w)
                          .gray400
                          .align(TextAlign.center)
                          .bodyText2(context)
                          .makeCentered(),
                    ],
                  );
          }
        },
      ),
    );
  }
}
