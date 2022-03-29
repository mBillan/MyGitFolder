import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fan_cate/widgets/material/basic/snackbar_show.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:device_info/device_info.dart';

Future<Uint8List> imageToBytes({required String imgPath}) async {
  File imgFile = File(imgPath);

  // convert to bytes
  return imgFile.readAsBytes();
}

Future<String> imageToBase64({required String imgPath}) async {
  Uint8List imageBytes = await imageToBytes(imgPath: imgPath);

  // convert bytes to base64 string
  return base64.encode(imageBytes);
}

Uint8List bytesToImage({required String base64string}) {
  // decode base64 string to bytes
  return base64.decode(base64string);
}

Future<String> imgFromCamera(BuildContext context) async {
  // Processing images is not available in the simulator
  bool physical = await isPhysicalDevice();
  if (physical) {
    ImagePicker picker = ImagePicker();
    File image = File((await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 300,
      maxWidth: 300,
    ))!
        .path);

    return image.path;
  } else {
    showSimpleSnackBar(
        context, "Image processing is not supported on the simulator");
    return '';
  }
}

Future<String> imgFromGallery(BuildContext context) async {
  // Processing images is not available in the simulator
  bool physical = await isPhysicalDevice();
  if (physical) {
    ImagePicker picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 300,
      maxWidth: 300,
    );

    return pickedImage?.path ?? '';
  } else {
    showSimpleSnackBar(
        context, "Image processing is not supported on the simulator");
    return '';
  }
}

Future<bool> isPhysicalDevice() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    if (iosInfo.isPhysicalDevice) {
      return true;
    }
  }

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.isPhysicalDevice) {
      return true;
    }
  }

  return false;
}
