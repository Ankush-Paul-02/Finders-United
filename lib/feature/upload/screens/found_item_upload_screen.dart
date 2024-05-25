import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:finders_united/feature/models/found_item_model.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../core/common/custom_text_field.dart';
import '../../../core/common/gradient_button.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/show_snack_bar.dart';
import '../../providers/item_provider.dart';

class FoundItemUploadScreen extends StatefulWidget {
  const FoundItemUploadScreen({super.key});

  @override
  State<FoundItemUploadScreen> createState() => _FoundItemUploadScreenState();
}

class _FoundItemUploadScreenState extends State<FoundItemUploadScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedCategory = AppConstants.categories[0];
  File? _itemImage;
  final picker = ImagePicker();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _locationController.dispose();
  }

  /// SELECT DATE
  Future<void> selectDate() async {
    DateTime? _dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (_dateTime != null) {
      setState(() {
        _dateController.text = _dateTime.toString().split(" ")[0];
      });
    }
  }

  /// PICK THE CURRENT LOCATION
  Future<void> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackBar(context, 'Location services are disabled.');
      await Geolocator.requestPermission();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        showSnackBar(context, 'Location permissions are permanently denied');
        return;
      }
      if (permission == LocationPermission.denied) {
        showSnackBar(context, 'Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnackBar(context, 'Location permissions are permanently denied');
      return;
    }

    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      setState(() {
        _locationController.text =
            '${placeMarks[0].name}, ${placeMarks[0].subLocality}, ${placeMarks[0].locality}, ${placeMarks[0].administrativeArea}, ${placeMarks[0].postalCode}';
      });
    } catch (e) {
      showSnackBar(context, 'Error getting location');
    }
  }

  /// GET ITEM IMAGE FROM GALLERY
  Future getItemImageFromGallery() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedImage != null) {
      setState(() => _itemImage = File(pickedImage.path));
    } else {
      showSnackBar(context, 'Image is not selected!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UploadItemProvider>(
      builder: (context, uploadItemProvider, child) {
        return uploadItemProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.cyan,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Image
                    'Image upload'.text.semiBold.size(20).make(),
                    20.heightBox,
                    SizedBox(
                      width: double.infinity,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        dashPattern: const [8, 6],
                        color: Colors.cyan,
                        strokeWidth: 2,
                        strokeCap: StrokeCap.round,
                        radius: const Radius.circular(12),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          child: _itemImage == null
                              ? Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.cyan.withOpacity(0.1),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 75,
                                        width: 75,
                                        child: Image.asset(
                                          AppConstants.browseIcon,
                                          color: Colors.cyan,
                                        ),
                                      ),
                                      8.heightBox,
                                      ElevatedButton(
                                        onPressed: () =>
                                            getItemImageFromGallery(),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.cyan,
                                          elevation: 1,
                                        ),
                                        child: 'Browse'
                                            .text
                                            .size(16)
                                            .white
                                            .semiBold
                                            .make(),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: Image.file(
                                    _itemImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    /// ITEM NAME
                    20.heightBox,
                    'Item name'.text.semiBold.size(20).make(),
                    4.heightBox,
                    CustomTextField(
                      controller: _nameController,
                      hintText: 'Enter the item name',
                      maxLines: 1,
                      icon: Icons.title,
                      textInputType: TextInputType.name,
                      readOnly: false,
                    ),
                    16.heightBox,

                    /// DESCRIPTION
                    'Item description'.text.semiBold.size(20).make(),
                    4.heightBox,
                    CustomTextField(
                      controller: _descriptionController,
                      hintText: 'Give the item description',
                      maxLines: 4,
                      icon: Icons.description_rounded,
                      readOnly: false,
                      textInputType: TextInputType.multiline,
                    ),
                    16.heightBox,

                    /// CATEGORY
                    'Category'.text.semiBold.size(20).make(),
                    4.heightBox,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
                      child: DropdownButton(
                        value: _selectedCategory,
                        iconEnabledColor: Colors.cyan,
                        iconDisabledColor: Colors.cyan,
                        underline: Container(
                          color: Colors.white,
                        ),
                        items: AppConstants.categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: category.text.make(),
                              ),
                            )
                            .toList(),
                        onChanged: (newCategory) =>
                            setState(() => _selectedCategory = newCategory!),
                      ),
                    ),
                    16.heightBox,

                    /// DATE
                    'Date'.text.semiBold.size(20).make(),
                    4.heightBox,
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
                      child: TextField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 5.w),
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: const Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.cyan,
                          ),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        onTap: () => selectDate(),
                      ),
                    ),

                    /// LOCATION
                    16.heightBox,
                    'Location'.text.semiBold.size(20).make(),
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
                      child: TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 5.w),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Pick the location',
                          prefixIcon: const Icon(
                            Icons.location_pin,
                            color: Colors.cyan,
                          ),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        maxLines: 2,
                        onTap: () {
                          getCurrentLocation(context);
                        },
                      ),
                    ),
                    20.heightBox,
                    GestureDetector(
                      onTap: () async {
                        if (_nameController.text.trim().isEmpty ||
                            _descriptionController.text.trim().isEmpty ||
                            _dateController.text.trim().isEmpty ||
                            _locationController.text.trim().isEmpty) {
                          showSnackBar(
                              context, 'Please provide all the information!');
                        } else {
                          FoundItemModel foundItemModel = FoundItemModel(
                            id: "",
                            name: _nameController.text.trim(),
                            description: _descriptionController.text.trim(),
                            location: _locationController.text.trim(),
                            date: _dateController.text.trim(),
                            category: _selectedCategory,
                            imageUrl: "",
                            founderId: "",
                            founderName: "",
                            founderContact: "",
                            claimableIds: [],
                            isClaimed: false,
                            createdAt: DateTime.now(),
                            claimerPersonId: "",
                          );
                          bool isUploaded =
                              await uploadItemProvider.uploadFoundItem(
                            foundItemModel,
                            _itemImage,
                            context,
                          );
                          if (isUploaded) {
                            _nameController.clear();
                            _descriptionController.clear();
                            setState(() {
                              _selectedCategory = AppConstants.categories[0];
                            });
                            _dateController.clear();
                            _locationController.clear();
                            setState(() {
                              _itemImage = null;
                            });
                          }
                        }
                      },
                      child: const GradientButton(
                        buttonName: 'UPLOAD',
                      ),
                    ),
                  ],
                ).pSymmetric(h: 5.w, v: 5.w),
              );
      },
    );
  }
}
