import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final _firebaseAuth = FirebaseAuth.instance;

  static String _verificationId = "";

  static Future sendOTP({
    required String phoneNumber,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      timeout: const Duration(seconds: 180),
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (error) {},
      codeSent: (verificationId, forceResendingToken) =>
          _verificationId = verificationId,
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }
}
