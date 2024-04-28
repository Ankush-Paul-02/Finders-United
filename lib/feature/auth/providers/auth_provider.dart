import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home/screens/home.dart';
import '../models/user_model.dart';
import '../screens/login_screen.dart';
import '../screens/otp_screen.dart';

class AuthProvider with ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String _verificationId = "";
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool isAuthenticated() => _firebaseAuth.currentUser != null;

  /// GET USER WHEN USER IS LOGGED IN
  User get user => _firebaseAuth.currentUser!;

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

      await _firebaseAuth.signInWithCredential(
        credential,
      );
      saveUserData();
      if (!context.mounted) {
        return;
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// SAVE USER DATA DURING AUTHENTICATION
  Future<void> saveUserData() async {
    var firebaseUser = _firebaseAuth.currentUser;

    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(firebaseUser!.uid).get();
    if (!snapshot.exists) {
      UserModel userModel = UserModel(
        id: firebaseUser.uid,
        name: '',
        phone: firebaseUser.phoneNumber!,
        imageUrl: '',
      );
      _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(userModel.toMap());
      snapshot =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
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
