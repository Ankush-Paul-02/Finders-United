import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../core/constants/database_constants.dart';
import '../../core/utils/show_snack_bar.dart';
import '../home/screens/home.dart';
import '../auth/models/user_model.dart';
import '../auth/screens/login_screen.dart';
import '../auth/screens/otp_screen.dart';

class AuthProvider with ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  String _verificationId = "";
  bool _isLoading = false;
  bool _isItemBookmarked = false;

  bool get isLoading => _isLoading;

  bool get isItemBookmarked => _isItemBookmarked;

  bool isAuthenticated() => _firebaseAuth.currentUser != null;

  /// GET USER WHEN USER IS LOGGED IN
  User get user => _firebaseAuth.currentUser!;

  /// GET USER DATA
  Future<UserModel?> getUserData(String userId) async {
    try {
      // Access Firestore and retrieve user data using the userId
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(DatabaseConstants.userFirestore)
          .doc(userId)
          .get();

      if (snapshot.exists) {
        // Populate UserModel with fetched data
        return UserModel.fromMap(snapshot.data()!);
      } else {
        // User document does not exist
        return null;
      }
    } on FirebaseException catch (e) {
      // Handle errors
      debugPrint('Error fetching user data: $e');
      return null;
    }
  }

  /// Method to send OTP
  Future<void> sendOTP({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    try {
      _setLoading(true);
      await _firebaseAuth.verifyPhoneNumber(
        timeout: const Duration(seconds: 120),
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {},
        codeSent: (verificationId, forceResendingToken) {
          _verificationId = verificationId;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                phoneNumber: phoneNumber,
                verificationId: _verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Method to verify OTP
  Future<void> verifyOTP({
    required String otp,
    required BuildContext context,
  }) async {
    try {
      _setLoading(true);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      // Sign in with the provided credential
      await _firebaseAuth.signInWithCredential(credential);

      // Get the updated Firebase user
      User? firebaseUser = _firebaseAuth.currentUser;

      // Check if user is not null
      if (firebaseUser != null) {
        // Save user data in Firestore
        await saveUserData();

        // Navigate to Home screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
          (route) => false,
        );
      } else {
        // Handle null user case
        debugPrint("User is null after verification.");
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// SAVE USER DATA DURING AUTHENTICATION
  Future<void> saveUserData() async {
    var firebaseUser = _firebaseAuth.currentUser;

    DocumentSnapshot snapshot = await _firestore
        .collection(DatabaseConstants.userFirestore)
        .doc(firebaseUser!.uid)
        .get();
    if (!snapshot.exists) {
      UserModel userModel = UserModel(
        id: firebaseUser.uid,
        name: '',
        phone: firebaseUser.phoneNumber!,
        imageUrl: '',
        bookmarkItems: [],
      );
      _firestore
          .collection(DatabaseConstants.userFirestore)
          .doc(firebaseUser.uid)
          .set(userModel.toMap());
      snapshot = await _firestore
          .collection(DatabaseConstants.userFirestore)
          .doc(firebaseUser.uid)
          .get();
    } else {
      UserModel userModel =
          UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      await _firestore
          .collection(DatabaseConstants.userFirestore)
          .doc(firebaseUser.uid)
          .update(userModel.toMap());
    }
  }

  /// Update user
  Future<void> updateUser(
    UserModel updatedUserModel,
    BuildContext context,
    File? imageFile,
  ) async {
    try {
      _setLoading(true);
      var firebaseUser = _firebaseAuth.currentUser;

      if (firebaseUser != null) {
        String? imageUrl;
        if (imageFile != null) {
          // UNIQUE FILE NAME
          String fileName =
              '${firebaseUser.uid}_${DateTime.now().millisecondsSinceEpoch}';

          /// CREATE A REFERENCE TO THE LOCATION IN FIREBASE STORAGE
          Reference ref = _storage
              .ref()
              .child('${DatabaseConstants.userImagesStorage}/$fileName');

          /// UPLOAD THE IMAGE TO FIREBASE STORAGE
          UploadTask task = ref.putFile(imageFile);

          /// GET THE DOWNLOAD URL
          TaskSnapshot snapshot = await task;
          imageUrl = await snapshot.ref.getDownloadURL();
        }
        updatedUserModel = updatedUserModel.copyWith(imageUrl: imageUrl);
        await _firestore
            .collection(DatabaseConstants.userFirestore)
            .doc(firebaseUser.uid)
            .update(updatedUserModel.toMap());
        showSnackBar(context, 'Profile updated successfully.');
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, 'Failed to update user. Please try again later.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleBookmarkItem(
    String itemId,
    BuildContext context,
  ) async {
    try {
      var currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot snapshot = await _firestore
            .collection(DatabaseConstants.userFirestore)
            .doc(currentUser.uid)
            .get();
        if (snapshot.exists) {
          UserModel userModel = UserModel.fromMap(
            snapshot.data() as Map<String, dynamic>,
          );

          if (userModel.bookmarkItems.contains(itemId)) {
            userModel.bookmarkItems.remove(itemId);
            _isItemBookmarked = false;
            notifyListeners();
          } else {
            userModel.bookmarkItems.add(itemId);
            _isItemBookmarked = true;
            notifyListeners();
          }

          await _firestore
              .collection(DatabaseConstants.userFirestore)
              .doc(currentUser.uid)
              .update(userModel.toMap());
        }
      } else {
        showSnackBar(context, 'Current user does not exist.');
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, 'Something went wrong!');
    }
  }

  /// LOGOUT
  Future<void> logout({
    required BuildContext context,
  }) async {
    await _firebaseAuth.signOut().then(
          (value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false,
          ),
        );
  }

  /// SET LOADING
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
