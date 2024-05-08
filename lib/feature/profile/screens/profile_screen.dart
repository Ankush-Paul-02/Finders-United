import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../core/common/gradient_button.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/show_snack_bar.dart';
import '../../auth/models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../widgets/profile_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedImage != null) {
      setState(() => _image = File(pickedImage.path));
    } else {
      showSnackBar(context, 'Image is not selected!');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return FutureBuilder(
          future: authProvider.getUserData(authProvider.user.uid),
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
              return authProvider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.cyan,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () => getImageFromGallery(),
                                  child: CircleAvatar(
                                    radius: 25.w,
                                    backgroundImage: _image != null
                                        ? FileImage(_image!)
                                            as ImageProvider // Display gallery image if available
                                        : user.imageUrl != ""
                                            ? NetworkImage(user.imageUrl)
                                                as ImageProvider // Display Firebase image if available
                                            : AssetImage(
                                                AppConstants.profileImage,
                                              ), // Fallback to local asset image
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 34.w,
                                  child: Icon(
                                    Icons.camera,
                                    color: Colors.black,
                                    size: 8.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          40.heightBox,
                          'Name'.text.size(18).bodyText1(context).make(),
                          8.heightBox,
                          ProfileTextField(
                            isReadOnly: false,
                            hintText:
                                user.name == "" ? 'Enter your name' : user.name,
                            icon: Icons.person,
                            textInputType: TextInputType.name,
                            textEditingController: _nameController,
                          ),
                          16.heightBox,
                          'Phone'.text.size(18).bodyText1(context).make(),
                          8.heightBox,
                          ProfileTextField(
                            isReadOnly: true,
                            hintText: user.phone,
                            icon: Icons.phone,
                          ),
                          30.heightBox,
                          GestureDetector(
                            onTap: () {
                              authProvider.updateUser(
                                UserModel(
                                  id: authProvider.user.uid,
                                  name: _nameController.text.trim() == ""
                                      ? user.name
                                      : _nameController.text.trim(),
                                  phone: user.phone,
                                  imageUrl: _image != null
                                      ? _image!.path
                                      : user.imageUrl,
                                  bookmarkItems: user.bookmarkItems,
                                ),
                                context,
                                _image,
                              );
                            },
                            child: const GradientButton(
                              buttonName: 'SAVE CHANGES',
                            ),
                          ),
                          20.heightBox,
                          GestureDetector(
                            onTap: () => authProvider.logout(context: context),
                            child: const GradientButton(
                              buttonName: 'LOG OUT',
                              colors: [
                                Colors.red,
                                Colors.white,
                              ],
                            ),
                          ),
                        ],
                      ).pSymmetric(h: 5.w, v: 5.w),
                    );
            }
          },
        );
      },
    );
  }
}
