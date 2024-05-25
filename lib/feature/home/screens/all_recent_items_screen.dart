import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../models/found_item_model.dart';
import '../../providers/item_provider.dart';
import '../widgets/recent_post_card.dart';

class AllRecentItemsScreen extends StatefulWidget {
  final UploadItemProvider uploadItemProvider;

  const AllRecentItemsScreen({
    super.key,
    required this.uploadItemProvider,
  });

  @override
  State<AllRecentItemsScreen> createState() => _AllRecentItemsScreenState();
}

class _AllRecentItemsScreenState extends State<AllRecentItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: 'Recent Items'.text.make(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<List<FoundItemModel>>(
                future: widget.uploadItemProvider.recentFoundItems(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.cyan),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final recentItems = snapshot.data ?? [];
                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 7 / 10,
                      ),
                      itemCount: recentItems.length,
                      itemBuilder: (context, index) {
                        return RecentPostCard(
                          postId: recentItems[index].id,
                          imageUrl: recentItems[index].imageUrl,
                          foundItemModel: recentItems[index],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ).pSymmetric(h: 5.w, v: 5.w),
        ),
      ),
    );
  }
}
