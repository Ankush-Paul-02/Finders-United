import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/database_constants.dart';
import '../../core/utils/show_snack_bar.dart';
import '../auth/models/user_model.dart';
import '../upload/models/found_item_model.dart';

class UploadItemProvider extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  bool _isLoading = false;
  bool _isItemRequestClaimed = false;

  bool get isLoading => _isLoading;

  bool get isItemRequestClaimed => _isItemRequestClaimed;

  User get user => _firebaseAuth.currentUser!;

  /// SET LOADING
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// GET USER DATA
  Future<UserModel?> getUserData(String userId) async {
    try {
      // Access Firestore and retrieve user data using the userId
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(userId).get();

      if (snapshot.exists) {
        // Populate UserModel with fetched data
        return UserModel.fromMap(snapshot.data()!);
      } else {
        // User document does not exist
        return null;
      }
    } catch (e) {
      // Handle errors
      debugPrint('Error fetching user data: $e');
      return null;
    }
  }

  /// UPLOAD FOUND ITEM
  Future<bool> uploadFoundItem(
    FoundItemModel foundItemModel,
    File? imageFile,
    BuildContext context,
  ) async {
    try {
      _setLoading(true);
      String? imageUrl;
      if (imageFile != null) {
        String fileName =
            '${user.uid}_${DateTime.now().millisecondsSinceEpoch}';

        Reference ref = _storage
            .ref()
            .child('${DatabaseConstants.foundImagesStorage}/$fileName');

        UploadTask task = ref.putFile(imageFile);
        TaskSnapshot taskSnapshot = await task;
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      }

      UserModel? currentUser = await getUserData(user.uid);
      final itemId = const Uuid().v1();
      foundItemModel = foundItemModel.copyWith(
        id: itemId,
        imageUrl: imageUrl,
        founderId: user.uid,
        founderName: currentUser!.name,
        founderContact: currentUser.phone,
      );
      await _firestore
          .collection(DatabaseConstants.foundItemsFirestore)
          .doc(itemId)
          .set(foundItemModel.toMap());
      showSnackBar(context, 'Item uploaded successfully.');
      return true;
    } on FirebaseException catch (e) {
      showSnackBar(context, 'Failed to upload the item!');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// GET THE RECENT ITEMS
  Future<List<FoundItemModel>> recentFoundItems(
    BuildContext context,
  ) async {
    try {
      // _setLoading(true);
      CollectionReference reference =
          _firestore.collection(DatabaseConstants.foundItemsFirestore);
      QuerySnapshot snapshot = await reference.get();

      List<FoundItemModel> foundItems = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return FoundItemModel(
          id: data['id'],
          name: data['name'],
          description: data['description'],
          location: data['location'],
          date: data['date'],
          category: data['category'],
          imageUrl: data['imageUrl'],
          founderId: data['founderId'],
          founderName: data['founderName'],
          founderContact: data['founderContact'],
          claimableIds: List<String>.from(data['claimableIds']),
          isClaimed: data['isClaimed'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
          claimerPersonId: data['claimerPersonId'],
        );
      }).toList();
      return foundItems;
    } on FirebaseException catch (e) {
      showSnackBar(context, 'Error retrieving recent found items');
      return [];
    } finally {
      // _setLoading(false);
    }
  }

  Future<List<FoundItemModel>> getItemByCategory(
    String category,
    BuildContext context,
  ) async {
    try {
      CollectionReference reference =
          _firestore.collection(DatabaseConstants.foundItemsFirestore);
      QuerySnapshot snapshot = await reference.get();

      List<FoundItemModel> foundItems = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return FoundItemModel(
          id: data['id'],
          name: data['name'],
          description: data['description'],
          location: data['location'],
          date: data['date'],
          category: data['category'],
          imageUrl: data['imageUrl'],
          founderId: data['founderId'],
          founderName: data['founderName'],
          founderContact: data['founderContact'],
          claimableIds: List<String>.from(data['claimableIds']),
          isClaimed: data['isClaimed'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
          claimerPersonId: data['claimerPersonId'],
        );
      }).toList();
      foundItems =
          foundItems.where((item) => item.category == category).toList();
      return foundItems;
    } on FirebaseException catch (e) {
      showSnackBar(context, 'Error retrieving recent found items');
      return [];
    }
  }

  /// GET ITEM
  Future<FoundItemModel?> getItem(String itemId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(DatabaseConstants.foundItemsFirestore)
          .doc(itemId)
          .get();
      if (snapshot.exists) {
        return FoundItemModel.fromMap(snapshot.data()!);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      debugPrint('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> requestItemClaim(
    String userId,
    String itemId,
    BuildContext context,
  ) async {
    try {
      FoundItemModel? item = await getItem(itemId);
      if (item != null) {
        DocumentSnapshot snapshot = await _firestore
            .collection(DatabaseConstants.foundItemsFirestore)
            .doc(item.id)
            .get();
        if (snapshot.exists) {
          FoundItemModel foundItemModel = FoundItemModel.fromMap(
            snapshot.data() as Map<String, dynamic>,
          );

          if (foundItemModel.claimableIds.contains(userId)) {
            foundItemModel.claimableIds.remove(userId);
            _isItemRequestClaimed = false;
            notifyListeners();
          } else {
            foundItemModel.claimableIds.add(userId);
            _isItemRequestClaimed = true;
            notifyListeners();
          }

          await _firestore
              .collection(DatabaseConstants.foundItemsFirestore)
              .doc(item.id)
              .update(foundItemModel.toMap());
        }
      } else {
        showSnackBar(context, 'Item does not exist.');
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, 'Something went wrong!');
    }
  }
}
