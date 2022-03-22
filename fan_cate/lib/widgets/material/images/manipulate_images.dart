import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<String> imageToBytes({required String imgPath}) async {
  File imgFile = File(imgPath);

  //convert to bytes
  Uint8List imageBytes = await imgFile.readAsBytes();

  //convert bytes to base64 string
  return base64.encode(imageBytes);
}

Uint8List bytesToImage({required String base64string}) {
  // decode base64 stirng to bytes
  return base64.decode(base64string);
}

Future<String> imgFromCamera() async {
  // Camera is not available in the IOS simulator
  // TODO: Uncomment the following lines of code to enable picking an image from camrea
  // ImagePicker picker = ImagePicker();
  // File image = File((await picker.pickImage(
  //   source: ImageSource.camera,
  //   maxHeight: 300,
  //   maxWidth: 300,
  // ))!
  //     .path);
  //
  // return image.path;

  return '';
}

Future<String> imgFromGallery() async {
  // Processing images is not available in the IOS simulator
  // TODO: Uncomment the following lines of code to enable picking an image from camrea

  // ImagePicker picker = ImagePicker();
  // XFile? pickedImage = await picker.pickImage(
  //   source: ImageSource.gallery,
  //   maxHeight: 300,
  //   maxWidth: 300,
  // );
  //
  // return pickedImage?.path ?? '';

  return '';
}
