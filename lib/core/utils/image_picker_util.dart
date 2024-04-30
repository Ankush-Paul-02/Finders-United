import 'dart:io';

import 'package:finders_united/core/utils/show_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImageFromGallery(BuildContext context) async {
  try {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (xFile != null) {
      return File(xFile.path);
    }
    showSnackBar(context, 'Image is not selected!');
  } on PlatformException catch (e) {
    showSnackBar(context, 'Error picking image: ${e.message}');
  } catch (e) {
    showSnackBar(context, 'Error picking image: $e');
  }
  return null;
}
