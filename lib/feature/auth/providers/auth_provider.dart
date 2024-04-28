import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home/screens/home.dart';
import '../screens/login_screen.dart';
import '../screens/otp_screen.dart';

class AuthProvider with ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  String _verificationId = "";
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool isAuthenticated() => _firebaseAuth.currentUser != null;

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
        verificationCompleted: (phoneAuthCredential) {},
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
