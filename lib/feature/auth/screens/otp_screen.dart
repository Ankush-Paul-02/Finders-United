import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OTPScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
  }

  Future<void> verifyOTP(AuthProvider authProvider) async {
    authProvider.verifyOTP(
      otp: _otpController.text.trim(),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.cyan,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return SafeArea(
      child: Consumer<AuthProvider>(
        builder: (context, state, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: const Icon(Icons.arrow_back).onTap(
              () => Navigator.pop(context),
            ),
          ),
          body: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.cyan,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      5.h.heightBox,
                      Lottie.asset(AppConstants.searchAnimation),
                      20.heightBox,
                      'Verification Code'.text.black.bold.size(22).make(),
                      5.heightBox,
                      'We have sent the verification code\nto your phone number ${widget.phoneNumber}'
                          .text
                          .size(16)
                          .gray500
                          .make(),
                      20.heightBox,
                      Pinput(
                        controller: _otpController,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        validator: (s) {
                          return null;
                        },
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsRetrieverApi,
                        length: 6,
                        keyboardType: TextInputType.number,
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        showCursor: true,
                        onCompleted: (pin) => verifyOTP(state),
                      )
                    ],
                  ).pSymmetric(h: 5.w),
                ),
        ),
      ),
    );
  }
}
