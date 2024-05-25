import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../home/widgets/recent_post_card.dart';
import '../../models/found_item_model.dart';
import '../../providers/item_provider.dart';

class ItemCategoryScreen extends StatefulWidget {
  final String category;

  const ItemCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<ItemCategoryScreen> createState() => _ItemCategoryScreenState();
}

class _ItemCategoryScreenState extends State<ItemCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<UploadItemProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: widget.category.text.make(),
        ),
        body: FutureBuilder<List<FoundItemModel>>(
          future: itemProvider.getItemByCategory(
            widget.category,
            context,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.cyan),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final recentItems = snapshot.data ?? [];
              if (recentItems.isEmpty) {
                return 'No items found for the category ${widget.category}'
                    .text
                    .size(4.w)
                    .gray400
                    .align(TextAlign.center)
                    .bodyText2(context)
                    .makeCentered();
              }
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
        ).pSymmetric(h: 5.w, v: 5.w),
      ),
    );
  }
}
