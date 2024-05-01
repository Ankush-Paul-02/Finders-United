import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../core/common/black_gradient_button.dart';
import '../../../core/common/custom_text_field.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/show_snack_bar.dart';

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
  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        showSnackBar(context, 'Location Denied!');
        LocationPermission ask = await Geolocator.requestPermission();
      } else {
        Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true,
        );
        List<Placemark> placeMarks = await placemarkFromCoordinates(
          currentPosition.latitude,
          currentPosition.longitude,
        );
        setState(() {
          _locationController.text =
              '${placeMarks[0].name}, ${placeMarks[0].subLocality}, ${placeMarks[0].locality}, ${placeMarks[0].administrativeArea}, ${placeMarks[0].postalCode}';
        });
      }
    } catch (e) {
      showSnackBar(context, 'Error getting location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          'Image upload'.text.semiBold.size(20).make(),
          20.heightBox,

          /// Image
          DottedBorder(
            borderType: BorderType.RRect,
            dashPattern: const [8, 6],
            color: Colors.cyan,
            strokeWidth: 2,
            strokeCap: StrokeCap.round,
            radius: const Radius.circular(12),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Container(
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        elevation: 1,
                      ),
                      child: 'Browse'.text.size(16).white.semiBold.make(),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
          'Item description'.text.semiBold.size(20).make(),
          4.heightBox,

          /// DESCRIPTION
          CustomTextField(
            controller: _descriptionController,
            hintText: 'Give the item description',
            maxLines: 4,
            icon: Icons.description_rounded,
            readOnly: false,
            textInputType: TextInputType.multiline,
          ),
          16.heightBox,
          'Date'.text.semiBold.size(20).make(),
          8.heightBox,

          /// DATE
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

          16.heightBox,
          'Location'.text.semiBold.size(20).make(),
          8.heightBox,

          /// LOCATION
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
                contentPadding: EdgeInsets.symmetric(vertical: 5.w),
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
                getCurrentLocation();
              },
            ),
          ),
          20.heightBox,
          GestureDetector(
            onTap: () {},
            child: const BlackGradientButton(
              buttonName: 'UPLOAD',
            ),
          ),
        ],
      ).pSymmetric(h: 5.w, v: 5.w),
    );
  }
}
