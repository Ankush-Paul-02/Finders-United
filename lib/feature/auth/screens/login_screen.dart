import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../core/common/black_gradient_button.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
  }

  Future<void> sendOTP(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    authProvider.sendOTP(
      phoneNumber: '+91${_phoneNumberController.text.trim()}',
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AuthProvider>(
        builder: (context, state, child) => Scaffold(
          backgroundColor: Colors.white,
          body: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.cyan,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      6.h.heightBox,
                      'Welcome to\nFindersUnited'
                          .text
                          .bold
                          .size(26)
                          .align(TextAlign.center)
                          .color(Colors.cyan)
                          .makeCentered(),
                      10.h.heightBox,
                      Lottie.asset('assets/animation/search.json'),
                      20.h.heightBox,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              offset: const Offset(1, 2),
                              spreadRadius: 2,
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: VxTextField(
                          controller: _phoneNumberController,
                          borderRadius: 10,
                          fillColor: Colors.white,
                          contentPaddingLeft: 10,
                          clear: false,
                          prefixIcon: const Icon(
                            Icons.phone_iphone_rounded,
                            color: Colors.grey,
                          ),
                          height: 60,
                          hint: 'Enter your phone number',
                          borderType: VxTextFieldBorderType.roundLine,
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      20.heightBox,
                      GestureDetector(
                        onTap: () => sendOTP(context, state),
                        child:
                            const BlackGradientButton(buttonName: 'SEND OTP'),
                      ),
                    ],
                  ).pSymmetric(h: 5.w, v: 5.w),
                ),
        ),
      ),
    );
  }
}
